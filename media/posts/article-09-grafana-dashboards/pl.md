---
title: "Dashboardy Grafana dla mikroserwisów na Kubernetes"
date: 2026-04-01
category: "DevOps"
tags: [Grafana, Prometheus, Loki, dashboards, Kubernetes, nginx-ingress, monitoring, PromQL, LogQL]
locale: pl
---

Grafana bez dashboardów to pusty ekran. W tym artykule opiszę dwa dashboardy, które konfiguruję dla projektu portfolio: jeden oparty na metrykach Prometheusa z nginx-ingress, drugi na logach z Loki. Oba ładują się automatycznie z ConfigMap w Kubernetes.

## Automatyczny import przez sidecar

Helm chart `kube-prometheus-stack` instaluje Grafanę z sidecar containerem, który obserwuje ConfigMapy z labelem `grafana_dashboard=1`. Wystarczy stworzyć ConfigMap z plikiem JSON dashboardu:

```bash
kubectl create configmap grafana-dashboards -n monitoring \
  --from-file=portfolio-services.json \
  --from-file=loki-logs.json

kubectl label configmap grafana-dashboards -n monitoring grafana_dashboard=1
```

Sidecar wykrywa zmianę i importuje dashboard bez restartu Grafany. Aktualizacja to `kubectl delete configmap` + ponowne `create` + `label`.

## Dashboard 1: Portfolio Services

Dashboard do monitorowania ruchu HTTP przechodzącego przez nginx-ingress controller. Składa się z trzech sekcji.

![Portfolio Services Dashboard](/images/grafana-portfolio-services.png)

### Zmienne szablonowe

Dwie zmienne pozwalają filtrować wykresy:

```json
{
  "name": "namespace",
  "definition": "label_values(nginx_ingress_controller_requests,namespace)",
  "type": "query"
},
{
  "name": "service",
  "definition": "label_values(nginx_ingress_controller_requests{namespace=~\"$namespace\"},service)",
  "type": "query"
}
```

`namespace` pobiera listę namespace'ów, z których nginx-ingress rejestruje ruch. `service` filtruje się dynamicznie po wybranym namespace. W praktyce wybieram `portfolio` i widzę `frontend`, `blog`, `sso`, `analytics`.

### Request Rate by Status Code

```promql
sum(rate(nginx_ingress_controller_requests{
  service=~"$service",
  namespace=~"$namespace"
}[5m])) by (status)
```

`rate()` na 5 minut wygładza szum. Grupowanie `by (status)` rozbija wykres na linie 200, 301, 404, 500 itd. Panel typu `timeseries` z jednostką `reqps`.

### Response Time (Latency)

Trzy percentyle w jednym panelu:

```promql
# p50
histogram_quantile(0.50, sum(rate(
  nginx_ingress_controller_response_duration_seconds_bucket{
    service=~"$service", namespace=~"$namespace"
  }[5m])) by (le))

# p95
histogram_quantile(0.95, ...)

# p99
histogram_quantile(0.99, ...)
```

`histogram_quantile` wymaga grupowania `by (le)` — to etykieta bucket'ów histogramu. p50 to mediana, p95 pokazuje co odczuwa 95% użytkowników, p99 wyłapuje outlier'y.

### Error Rate (5xx)

```promql
sum(rate(nginx_ingress_controller_requests{
  service=~"$service", namespace=~"$namespace",
  status=~"5.."
}[5m]))
/
sum(rate(nginx_ingress_controller_requests{
  service=~"$service", namespace=~"$namespace"
}[5m]))
```

Stosunek 5xx do wszystkich requestów. Panel typu `gauge` z progiem na 5% (kolor zmienia się na czerwony). Wartość `NaN` oznacza brak ruchu — to normalne.

### Logi w dashboardzie

Dwa panele logów z Loki wbudowane w ten sam dashboard:

```logql
# Latest Logs
{namespace=~"$namespace", app=~"$service"}

# Error & Warning Logs
{namespace=~"$namespace", app=~"$service"}
  |~ "(?i)(error|exception|fatal|fail|warning)"
```

Panel typu `logs` wyświetla strumień logów w czasie rzeczywistym. Filtr `|~` to regex w LogQL.

### All Services Overview

Sekcja na dole — request rate i p95 latency dla wszystkich serwisów naraz:

```promql
sum(rate(nginx_ingress_controller_requests{
  namespace=~"$namespace"
}[5m])) by (service)
```

Stacking `mode: "normal"` pokazuje udział każdego serwisu w całkowitym ruchu.

## Dashboard 2: Loki Logs — Portfolio

Dashboard do przeglądania logów z Loki. Cztery panele, jedna zmienna `container`.

![Loki Logs Dashboard](/images/grafana-loki-logs.png)

### Zmienna container

```json
{
  "name": "container",
  "definition": "label_values({job=\"kubernetes-pods\"}, container)",
  "type": "query"
}
```

Pobiera listę kontenerów z Loki. Pozwala wybrać np. `frontend-app`, `blog-app`, `sso-app`.

### Logs

```logql
{container=~"$container"}
```

Surowy strumień logów z wybranego kontenera. Panel typu `logs` z automatycznym odświeżaniem.

### Log Volume

```logql
sum(count_over_time({container=~"$container"}[$__interval]))
```

Wykres słupkowy z liczbą logów per interwał. `$__interval` automatycznie dopasowuje się do zakresu czasu. Skok na wykresie = coś się dzieje.

### Error Logs

```logql
{container=~"$container"} |~ "(?i)(error|exception|fatal|fail)"
```

Filtrowany strumień — tylko linie z błędami. Szybki sposób na wyłapanie problemów bez przekopywania się przez tysiące linii info/debug.

### Log Volume by Container

```logql
sum by (container) (count_over_time({container=~".+"}[$__interval]))
```

Przegląd aktywności logowania wszystkich kontenerów. Pozwala szybko zobaczyć który serwis generuje najwięcej logów — często wskazuje na problem lub niepotrzebny debug logging.

## Aktualizacja dashboardu

Workflow edycji:

1. Edytuję dashboard w Grafanie (GUI)
2. Eksportuję JSON: Settings → JSON Model → Copy
3. Zapisuję do pliku `grafana/dashboards/*.json` w repozytorium
4. Aktualizuję ConfigMap w Kubernetes
5. Sidecar automatycznie importuje zmianę

Alternatywnie: edytuję JSON bezpośrednio i aktualizuję ConfigMap. Dashboard pojawia się w Grafanie bez dotykania GUI.
