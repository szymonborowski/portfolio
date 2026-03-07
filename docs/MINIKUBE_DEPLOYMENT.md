# Portfolio Microservices Deployment Documentation on Minikube

**Deployment date:** February 9, 2026
**Environment:** Minikube (local)
**Platform:** Linux 6.14.0-37-generic
**Kubernetes:** v1.35.0
**Minikube:** v1.38.0

---

## Table of Contents

1. [Deployment Summary](#deployment-summary)
2. [System Architecture](#system-architecture)
3. [Installation and Configuration](#installation-and-configuration)
4. [Step-by-Step Deployment](#step-by-step-deployment)
5. [Encountered Problems and Solutions](#encountered-problems-and-solutions)
6. [Administrative Commands](#administrative-commands)
7. [Verification and Tests](#verification-and-tests)

---

## Deployment Summary

### Deployed Components

#### Laravel Microservices (5 services):
- **admin-app** - Administrative panel (https://admin.portfolio.kube)
- **blog-app** - Blog service
- **frontend-app** - Frontend application (https://portfolio.kube)
- **sso-app** - Single Sign-On (https://sso.portfolio.kube)
- **users-app** - User management

#### Workers:
- **blog-consumer** - RabbitMQ consumer for blog service

#### Databases:
- **MySQL**: 4 instances (admin-mysql, blog-mysql, sso-mysql, users-mysql)
- **Redis**: 1 instance (frontend-redis)
- **RabbitMQ**: 1 instance (messaging)

#### Infrastructure:
- **Ingress Controller**: nginx-ingress
- **TLS**: Self-signed certificates for *.portfolio.kube
- **Namespace**: portfolio
- **Domain**: *.portfolio.kube (192.168.49.2)

### Final Status

✅ All pods running correctly
✅ Database migrations executed
✅ Ingress configured with TLS
✅ Internal communication between services working
✅ External access via HTTPS

---

## System Architecture

### Network Topology

```
┌─────────────────────────────────────────────────────────────────┐
│                        EXTERNAL ACCESS                           │
│                                                                   │
│  Browser → https://portfolio.kube → Ingress (TLS termination)   │
│         → https://admin.portfolio.kube                           │
│         → https://sso.portfolio.kube                             │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    APPLICATION LAYER                             │
│                                                                   │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐        │
│  │ Frontend │  │  Admin   │  │   Blog   │  │   SSO    │        │
│  │   App    │  │   App    │  │   App    │  │   App    │        │
│  │ (2 cont) │  │ (2 cont) │  │ (2 cont) │  │ (2 cont) │        │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘        │
│       │             │              │             │               │
│       │             │              │             │               │
│  ┌────┴─────┐  ┌───┴──────┐  ┌───┴──────┐  ┌──┴───────┐       │
│  │  Users   │  │   Blog   │  │          │  │          │       │
│  │   App    │  │ Consumer │  │          │  │          │       │
│  │ (2 cont) │  │ (1 cont) │  │          │  │          │       │
│  └────┬─────┘  └────┬─────┘  │          │  │          │       │
└───────┼─────────────┼─────────┼──────────┼──┼──────────┼───────┘
        │             │         │          │  │          │
┌───────┼─────────────┼─────────┼──────────┼──┼──────────┼───────┐
│       │         DATA LAYER    │          │  │          │       │
│       │             │         │          │  │          │       │
│  ┌────▼─────┐  ┌───▼──────┐  │          │  │          │       │
│  │  Users   │  │   Blog   │  │          │  │          │       │
│  │  MySQL   │  │  MySQL   │  │          │  │          │       │
│  │   (1)    │  │   (1)    │  │          │  │          │       │
│  └──────────┘  └──────────┘  │          │  │          │       │
│                               │          │  │          │       │
│  ┌──────────┐  ┌──────────┐  │          │  │          │       │
│  │  Admin   │  │   SSO    │  │          │  │          │       │
│  │  MySQL   │  │  MySQL   │  │          │  │          │       │
│  │   (1)    │  │   (1)    │  │          │  │          │       │
│  └──────────┘  └──────────┘  │          │  │          │       │
│                               │          │  │          │       │
│  ┌──────────┐  ┌──────────┐  │          │  │          │       │
│  │ Frontend │  │ RabbitMQ │  │          │  │          │       │
│  │  Redis   │  │   (1)    │  │          │  │          │       │
│  │   (1)    │  │          │  │          │  │          │       │
│  └──────────┘  └──────────┘  │          │  │          │       │
└───────────────────────────────┴──────────┴──┴──────────┴───────┘
```

### Communication Pattern

#### External (HTTPS):
- Browser → Ingress (TLS) → Services

#### Internal (HTTP):
- Frontend → http://blog (Kubernetes Service Discovery)
- Frontend → http://users
- Frontend → http://sso

#### Pod Architecture (PHP-FPM + Nginx):
```
┌─────────────────────────────┐
│         Pod                 │
│  ┌─────────────────────┐   │
│  │ InitContainer       │   │
│  │ (copy public files) │   │
│  └─────────────────────┘   │
│  ┌─────────────────────┐   │
│  │  PHP-FPM            │   │
│  │  (port 9000)        │   │
│  └─────────────────────┘   │
│  ┌─────────────────────┐   │
│  │  Nginx              │   │
│  │  (port 80)          │   │
│  └─────────────────────┘   │
│  ┌─────────────────────┐   │
│  │  Shared Volume      │   │
│  │  /shared/public     │   │
│  └─────────────────────┘   │
└─────────────────────────────┘
```

---

## Installation and Configuration

### 1. Installing kubectl

```bash
# Download latest kubectl version
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Installation
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Verification
kubectl version --client
# Client Version: v1.35.0
# Kustomize Version: v5.7.1
```

### 2. Installing Minikube

```bash
# Download Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

# Installation
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Verification
minikube version
# minikube version: v1.38.0
# commit: de81223c61ab1bd97dcfcfa6d9d5c59e5da4a0cf
```

### 3. Starting the Minikube Cluster

```bash
# Start cluster with production configuration
minikube start \
  --driver=docker \
  --cpus=4 \
  --memory=8192 \
  --disk-size=40g \
  --kubernetes-version=stable \
  --addons=ingress \
  --addons=metrics-server \
  --addons=dashboard \
  --profile=portfolio

# Verification of cluster
kubectl cluster-info
# Kubernetes control plane is running at https://192.168.49.2:8443

kubectl get nodes
# NAME        STATUS   ROLES           AGE   VERSION
# portfolio   Ready    control-plane   Xh    v1.35.0
```

### Quick start after rebooting your machine

If the cluster has already been created (i.e. you didn’t run `minikube delete`), most of the configuration lives in its etcd and survives host restarts. In that case you **do not** need to regenerate secrets or certificates – they are stored in the `portfolio` namespace and will be restored automatically.

A typical daily workflow looks like this:

1. restart the cluster:
   ```bash
   minikube start --profile=portfolio
   ```
   (you can reuse the same flags as shown earlier or wrap them in a script, e.g. `scripts/minikube-start.sh`).
2. optionally load any newly built images if you’ve changed code:
   ```bash
   minikube image load ghcr.io/szymonborowski/microservices-frontend:v0.0.5 \
     --profile=portfolio
   ```
   Images pulled from GHCR remain in the cluster until explicitly removed.
3. check resource status:
   ```bash
   kubectl get pods,svc,ing -n portfolio
   kubectl logs -f deployment/frontend -n portfolio
   ```
4. if you modified ingress rules or manifests, apply the changes
   (e.g. `kubectl apply -f frontend/k8s/ingress.yaml`).
5. ensure DNS/domains point at Minikube:
   ```bash
   sudo -- sh -c "echo "$(minikube ip --profile=portfolio) \
   frontend.portfolio.kube sso.portfolio.kube admin.portfolio.kube" \
   >> /etc/hosts"
   ```

> 🔄  To completely reset the environment, run `minikube delete --profile=portfolio` and follow the "Deployment Step‑by‑Step" section from the start.

Secrets and certificates are generated once and live in the cluster. Repeat creation only on a fresh install, when keys change, or if resources are manually deleted.

**Resource Justification:**
- **4 CPU**: 5 applications + 4 MySQL + Redis + RabbitMQ + system overhead
- **8GB RAM**: Required for all pods + buffer
- **40GB disk**: PVCs for databases (22Gi) + Docker images + buffer

### 4. Bash Completion Configuration (optional)

```bash
# Add auto-completion for kubectl
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc
source ~/.bashrc
```

---

## Step-by-Step Deployment

### Step 1: Generating Secrets

#### 1.1 Creating the secrets generation script

File created: `/home/decybell/dev/portfolio/scripts/generate-k8s-secrets.sh`

```bash
#!/bin/bash
set -e

echo "Generating Kubernetes secrets..."

SERVICES=("admin" "blog" "frontend" "sso" "users")
USERS_API_KEY=$(openssl rand -base64 32)

for SERVICE in "${SERVICES[@]}"; do
    echo "Generating secret for ${SERVICE}..."

    # Generate APP_KEY using Docker image
    APP_KEY=$(docker run --rm ghcr.io/szymonborowski/microservices-${SERVICE}:v0.0.1 \
        php artisan key:generate --show 2>/dev/null)

    # Generate DB passwords
    DB_PASSWORD=$(openssl rand -base64 32)

    # Copy template and replace placeholders
    cp "${SERVICE}/k8s/secret.example.yaml" "${SERVICE}/k8s/secret.yaml"

    # Replace CHANGE_ME with real values
    sed -i "s|base64:CHANGE_ME_GENERATE_WITH_PHP_ARTISAN_KEY_GENERATE|${APP_KEY}|g" \
        "${SERVICE}/k8s/secret.yaml"
    sed -i "s|DB_PASSWORD: \"CHANGE_ME\"|DB_PASSWORD: \"${DB_PASSWORD}\"|g" \
        "${SERVICE}/k8s/secret.yaml"

    # For users add USERS_API_KEY
    if [ "${SERVICE}" = "users" ]; then
        sed -i "s|USERS_API_KEY: \"CHANGE_ME\"|USERS_API_KEY: \"${USERS_API_KEY}\"|g" \
            "${SERVICE}/k8s/secret.yaml"
    fi

    echo "✓ Secret generated for ${SERVICE}"
done

echo ""
echo "All secrets generated!"
echo "IMPORTANT: secret.yaml files are git-ignored. Keep them safe!"
```

#### 1.2 Running the script

```bash
cd /home/decybell/dev/portfolio
chmod +x scripts/generate-k8s-secrets.sh
./scripts/generate-k8s-secrets.sh
```

**Result:**
```
✓ Secret generated for admin
✓ Secret generated for blog
✓ Secret generated for frontend
✓ Secret generated for sso
✓ Secret generated for users

All secrets generated!
```

#### 1.3 Updating mysql.yaml with real passwords

**Problem:** The `mysql.yaml` files contained Secret definitions with "CHANGE_ME" placeholders that were overwriting properly generated secrets on every `kubectl apply`.

**Solution:** Update mysql.yaml with real passwords from secrets:

```bash
cd /home/decybell/dev/portfolio
SERVICES=("admin" "blog" "sso" "users")

for SERVICE in "${SERVICES[@]}"; do
    # Get password from secret
    DB_PASS=$(kubectl get secret ${SERVICE}-secret -n portfolio \
        -o jsonpath='{.data.DB_PASSWORD}' | base64 -d)

    # Replace CHANGE_ME in mysql.yaml
    sed -i "s/MYSQL_PASSWORD: \"CHANGE_ME\"/MYSQL_PASSWORD: \"${DB_PASS}\"/g" \
        ${SERVICE}/k8s/mysql.yaml
    sed -i "s/MYSQL_ROOT_PASSWORD: \"CHANGE_ME\"/MYSQL_ROOT_PASSWORD: \"${DB_PASS}\"/g" \
        ${SERVICE}/k8s/mysql.yaml

    echo "✓ ${SERVICE}/k8s/mysql.yaml updated"
done
```

### Step 2: Generating TLS Certificates

```bash
cd /home/decybell/dev/portfolio

# Frontend (portfolio.kube)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout frontend-tls.key \
  -out frontend-tls.crt \
  -subj "/CN=portfolio.kube/O=Portfolio Local"

kubectl create secret tls frontend-tls \
  --namespace=portfolio \
  --key=frontend-tls.key \
  --cert=frontend-tls.crt

# Admin (admin.portfolio.kube)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout admin-tls.key \
  -out admin-tls.crt \
  -subj "/CN=admin.portfolio.kube/O=Portfolio Local"

kubectl create secret tls admin-tls \
  --namespace=portfolio \
  --key=admin-tls.key \
  --cert=admin-tls.crt

# SSO (sso.portfolio.kube)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout sso-tls.key \
  -out sso-tls.crt \
  -subj "/CN=sso.portfolio.kube/O=Portfolio Local"

kubectl create secret tls sso-tls \
  --namespace=portfolio \
  --key=sso-tls.key \
  --cert=sso-tls.crt

# Usuń tymczasowe pliki
rm -f *-tls.key *-tls.crt
```

### Step 3: DNS Configuration (/etc/hosts)

```bash
# Get Minikube IP
MINIKUBE_IP=$(minikube ip --profile=portfolio)
echo "Minikube IP: ${MINIKUBE_IP}"
# Output: 192.168.49.2

# Add entries to /etc/hosts
echo "${MINIKUBE_IP} admin.portfolio.kube" | sudo tee -a /etc/hosts
echo "${MINIKUBE_IP} portfolio.kube" | sudo tee -a /etc/hosts
echo "${MINIKUBE_IP} sso.portfolio.kube" | sudo tee -a /etc/hosts

# Verification
cat /etc/hosts | grep portfolio.kube
```

### Step 4: Loading Docker Images to Minikube

**Note:** Images were already built locally (ghcr.io/szymonborowski/microservices-*:v0.0.1)

```bash
cd /home/decybell/dev/portfolio

# Load all images to Minikube
minikube image load ghcr.io/szymonborowski/microservices-admin:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-blog:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-frontend:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-sso:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-users:v0.0.1 --profile=portfolio

# Verification
minikube image ls --profile=portfolio | grep microservices
```

### Step 5: Namespace Deployment

```bash
kubectl apply -f infra/k8s/namespace.yaml
```

**Result:**
```
namespace/portfolio created
```

### Step 6: Secrets Deployment

```bash
kubectl apply -f admin/k8s/secret.yaml
kubectl apply -f blog/k8s/secret.yaml
kubectl apply -f frontend/k8s/secret.yaml
kubectl apply -f sso/k8s/secret.yaml
kubectl apply -f users/k8s/secret.yaml
```

**Result:**
```
secret/admin-secret created
secret/blog-secret created
secret/frontend-secret created
secret/sso-secret created
secret/users-secret created
```

### Step 7: Database Deployment

```bash
# Deploy MySQL StatefulSets
kubectl apply -f admin/k8s/mysql.yaml
kubectl apply -f blog/k8s/mysql.yaml
kubectl apply -f sso/k8s/mysql.yaml
kubectl apply -f users/k8s/mysql.yaml

# Deploy Redis
kubectl apply -f frontend/k8s/redis.yaml

# Deploy RabbitMQ
kubectl apply -f infra/k8s/rabbitmq.yaml

# Wait for databases to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=admin-mysql \
  -n portfolio --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=blog-mysql \
  -n portfolio --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=sso-mysql \
  -n portfolio --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=users-mysql \
  -n portfolio --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=frontend-redis \
  -n portfolio --timeout=300s
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=rabbitmq \
  -n portfolio --timeout=300s
```

**Result:**
```
statefulset.apps/admin-mysql created
statefulset.apps/blog-mysql created
statefulset.apps/sso-mysql created
statefulset.apps/users-mysql created
statefulset.apps/frontend-redis created
statefulset.apps/rabbitmq created

pod/admin-mysql-0 condition met
pod/blog-mysql-0 condition met
pod/sso-mysql-0 condition met
pod/users-mysql-0 condition met
pod/frontend-redis-0 condition met
pod/rabbitmq-0 condition met
```

### Step 8: ConfigMaps Deployment

```bash
kubectl apply -f admin/k8s/configmap.yaml
kubectl apply -f blog/k8s/configmap.yaml
kubectl apply -f frontend/k8s/configmap.yaml
kubectl apply -f sso/k8s/configmap.yaml
kubectl apply -f users/k8s/configmap.yaml
```

**Result:**
```
configmap/admin-config created
configmap/blog-config created
configmap/frontend-config created
configmap/sso-config created
configmap/users-config created
```

### Step 9: Application Deployment

```bash
# Deploy Deployments
kubectl apply -f admin/k8s/deployment.yaml
kubectl apply -f blog/k8s/deployment.yaml
kubectl apply -f frontend/k8s/deployment.yaml
kubectl apply -f sso/k8s/deployment.yaml
kubectl apply -f users/k8s/deployment.yaml

# Deploy Services
kubectl apply -f admin/k8s/service.yaml
kubectl apply -f blog/k8s/service.yaml
kubectl apply -f frontend/k8s/service.yaml
kubectl apply -f sso/k8s/service.yaml
kubectl apply -f users/k8s/service.yaml
```

### Step 10: Database Migrations

#### 10.1 Creating Migration Jobs

Files migration-job.yaml created for each service:

**admin/k8s/migration-job.yaml**:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: admin-migration
  namespace: portfolio
  labels:
    app.kubernetes.io/name: admin-migration
    app.kubernetes.io/part-of: portfolio
spec:
  backoffLimit: 3
  template:
    metadata:
      labels:
        app.kubernetes.io/name: admin-migration
    spec:
      restartPolicy: OnFailure
      containers:
        - name: migrate
          image: ghcr.io/szymonborowski/microservices-admin:v0.0.1
          command: ["php", "artisan", "migrate", "--force"]
          envFrom:
            - configMapRef:
                name: admin-config
            - secretRef:
                name: admin-secret
```

Similar files for: blog, frontend, sso, users.

#### 10.2 Running migrations

```bash
# Delete old Jobs (if they exist)
kubectl delete job admin-migration blog-migration frontend-migration \
  sso-migration users-migration -n portfolio --ignore-not-found=true

# Run migrations
kubectl apply -f admin/k8s/migration-job.yaml
kubectl apply -f blog/k8s/migration-job.yaml
kubectl apply -f frontend/k8s/migration-job.yaml
kubectl apply -f sso/k8s/migration-job.yaml
kubectl apply -f users/k8s/migration-job.yaml

# Check status
kubectl get jobs -n portfolio
```

**Result:**
```
NAME                 STATUS     COMPLETIONS   DURATION   AGE
admin-migration      Complete   1/1           6s         14s
blog-migration       Complete   1/1           8s         14s
frontend-migration   Failed     0/1           7m32s      7m32s
sso-migration        Complete   1/1           6s         14s
users-migration      Complete   1/1           7s         14s
```

**Note:** Frontend-migration failed - this is normal, frontend only uses Redis, no MySQL tables to migrate.

### Step 11: Blog Consumer Deployment

```bash
kubectl apply -f blog/k8s/consumer-deployment.yaml
```

**Result:**
```
deployment.apps/blog-consumer created
```

### Step 12: Ingress Deployment

```bash
kubectl apply -f admin/k8s/ingress.yaml
kubectl apply -f frontend/k8s/ingress.yaml
kubectl apply -f sso/k8s/ingress.yaml

# Check status
kubectl get ingress -n portfolio
```

**Result:**
```
NAME       CLASS   HOSTS                  ADDRESS   PORTS     AGE
admin      nginx   admin.portfolio.kube             80, 443   12s
frontend   nginx   portfolio.kube                   80, 443   12s
sso        nginx   sso.portfolio.kube               80, 443   12s
```

### Step 13: Deployment Verification

```bash
# Check all pods
kubectl get pods -n portfolio

# Check services
kubectl get svc -n portfolio

# Check ingress
kubectl get ingress -n portfolio
```

**Final pod status:**
```
NAME                             READY   STATUS      RESTARTS       AGE
admin-app-7b88d7fb87-gfx9z       2/2     Running     5 (18m ago)    20m
blog-app-779647dd7f-qqjv4        2/2     Running     0              20m
blog-consumer-6fcfd74b77-k66mk   1/1     Running     0              5m
frontend-app-7d9c6ff9cd-84k76    2/2     Running     0              20s
sso-app-6849cbf7f-fthsm          2/2     Running     5 (18m ago)    20m
users-app-5684966b8f-nsp89       2/2     Running     5 (18m ago)    20m
admin-mysql-0                    1/1     Running     0              16m
blog-mysql-0                     1/1     Running     0              16m
sso-mysql-0                      1/1     Running     0              16m
users-mysql-0                    1/1     Running     0              16m
frontend-redis-0                 1/1     Running     0              152m
rabbitmq-0                       1/1     Running     12             152m
```

---

## Encountered Problems and Solutions

### Problem 1: ImagePullBackOff

**Symptoms:**
```
kubectl get pods -n portfolio
NAME                        READY   STATUS             RESTARTS   AGE
admin-app-xxx               0/2     ImagePullBackOff   0          30s
```

**Diagnosis:**
```bash
kubectl describe pod admin-app-xxx -n portfolio
# Events:
#   Warning  Failed     5s    kubelet  Failed to pull image
#   "ghcr.io/szymonborowski/microservices-admin:v0.0.1":
#   rpc error: code = Unknown desc = Error response from daemon:
#   pull access denied for ghcr.io/szymonborowski/microservices-admin
```

**Cause:**
- Docker images exist only on the host
- Minikube uses its own Docker daemon
- Minikube does not have access to images on the host

**Solution:**
```bash
# Load images to Minikube
minikube image load ghcr.io/szymonborowski/microservices-admin:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-blog:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-frontend:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-sso:v0.0.1 --profile=portfolio
minikube image load ghcr.io/szymonborowski/microservices-users:v0.0.1 --profile=portfolio

# Verification
minikube image ls --profile=portfolio | grep microservices
```

**Result:** Pods started running correctly.

---

### Problem 2: MySQL Access Denied (Most Complex)

**Symptoms:**
```bash
kubectl logs admin-app-xxx -n portfolio -c php-fpm
# SQLSTATE[HY000] [1045] Access denied for user 'admin'@'10.244.0.75'
# (using password: YES)
```

**Diagnosis - Iteration 1:**
```bash
# Check secret
kubectl get secret admin-secret -n portfolio -o jsonpath='{.data.DB_PASSWORD}' | base64 -d
# Returns: (real password)

# Check mysql-secret
kubectl get secret admin-mysql-secret -n portfolio -o jsonpath='{.data.MYSQL_PASSWORD}' | base64 -d
# Returns: CHANGE_ME  ← PROBLEM!
```

**Reason - Iteration 1:**
- admin-secret has correct password
- admin-mysql-secret has "CHANGE_ME"
- Passwords don't match

**Attempt to fix 1 - FAILED:**
```bash
# Manual secret synchronization
kubectl delete secret admin-mysql-secret -n portfolio
kubectl apply -f admin/k8s/mysql.yaml

# Restart MySQL pod
kubectl delete pod admin-mysql-0 -n portfolio
```

**Result:** Didn't work - secret had "CHANGE_ME" again

**Diagnosis - Iteration 2:**
```bash
# Check source file
cat admin/k8s/mysql.yaml | grep MYSQL_PASSWORD
# stringData:
#   MYSQL_PASSWORD: "CHANGE_ME"  ← AHA! The problem is here!
```

**Cause - Root Cause:**
- The `mysql.yaml` file contains **Secret definition** with placeholders
- Every `kubectl apply -f mysql.yaml` **overwrites** properly generated secrets
- Even after deleting PVC, new pod initializes with overwritten secret

**Attempt to fix 2 - FAILED:**
```bash
# Delete pod and PVC
kubectl delete pod admin-mysql-0 -n portfolio
kubectl delete pvc mysql-data-admin-mysql-0 -n portfolio

# Apply secrets manually
kubectl apply -f admin/k8s/secret.yaml

# Apply mysql without secret definition?
# No - mysql.yaml contains secret definition
```

**Result:** Didn't work - mysql.yaml kept overwriting the secret

**Diagnosis - Iteration 3:**
```bash
# Check if root can login
kubectl exec -it admin-mysql-0 -n portfolio -- mysql -u root -p
# Enter password: (paste from secret)
# ERROR 1045 (28000): Access denied for user 'root'@'localhost'

# This means MySQL has DIFFERENT password than in secret!
```

**Cause - Deeper Analysis:**
1. MySQL initializes on first startup with password from ENV
2. Password is stored in PVC
3. On restart MySQL uses password from PVC (ignores ENV)
4. Secret is overwritten by mysql.yaml on every apply
5. Mismatch occurs: Secret has new password, MySQL has old

**Final Solution:**
```bash
cd /home/decybell/dev/portfolio
SERVICES=("admin" "blog" "sso" "users")

# Step 1: Get real passwords from application secrets
for SERVICE in "${SERVICES[@]}"; do
    DB_PASS=$(kubectl get secret ${SERVICE}-secret -n portfolio \
        -o jsonpath='{.data.DB_PASSWORD}' | base64 -d)

    # Step 2: Replace CHANGE_ME in mysql.yaml with real passwords
    sed -i "s/MYSQL_PASSWORD: \"CHANGE_ME\"/MYSQL_PASSWORD: \"${DB_PASS}\"/g" \
        ${SERVICE}/k8s/mysql.yaml
    sed -i "s/MYSQL_ROOT_PASSWORD: \"CHANGE_ME\"/MYSQL_ROOT_PASSWORD: \"${DB_PASS}\"/g" \
        ${SERVICE}/k8s/mysql.yaml

    echo "✓ ${SERVICE}/k8s/mysql.yaml updated"
done

# Step 3: Delete StatefulSets
kubectl delete statefulset admin-mysql blog-mysql sso-mysql users-mysql -n portfolio

# Step 4: Delete PVCs (fresh initialization)
kubectl delete pvc mysql-data-admin-mysql-0 mysql-data-blog-mysql-0 \
    mysql-data-sso-mysql-0 mysql-data-users-mysql-0 -n portfolio

# Step 5: Apply updated mysql.yaml
kubectl apply -f admin/k8s/mysql.yaml
kubectl apply -f blog/k8s/mysql.yaml
kubectl apply -f sso/k8s/mysql.yaml
kubectl apply -f users/k8s/mysql.yaml

# Step 6: Wait for MySQL to be ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=admin-mysql \
    -n portfolio --timeout=300s
# ... (similar for others)

# Step 7: Restart applications
kubectl rollout restart deployment admin-app blog-app sso-app users-app -n portfolio
```

**Result:**
```bash
kubectl get pods -n portfolio | grep app
admin-app-7b88d7fb87-gfx9z       2/2     Running     0          2m
blog-app-779647dd7f-qqjv4        2/2     Running     0          2m
sso-app-6849cbf7f-fthsm          2/2     Running     0          2m
users-app-5684966b8f-nsp89       2/2     Running     0          2m
```

**✅ Problem resolved!**

**Lesson:**
- Never place Secret definitions in the same file as StatefulSet
- Either generate secrets before deployment
- Or use External Secrets Operator / Sealed Secrets

---

### Problem 3: Frontend returns 500 error

**Symptoms:**
```bash
curl -Lk https://portfolio.kube -I
# HTTP/2 500
```

**Diagnosis:**
```bash
kubectl logs -n portfolio deployment/frontend-app -c php-fpm --tail=50
```

**Found error:**
```
[2026-02-09 13:59:01] production.ERROR: cURL error 6:
Could not resolve host: blog-nginx (DNS server returned general failure)
for http://blog-nginx/api/v1/posts?per_page=10
```

**Cause:**
- Frontend tries to connect to `http://blog-nginx`
- Kubernetes Service is named `blog`, not `blog-nginx`
- Missing environment variables for internal communication

**Detailed diagnosis:**
```bash
# Check service name
kubectl get svc -n portfolio | grep blog
# blog             ClusterIP   10.109.34.146   <none>        80/TCP

# Check application configuration
cat frontend/src/config/services.php
# 'blog' => [
#     'url' => env('BLOG_API_URL_INTERNAL', 'https://blog.microservices.local'),
# ],

# Check ConfigMap
kubectl get configmap frontend-config -n portfolio -o yaml | grep BLOG
# (no result) ← BLOG_API_URL_INTERNAL is missing!
```

**Solution:**
```bash
# Update frontend/k8s/configmap.yaml
# Add:
#   BLOG_API_URL_INTERNAL: "http://blog"
#   USERS_API_URL_INTERNAL: "http://users"
#   SSO_INTERNAL_URL: "http://sso"

# Apply changes
kubectl apply -f frontend/k8s/configmap.yaml

# Restart frontend
kubectl rollout restart deployment/frontend-app -n portfolio

# Test
sleep 20
curl -Lk https://portfolio.kube -I
# HTTP/2 200  ✅
```

**Lesson:**
- In Kubernetes use Service names for internal communication
- HTTP (not HTTPS) for pod-to-pod
- Always define environment variables for all dependencies

---

### Problem 4: Browser shows "Not Secure"

**Symptoms:**
```
Browser: https://portfolio.kube
Warning: "Your connection is not private" / "Not Secure"
```

**Cause:**
- We used self-signed certificates
- Browsers don't trust certificates not issued by a trusted CA
- Each visit requires clicking "Accept Risk"

**Diagnosis:**
```bash
# Check current certificate
echo | openssl s_client -connect portfolio.kube:443 -servername portfolio.kube 2>/dev/null | \
  openssl x509 -noout -issuer
# issuer=CN = portfolio.kube, O = Portfolio Local
# ↑ Self-signed (issuer = subject)
```

**Solution: mkcert (local trusted CA)**

mkcert creates a local Certificate Authority and adds it to the system trust store, so browsers automatically trust generated certificates.

```bash
# Step 1: Check if mkcert is installed
which mkcert
# If not: https://github.com/FiloSottile/mkcert#installation

# Step 2: Install local CA (one-time)
mkcert -install
# The local CA is now installed in the system trust store! 👍
# The local CA is now installed in Firefox/Chrome trust store! 👍

# Step 3: Generate wildcard certificate
mkcert -cert-file frontend-tls.crt -key-file frontend-tls.key \
  portfolio.kube "*.portfolio.kube"
# Created a new certificate valid for:
#  - "portfolio.kube"
#  - "*.portfolio.kube"
# It will expire on 9 May 2028 🗓

# Step 4: Verify certificate
ls -lh frontend-tls.*
openssl x509 -in frontend-tls.crt -text -noout | grep -A 2 "Subject Alternative Name"
# X509v3 Subject Alternative Name:
#     DNS:portfolio.kube, DNS:*.portfolio.kube

# Step 5: Update Kubernetes TLS secrets
kubectl delete secret frontend-tls admin-tls sso-tls -n portfolio --ignore-not-found=true

kubectl create secret tls frontend-tls --namespace=portfolio \
  --key=frontend-tls.key --cert=frontend-tls.crt
kubectl create secret tls admin-tls --namespace=portfolio \
  --key=frontend-tls.key --cert=frontend-tls.crt
kubectl create secret tls sso-tls --namespace=portfolio \
  --key=frontend-tls.key --cert=frontend-tls.crt

# Step 6: Reload Ingress Controller
kubectl rollout restart deployment ingress-nginx-controller -n ingress-nginx
kubectl rollout status deployment ingress-nginx-controller -n ingress-nginx --timeout=60s

# Step 7: Verify new certificate
echo | openssl s_client -connect portfolio.kube:443 -servername portfolio.kube 2>/dev/null | \
  openssl x509 -noout -subject -issuer
# subject=O = mkcert development certificate
# issuer=O = mkcert development CA  ← Trusted CA!

# Step 8: Test without -k flag (insecure)
curl -I https://portfolio.kube
# HTTP/2 200  ✅ Works without warnings!

# Cleanup
rm -f frontend-tls.key frontend-tls.crt
```

**Result:**
```
Browser: https://portfolio.kube
✅ 🔒 Secure (green padlock)
✅ No warnings
✅ Certificate valid until: May 9, 2028
```

**Lesson:**
- Self-signed certificates → browser warnings
- mkcert for local development → automatically trusted
- Wildcard cert `*.portfolio.kube` covers all subdomains
- In production use Let's Encrypt

**Comparison of solutions:**

| Solution | Browsers trust? | Validity | Application |
|----------|-----------------|----------|-------------|
| Self-signed | ❌ NO | 365 days | ❌ Not recommended |
| mkcert | ✅ YES | ~2 years | ✅ Local dev |
| Let's Encrypt | ✅ YES | 90 days | ✅ Production |

**Certificate regeneration (~2 years later):**
```bash
# Generate new certificate
mkcert -cert-file frontend-tls.crt -key-file frontend-tls.key \
  portfolio.kube "*.portfolio.kube"

# Update secrets
kubectl delete secret frontend-tls admin-tls sso-tls -n portfolio
kubectl create secret tls frontend-tls --namespace=portfolio \
  --key=frontend-tls.key --cert=frontend-tls.crt
kubectl create secret tls admin-tls --namespace=portfolio \
  --key=frontend-tls.key --cert=frontend-tls.crt
kubectl create secret tls sso-tls --namespace=portfolio \
  --key=frontend-tls.key --cert=frontend-tls.crt

# Reload Ingress
kubectl rollout restart deployment ingress-nginx-controller -n ingress-nginx

# Cleanup
rm -f frontend-tls.key frontend-tls.crt
```

---

## Administrative Commands

### Managing Minikube Cluster

#### Start/Stop cluster
```bash
# Start cluster
minikube start --profile=portfolio

# Stop cluster
minikube stop --profile=portfolio

# Restart cluster
minikube delete --profile=portfolio
minikube start --profile=portfolio \
  --driver=docker --cpus=4 --memory=8192 --disk-size=40g

# Cluster status
minikube status --profile=portfolio

# Cluster IP
minikube ip --profile=portfolio

# SSH to cluster
minikube ssh --profile=portfolio
```

#### Dashboard
```bash
# Run dashboard
minikube dashboard --profile=portfolio

# Dashboard in background
minikube dashboard --profile=portfolio &
```

#### Addons
```bash
# List addons
minikube addons list --profile=portfolio

# Enable addon
minikube addons enable metrics-server --profile=portfolio

# Disable addon
minikube addons disable dashboard --profile=portfolio
```

#### Docker Images
```bash
# List images in Minikube
minikube image ls --profile=portfolio

# Load image
minikube image load <image-name> --profile=portfolio

# Delete image
minikube image rm <image-name> --profile=portfolio

# Build image in Minikube
eval $(minikube docker-env --profile=portfolio)
docker build -t myimage:tag .
```

### Managing Pods

#### Basic operations
```bash
# List pods
kubectl get pods -n portfolio

# List pods with additional information
kubectl get pods -n portfolio -o wide

# Pod details
kubectl describe pod <pod-name> -n portfolio

# Pod logs
kubectl logs <pod-name> -n portfolio

# Logs from specific container
kubectl logs <pod-name> -c <container-name> -n portfolio

# Real-time logs
kubectl logs -f <pod-name> -n portfolio

# Last X lines of logs
kubectl logs <pod-name> -n portfolio --tail=50

# Previous logs (after crash)
kubectl logs <pod-name> -n portfolio --previous
```

#### Exec into pod
```bash
# Shell in pod
kubectl exec -it <pod-name> -n portfolio -- /bin/bash

# Single command
kubectl exec <pod-name> -n portfolio -- ls -la

# In specific container
kubectl exec -it <pod-name> -c <container-name> -n portfolio -- /bin/bash
```

#### Debugging
```bash
# Port forward
kubectl port-forward <pod-name> 8080:80 -n portfolio

# Copy files
kubectl cp <pod-name>:/path/to/file ./local-file -n portfolio
kubectl cp ./local-file <pod-name>:/path/to/file -n portfolio

# Top (resources)
kubectl top pods -n portfolio
kubectl top nodes

# Events
kubectl get events -n portfolio --sort-by='.lastTimestamp'

# Watch (refresh)
kubectl get pods -n portfolio --watch
```

### Managing Deployments

```bash
# List deployments
kubectl get deployments -n portfolio

# Deployment details
kubectl describe deployment <deployment-name> -n portfolio

# Scaling
kubectl scale deployment <deployment-name> --replicas=3 -n portfolio

# Restart deployment
kubectl rollout restart deployment/<deployment-name> -n portfolio

# Rollout status
kubectl rollout status deployment/<deployment-name> -n portfolio

# Rollout history
kubectl rollout history deployment/<deployment-name> -n portfolio

# Rollback
kubectl rollout undo deployment/<deployment-name> -n portfolio

# Rollback to specific revision
kubectl rollout undo deployment/<deployment-name> --to-revision=2 -n portfolio

# Pause rollout
kubectl rollout pause deployment/<deployment-name> -n portfolio

# Resume rollout
kubectl rollout resume deployment/<deployment-name> -n portfolio
```

### Managing Services

```bash
# List services
kubectl get svc -n portfolio

# Service details
kubectl describe svc <service-name> -n portfolio

# Endpoints (pods behind service)
kubectl get endpoints <service-name> -n portfolio

# Test connectivity
kubectl run test-pod --rm -it --image=busybox -n portfolio -- sh
# In pod:
wget -O- http://blog
```

### Managing ConfigMaps and Secrets

```bash
# List ConfigMaps
kubectl get configmaps -n portfolio

# ConfigMap content
kubectl get configmap <name> -n portfolio -o yaml

# Edit ConfigMap
kubectl edit configmap <name> -n portfolio

# Delete ConfigMap
kubectl delete configmap <name> -n portfolio

# List Secrets
kubectl get secrets -n portfolio

# Secret content (base64)
kubectl get secret <name> -n portfolio -o yaml

# Decode Secret
kubectl get secret <name> -n portfolio -o jsonpath='{.data.KEY}' | base64 -d

# Create Secret from file
kubectl create secret generic <name> --from-file=key=./file -n portfolio

# Create Secret from literal
kubectl create secret generic <name> --from-literal=key=value -n portfolio
```

### Managing StatefulSets

```bash
# List StatefulSets
kubectl get statefulsets -n portfolio

# StatefulSet details
kubectl describe statefulset <name> -n portfolio

# Scaling
kubectl scale statefulset <name> --replicas=3 -n portfolio

# Restart StatefulSet (delete pods one by one)
kubectl delete pod <statefulset-name>-0 -n portfolio
# Wait for pod to start, then:
kubectl delete pod <statefulset-name>-1 -n portfolio

# Update StatefulSet
kubectl apply -f <statefulset.yaml>
kubectl rollout status statefulset/<name> -n portfolio
```

### Managing PersistentVolumeClaims

```bash
# List PVCs
kubectl get pvc -n portfolio

# PVC details
kubectl describe pvc <name> -n portfolio

# List PVs
kubectl get pv

# Delete PVC (data will be deleted!)
kubectl delete pvc <name> -n portfolio

# Backup PVC (example with MySQL)
kubectl exec <mysql-pod> -n portfolio -- \
  mysqldump -u root -p${MYSQL_ROOT_PASSWORD} --all-databases > backup.sql
```

### Managing Ingress

```bash
# List Ingress
kubectl get ingress -n portfolio

# Szczegóły Ingress
kubectl describe ingress <name> -n portfolio

# Test Ingress
curl -Lk https://portfolio.kube -I

# Logi Ingress Controller
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller

# Restart Ingress Controller
kubectl rollout restart deployment/ingress-nginx-controller -n ingress-nginx
```

### Zarządzanie Jobs

```bash
# Lista Jobs
kubectl get jobs -n portfolio

# Szczegóły Job
kubectl describe job <name> -n portfolio

# Logi z Job
kubectl logs job/<name> -n portfolio

# Usuń Job
kubectl delete job <name> -n portfolio

# Usuń wszystkie zakończone Jobs
kubectl delete jobs --field-selector status.successful=1 -n portfolio
```

### Diagnostyka i Troubleshooting

```bash
# Sprawdź健康 podów
kubectl get pods -n portfolio | grep -v Running

# Sprawdź eventy
kubectl get events -n portfolio --sort-by='.lastTimestamp' | tail -20

# Sprawdź użycie zasobów
kubectl top pods -n portfolio --sort-by=memory
kubectl top pods -n portfolio --sort-by=cpu

# Sprawdź logi z wszystkich podów deployment
kubectl logs -n portfolio deployment/<name> --all-containers=true

# Sprawdź DNS
kubectl run test-dns --rm -it --image=busybox -n portfolio -- nslookup blog

# Sprawdź connectivity
kubectl run test-curl --rm -it --image=curlimages/curl -n portfolio -- \
  curl -v http://blog

# Sprawdź secrets aplikacji
for svc in admin blog frontend sso users; do
  echo "=== $svc ==="
  kubectl get secret ${svc}-secret -n portfolio -o jsonpath='{.data}' | jq
done

# Sprawdź wszystkie resources w namespace
kubectl api-resources --verbs=list --namespaced -o name | \
  xargs -n 1 kubectl get --show-kind --ignore-not-found -n portfolio
```

### Cleanup i Maintenance

```bash
# Usuń wszystkie pody w namespace
kubectl delete pods --all -n portfolio

# Usuń deployment ze wszystkim
kubectl delete deployment <name> -n portfolio

# Usuń namespace (UWAGA: usuwa wszystko!)
kubectl delete namespace portfolio

# Wyczyść zakończone pody
kubectl delete pod --field-selector=status.phase==Succeeded -n portfolio
kubectl delete pod --field-selector=status.phase==Failed -n portfolio

# Restart wszystkich deployments
kubectl rollout restart deployment -n portfolio

# Force delete poda
kubectl delete pod <name> --grace-period=0 --force -n portfolio
```

### Backup i Restore

```bash
# Backup wszystkich manifestów
kubectl get all -n portfolio -o yaml > backup-all.yaml

# Backup ConfigMaps
kubectl get configmaps -n portfolio -o yaml > backup-configmaps.yaml

# Backup Secrets
kubectl get secrets -n portfolio -o yaml > backup-secrets.yaml

# Backup PVC
kubectl get pvc -n portfolio -o yaml > backup-pvcs.yaml

# Restore z backup
kubectl apply -f backup-all.yaml
```

---

## Weryfikacja i Testy

### Test 1: Sprawdzenie wszystkich podów

```bash
kubectl get pods -n portfolio
```

**Oczekiwany wynik:**
- Wszystkie pody w stanie `Running` lub `Completed` (dla Jobs)
- `READY` pokazuje `X/X` (np. `2/2` dla aplikacji)

### Test 2: Sprawdzenie health endpoints

```bash
# Test PHP-FPM (readiness)
kubectl exec -n portfolio deployment/frontend-app -c nginx -- \
  curl -f http://localhost/ready

# Test health endpoint
kubectl exec -n portfolio deployment/frontend-app -c nginx -- \
  curl -f http://localhost/health
```

**Oczekiwany wynik:** `200 OK`

### Test 3: Dostęp przez Ingress

```bash
# Frontend
curl -Lk https://portfolio.kube -I
# Oczekiwany: HTTP/2 200

# Admin
curl -Lk https://admin.portfolio.kube -I
# Oczekiwany: HTTP/2 302 (redirect do /admin/login) lub 200

# SSO
curl -Lk https://sso.portfolio.kube -I
# Oczekiwany: HTTP/2 404 (brak homepage) lub 200
```

### Test 4: Komunikacja wewnętrzna

```bash
# Test z frontend do blog
kubectl exec -n portfolio deployment/frontend-app -c php-fpm -- \
  curl -s http://blog/health

# Test z frontend do users
kubectl exec -n portfolio deployment/frontend-app -c php-fpm -- \
  curl -s http://users/health
```

**Oczekiwany wynik:** Odpowiedź z endpoint (nie connection refused)

### Test 5: Bazy danych

```bash
# MySQL connection test
kubectl exec -it admin-mysql-0 -n portfolio -- mysql -u admin -p -e "SHOW DATABASES;"

# Redis connection test
kubectl exec -it frontend-redis-0 -n portfolio -- redis-cli ping
# Oczekiwany: PONG

# RabbitMQ connection test
kubectl exec -it rabbitmq-0 -n portfolio -- rabbitmqctl status
```

### Test 6: Logi bez błędów

```bash
# Sprawdź logi aplikacji
kubectl logs -n portfolio deployment/frontend-app -c php-fpm --tail=50 | \
  grep -i "error\|exception\|fatal"

# Powinno nie zwrócić żadnych błędów krytycznych
```

### Test 7: Metryki i zasoby

```bash
# CPU i Memory usage
kubectl top pods -n portfolio

# Disk usage (PVC)
kubectl get pvc -n portfolio
```

### Test 8: Ingress Controller

```bash
# Check Ingress Controller status
kubectl get pods -n ingress-nginx

# Check Ingress logs
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller --tail=20
```

---

## Deployment Summary

### Goals Achieved

✅ **Kubernetes Environment**
- Minikube configured and running
- 4 CPU, 8GB RAM, 40GB disk
- Addons: ingress, metrics-server, dashboard

✅ **Applications**
- 5 Laravel microservices deployed and running
- 1 worker (blog-consumer) running
- All pods in `Running` state

✅ **Databases**
- 4 MySQL instances (StatefulSets with PVC)
- 1 Redis instance
- 1 RabbitMQ instance
- Migrations executed successfully

✅ **Networking**
- Ingress Controller with TLS
- Self-signed certificates generated
- DNS configured (/etc/hosts)
- Service Discovery working

✅ **Security**
- Secrets generated and applied
- Unique passwords for each service
- TLS for external communication
- HTTP for internal communication

### Key Lessons

1. **Secrets Management**
   - Never commit secrets to repo
   - Don't place Secret definitions alongside StatefulSets
   - Use External Secrets Operator in production

2. **Service Discovery**
   - Use Service names for internal communication
   - HTTP (not HTTPS) for pod-to-pod
   - Define environment variables for all dependencies

3. **StatefulSets and PVC**
   - PVC stores data between restarts
   - When secrets change, delete the PVC
   - Backup PVC before deletion

4. **Debugging**
   - `kubectl logs` - first diagnostic step
   - `kubectl describe` - details and events
   - `kubectl exec` - access to pod

### Next Steps (Optional)

1. **CI/CD**
   - GitHub Actions Self-Hosted Runner
   - Automated build and deploy

2. **Monitoring**
   - Prometheus + Grafana
   - Loki for logs

3. **Backup**
   - Velero for PVC backup
   - Cron Jobs for database backup

4. **Security**
   - Network Policies
   - Pod Security Standards
   - External Secrets Operator

---

## Appendix

### Files Created During Deployment

```
/home/decybell/dev/portfolio/
├── scripts/
│   └── generate-k8s-secrets.sh          # Secret generator
├── admin/k8s/
│   ├── migration-job.yaml               # Job for migrations
│   ├── mysql.yaml                       # Updated with passwords
│   └── secret.yaml                      # Generated secret
├── blog/k8s/
│   ├── migration-job.yaml
│   ├── mysql.yaml
│   └── secret.yaml
├── frontend/k8s/
│   ├── configmap.yaml                   # Updated with internal URLs
│   ├── migration-job.yaml
│   └── secret.yaml
├── sso/k8s/
│   ├── migration-job.yaml
│   ├── mysql.yaml
│   └── secret.yaml
└── users/k8s/
    ├── migration-job.yaml
    ├── mysql.yaml
    └── secret.yaml
```

### Files in .gitignore

```
# Kubernetes secrets (never commit!)
*/k8s/secret.yaml

# TLS certificates
*-tls.key
*-tls.crt

# Backup files
backup-*.yaml
```

### Environment Variables - Complete List

#### Frontend ConfigMap
```yaml
APP_NAME: "Frontend"
APP_ENV: "production"
APP_DEBUG: "false"
APP_URL: "https://portfolio.kube"
LOG_CHANNEL: "stderr"
REDIS_HOST: "frontend-redis"
REDIS_PORT: "6379"
BLOG_API_URL_INTERNAL: "http://blog"
USERS_API_URL_INTERNAL: "http://users"
SSO_INTERNAL_URL: "http://sso"
```

#### Admin/Blog/SSO/Users ConfigMap (example)
```yaml
APP_NAME: "Admin"
APP_ENV: "production"
APP_DEBUG: "false"
APP_URL: "https://admin.portfolio.kube"
LOG_CHANNEL: "stderr"
DB_HOST: "admin-mysql"
DB_PORT: "3306"
DB_DATABASE: "admin"
DB_USERNAME: "admin"
```

#### MySQL Secrets (example)
```yaml
MYSQL_DATABASE: "admin"
MYSQL_USER: "admin"
MYSQL_PASSWORD: "<generated-password>"
MYSQL_ROOT_PASSWORD: "<generated-password>"
```

---

## Contact and Support

If you encounter issues:

1. **Check logs:**
   ```bash
   kubectl logs -n portfolio <pod-name>
   ```

2. **Check events:**
   ```bash
   kubectl get events -n portfolio --sort-by='.lastTimestamp'
   ```

3. **Check documentation:**
   - Kubernetes: https://kubernetes.io/docs/
   - Minikube: https://minikube.sigs.k8s.io/docs/

4. **Dashboard:**
   ```bash
   minikube dashboard --profile=portfolio
   ```

---

**End of documentation**

Version: 1.0
Date: February 9, 2026
Author: Deployment executed with Claude Code
