# Dokumentacja Portfolio

## Dostępne dokumenty

### MINIKUBE_DEPLOYMENT
Kompletna dokumentacja wdrożenia mikrousług Portfolio na lokalne środowisko Minikube.

**Dostępne formaty:**
- `MINIKUBE_DEPLOYMENT.pdf` - Format PDF (747KB, 10 stron)
- `MINIKUBE_DEPLOYMENT.odt` - Format OpenDocument Text (30KB)
- `MINIKUBE_DEPLOYMENT.md` - Format Markdown (źródłowy)

**Zawartość:**
1. Podsumowanie Wdrożenia
2. Architektura Systemu
3. Instalacja i Konfiguracja (kubectl, Minikube)
4. Deployment Krok po Kroku (wszystkie polecenia)
5. Napotkane Problemy i Rozwiązania (szczegółowa diagnostyka)
6. Polecenia Administracyjne (kompletna lista)
7. Weryfikacja i Testy

**Data utworzenia:** 9 lutego 2026

## Jak korzystać

### Otwieranie dokumentów:

```bash
# PDF
xdg-open docs/MINIKUBE_DEPLOYMENT.pdf

# ODT (LibreOffice)
libreoffice docs/MINIKUBE_DEPLOYMENT.odt

# Markdown (edytor tekstu)
code docs/MINIKUBE_DEPLOYMENT.md
```

### Aktualizacja dokumentacji

Jeśli chcesz zaktualizować dokumentację:

1. Edytuj plik źródłowy: `MINIKUBE_DEPLOYMENT.md`
2. Wygeneruj ponownie PDF/ODT:

```bash
cd docs
./convert.sh  # Tworzy HTML
libreoffice --headless --convert-to pdf MINIKUBE_DEPLOYMENT.html --outdir .
libreoffice --headless --convert-to odt MINIKUBE_DEPLOYMENT.html --outdir .
```

## Zawartość katalogu

```
docs/
├── README.md                        # Ten plik
├── MINIKUBE_DEPLOYMENT.md           # Dokumentacja (Markdown)
├── MINIKUBE_DEPLOYMENT.pdf          # Dokumentacja (PDF)
├── MINIKUBE_DEPLOYMENT.odt          # Dokumentacja (ODT)
├── MINIKUBE_DEPLOYMENT.html         # Plik pośredni (HTML)
└── convert.sh                       # Skrypt konwersji MD → HTML
```

## Najważniejsze sekcje

### Dla nowych użytkowników:
1. **Instalacja i Konfiguracja** - jak zainstalować kubectl i Minikube
2. **Deployment Krok po Kroku** - dokładne polecenia do wykonania

### Dla troubleshootingu:
1. **Napotkane Problemy i Rozwiązania** - jak diagnozować i naprawiać błędy
2. **Polecenia Administracyjne** - przydatne komendy kubectl

### Dla zaawansowanych:
1. **Architektura Systemu** - diagramy i topologia
2. **Weryfikacja i Testy** - jak testować deployment
