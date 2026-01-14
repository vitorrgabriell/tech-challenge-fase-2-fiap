# 🚀 Tech Challenge Fase 2 - ToggleMaster Microservices

[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com/)

> ⚠️ **PROJETO DIDÁTICO** - Este projeto foi desenvolvido como parte do Tech Challenge Fase 2 da Pós-Tech FIAP em Arquitetura Cloud e DevOps.

## 📋 Sobre o Projeto

Este projeto representa a evolução do ToggleMaster, uma plataforma de Feature Flags, migrando de uma arquitetura monolítica para microsserviços distribuídos orquestrados pelo Kubernetes (AWS EKS).

### 🎓 Créditos

| Componente | Autor |
|------------|-------|
| Código dos 5 microsserviços (Go/Python) | Professor da FIAP |
| Dockerfiles (multi-stage builds) | Vitor Gabriel |
| Docker Compose | Vitor Gabriel |
| Manifestos Kubernetes (deployments, services, secrets, configmaps, ingress, hpa) | Vitor Gabriel |
| Infraestrutura AWS (EKS, RDS, ElastiCache, DynamoDB, SQS, ECR) | Vitor Gabriel |

## 🏗️ Arquitetura

O sistema é composto por 5 microsserviços:

| Serviço | Linguagem | Banco de Dados | Porta | Descrição |
|---------|-----------|----------------|-------|-----------|
| **auth-service** | Go | PostgreSQL | 8001 | Gerencia chaves de API e autenticação |
| **flag-service** | Python | PostgreSQL | 8002 | CRUD das definições de feature flags |
| **targeting-service** | Python | PostgreSQL | 8003 | Gerencia regras de segmentação |
| **evaluation-service** | Go | Redis | 8004 | Hot path de alta performance (true/false) |
| **analytics-service** | Python | DynamoDB + SQS | 8005 | Consome eventos e salva dados de análise |

### 📊 Diagrama da Arquitetura

```
                                    ┌─────────────────────────────────────────┐
                                    │            AWS Cloud                     │
                                    │  ┌─────────────────────────────────────┐│
                                    │  │     Application Load Balancer       ││
                                    │  │        (Nginx Ingress)              ││
                                    │  └──────────────┬──────────────────────┘│
                                    │                 │                        │
                                    │  ┌──────────────▼──────────────────────┐│
                                    │  │         Amazon EKS Cluster          ││
                                    │  │                                      ││
                                    │  │  ┌─────────┐  ┌─────────┐           ││
                                    │  │  │  auth   │  │  flag   │           ││
                                    │  │  │ service │  │ service │           ││
                                    │  │  └────┬────┘  └────┬────┘           ││
                                    │  │       │            │                 ││
                                    │  │  ┌────┴────┐  ┌────┴────┐           ││
                                    │  │  │targeting│  │evaluate │           ││
                                    │  │  │ service │  │ service │           ││
                                    │  │  └─────────┘  └────┬────┘           ││
                                    │  │                    │                 ││
                                    │  │            ┌───────┴───────┐        ││
                                    │  │            │   analytics   │        ││
                                    │  │            │    service    │        ││
                                    │  │            └───────────────┘        ││
                                    │  └──────────────────────────────────────┘│
                                    │                                          │
                                    │  ┌────────────┐ ┌────────────┐          │
                                    │  │ RDS        │ │ElastiCache │          │
                                    │  │ PostgreSQL │ │   Redis    │          │
                                    │  │ (3 inst.)  │ │            │          │
                                    │  └────────────┘ └────────────┘          │
                                    │                                          │
                                    │  ┌────────────┐ ┌────────────┐          │
                                    │  │  DynamoDB  │ │    SQS     │          │
                                    │  │            │ │            │          │
                                    │  └────────────┘ └────────────┘          │
                                    └──────────────────────────────────────────┘
```

## 🛠️ Tecnologias Utilizadas

- **Orquestração:** Kubernetes (AWS EKS)
- **Containerização:** Docker com multi-stage builds
- **Banco de Dados:** PostgreSQL (AWS RDS), Redis (AWS ElastiCache), DynamoDB
- **Mensageria:** AWS SQS
- **Load Balancer:** Nginx Ingress Controller
- **Escalabilidade:** Horizontal Pod Autoscaler (HPA)
- **Registry:** AWS ECR

## 📁 Estrutura do Projeto

```
tech-challenge-fase2/
├── analytics-service/       # Microsserviço de analytics (Python)
│   ├── Dockerfile
│   ├── app.py
│   └── requirements.txt
├── auth-service/            # Microsserviço de autenticação (Go)
│   ├── Dockerfile
│   ├── main.go
│   └── db/init.sql
├── evaluation-service/      # Microsserviço de avaliação (Go)
│   ├── Dockerfile
│   └── main.go
├── flag-service/            # Microsserviço de flags (Python)
│   ├── Dockerfile
│   ├── app.py
│   └── db/init.sql
├── targeting-service/       # Microsserviço de targeting (Python)
│   ├── Dockerfile
│   ├── app.py
│   └── db/init.sql
├── k8s/                     # Manifestos Kubernetes
│   ├── namespaces/
│   ├── secrets/
│   ├── configmaps/
│   ├── deployments/
│   ├── services/
│   ├── ingress/
│   └── hpa/
├── docker-compose.yml       # Compose para ambiente local
├── init-shared-dbs.sh       # Script de init dos bancos
└── README.md
```

---

# 🚀 Como Executar o Projeto

## Opção 1: Ambiente Local (Docker Compose)

### Pré-requisitos
- Docker e Docker Compose instalados
- Git

### Passo a Passo

**1. Clone o repositório:**
```bash
git clone https://github.com/vitorrgabriell/tech-challenge-fase-2-fiap.git
cd tech-challenge-fase-2-fiap
```

**2. Suba os containers:**
```bash
docker-compose up --build
```

**3. Aguarde todos os containers subirem:**
- 5 microsserviços
- 2 PostgreSQL
- 1 Redis
- 1 DynamoDB Local
- 1 LocalStack (SQS)

**4. Teste os health checks:**
```bash
curl http://localhost:8001/health  # auth-service
curl http://localhost:8002/health  # flag-service
curl http://localhost:8003/health  # targeting-service
curl http://localhost:8004/health  # evaluation-service
curl http://localhost:8005/health  # analytics-service
```

**5. Crie uma chave de API:**
```bash
curl -X POST http://localhost:8001/admin/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: <sua-master-key>" \
  -d '{"name": "minha-chave"}'
```

**6. Use a chave para criar uma feature flag:**
```bash
curl -X POST http://localhost:8002/flags \
  -H "Content-Type: application/json" \
  -H "X-API-Key: <sua-api-key>" \
  -d '{"name": "enable-new-feature", "enabled": true}'
```

**7. Faça uma avaliação:**
```bash
curl "http://localhost:8004/evaluate?flag_name=enable-new-feature&user_id=user-123"
```

---

## Opção 2: Ambiente AWS (EKS)

### ⚠️ Nota Importante: AWS Academy vs Conta Pessoal

| Aspecto | AWS Academy | Conta Pessoal |
|---------|-------------|---------------|
| IAM Roles | Usar `LabRole` existente | Criar roles via eksctl |
| Credenciais | Requer `AWS_SESSION_TOKEN` | Apenas Access Key e Secret Key |
| Expiração | Tokens expiram a cada ~4 horas | Sem expiração |
| Load Balancer | Funciona com LabRole | Pode ter restrições em contas novas |
| KEDA/IRSA | Não funciona | Funciona normalmente |

### Pré-requisitos
- Conta AWS (Academy ou pessoal)
- AWS CLI configurado
- kubectl instalado
- eksctl instalado (para conta pessoal)
- Docker instalado

### Passo 1: Criar Cluster EKS

**Opção A - AWS Academy (via Console):**
1. Acesse o Console AWS → EKS → Create Cluster
2. Selecione `LabRole` como Cluster Role
3. Crie um Node Group com `LabRole` como Node IAM Role

**Opção B - Conta Pessoal (via eksctl):**
```bash
eksctl create cluster \
  --name tech-challenge-cluster \
  --region us-east-1 \
  --nodegroup-name workers \
  --node-type t3.medium \
  --nodes 2 \
  --nodes-min 1 \
  --nodes-max 4 \
  --managed
```

### Passo 2: Criar Repositórios ECR

```bash
aws ecr create-repository --repository-name tech-challenge/auth-service --region us-east-1
aws ecr create-repository --repository-name tech-challenge/flag-service --region us-east-1
aws ecr create-repository --repository-name tech-challenge/targeting-service --region us-east-1
aws ecr create-repository --repository-name tech-challenge/evaluation-service --region us-east-1
aws ecr create-repository --repository-name tech-challenge/analytics-service --region us-east-1
```

### Passo 3: Criar Recursos de Dados

**3.1. Fila SQS:**
```bash
aws sqs create-queue --queue-name tech-challenge-events --region us-east-1
```

**3.2. Tabela DynamoDB:**
> ⚠️ **IMPORTANTE:** O nome da tabela deve ser `ToggleMasterAnalytics` com chave primária `event_id`.

```bash
aws dynamodb create-table \
  --table-name ToggleMasterAnalytics \
  --attribute-definitions AttributeName=event_id,AttributeType=S \
  --key-schema AttributeName=event_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

**3.3. RDS PostgreSQL (3 instâncias):**
Criar via Console ou CLI:
- `tech-challenge-auth-db`
- `tech-challenge-flag-db`
- `tech-challenge-targeting-db`

**3.4. ElastiCache Redis:**
Criar via Console ou CLI um cluster Redis.

### Passo 4: Build e Push das Imagens

```bash
# Login no ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

# Build e push de cada serviço
docker build -t <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/auth-service:latest ./auth-service
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/auth-service:latest

docker build -t <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/flag-service:latest ./flag-service
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/flag-service:latest

docker build -t <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/targeting-service:latest ./targeting-service
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/targeting-service:latest

docker build -t <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/evaluation-service:latest ./evaluation-service
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/evaluation-service:latest

docker build -t <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/analytics-service:latest ./analytics-service
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/analytics-service:latest
```

### Passo 5: Configurar kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name tech-challenge-cluster
kubectl get nodes  # Verificar conexão
```

### Passo 6: Instalar Componentes do Cluster

**6.1. Metrics Server (se não instalado automaticamente):**
```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

**6.2. Nginx Ingress Controller:**
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.5/deploy/static/provider/aws/deploy.yaml
```

### Passo 7: Configurar Secrets

> ⚠️ **AWS Academy:** Inclua `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` e `AWS_SESSION_TOKEN` nos secrets.

Edite o arquivo `k8s/secrets/secrets.yaml` com seus endpoints:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: auth-db-secret
  namespace: tech-challenge
type: Opaque
stringData:
  DATABASE_URL: "postgres://postgres:<senha>@<endpoint-rds>:5432/postgres"
  MASTER_KEY: "sua-master-key-secreta"

---
apiVersion: v1
kind: Secret
metadata:
  name: flag-db-secret
  namespace: tech-challenge
type: Opaque
stringData:
  DATABASE_URL: "postgres://postgres:<senha>@<endpoint-rds>:5432/postgres"

---
apiVersion: v1
kind: Secret
metadata:
  name: targeting-db-secret
  namespace: tech-challenge
type: Opaque
stringData:
  DATABASE_URL: "postgres://postgres:<senha>@<endpoint-rds>:5432/postgres"

---
apiVersion: v1
kind: Secret
metadata:
  name: redis-secret
  namespace: tech-challenge
type: Opaque
stringData:
  REDIS_URL: "redis://<endpoint-elasticache>:6379"

---
apiVersion: v1
kind: Secret
metadata:
  name: aws-secret
  namespace: tech-challenge
type: Opaque
stringData:
  AWS_REGION: "us-east-1"
  AWS_SQS_URL: "https://sqs.us-east-1.amazonaws.com/<account-id>/tech-challenge-events"
  AWS_DYNAMODB_TABLE: "ToggleMasterAnalytics"
  # Apenas para AWS Academy - remova se usar conta pessoal com IAM roles
  AWS_ACCESS_KEY_ID: "<sua-access-key>"
  AWS_SECRET_ACCESS_KEY: "<sua-secret-key>"
  AWS_SESSION_TOKEN: "<seu-session-token>"
```

### Passo 8: Deploy no Kubernetes

```bash
# Aplicar na ordem correta
kubectl apply -f k8s/namespaces/
kubectl apply -f k8s/secrets/
kubectl apply -f k8s/configmaps/
kubectl apply -f k8s/deployments/
kubectl apply -f k8s/services/
kubectl apply -f k8s/ingress/
kubectl apply -f k8s/hpa/
```

### Passo 9: Inicializar Tabelas nos Bancos RDS

```bash
# Criar pod temporário com psql
kubectl run psql-client --rm -it --restart=Never \
  --image=postgres:15-alpine \
  --namespace=tech-challenge \
  -- bash

# Dentro do pod, conectar em cada banco e criar as tabelas:

# Auth DB
psql "postgres://postgres:<senha>@<endpoint-auth-db>:5432/postgres"
CREATE TABLE IF NOT EXISTS api_keys (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    key_hash VARCHAR(64) NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
\q

# Flag DB
psql "postgres://postgres:<senha>@<endpoint-flag-db>:5432/postgres"
CREATE TABLE IF NOT EXISTS flags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    is_enabled BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
\q

# Targeting DB
psql "postgres://postgres:<senha>@<endpoint-targeting-db>:5432/postgres"
CREATE TABLE IF NOT EXISTS targeting_rules (
    id SERIAL PRIMARY KEY,
    flag_name VARCHAR(100) UNIQUE NOT NULL,
    is_enabled BOOLEAN NOT NULL DEFAULT true,
    rules JSONB NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
\q

exit
```

### Passo 10: Verificar o Deploy

```bash
# Ver pods
kubectl get pods -n tech-challenge

# Ver services
kubectl get svc -n tech-challenge

# Ver HPAs
kubectl get hpa -n tech-challenge

# Pegar URL do Load Balancer
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

### Passo 11: Testar os Endpoints

```bash
# Health checks
curl http://<load-balancer-url>/auth/health
curl http://<load-balancer-url>/flags/health
curl http://<load-balancer-url>/targeting/health
curl http://<load-balancer-url>/evaluate/health
curl http://<load-balancer-url>/analytics/health

# Criar chave de API
curl -X POST http://<load-balancer-url>/auth/admin/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: <sua-master-key>" \
  -d '{"name": "minha-chave"}'

# Criar uma feature flag
curl -X POST http://<load-balancer-url>/flags/flags \
  -H "Content-Type: application/json" \
  -H "X-API-Key: <sua-api-key>" \
  -d '{"name": "enable-new-dashboard", "enabled": true}'

# Fazer uma avaliação
curl "http://<load-balancer-url>/evaluate/evaluate?flag_name=enable-new-dashboard&user_id=user-123"

# Verificar dados no DynamoDB
aws dynamodb scan --table-name ToggleMasterAnalytics --region us-east-1
```

---

## 📈 Testando a Escalabilidade (HPA)

**1. Instale o hey (ferramenta de load testing):**
```bash
# Ubuntu/Debian
sudo apt install hey -y

# Ou via Go
go install github.com/rakyll/hey@latest
```

**2. Gere carga no evaluation-service:**
```bash
hey -z 120s -c 200 "http://<load-balancer-url>/evaluate/evaluate?flag_name=enable-new-dashboard&user_id=test"
```

**3. Em outro terminal, monitore o HPA:**
```bash
kubectl get hpa -n tech-challenge -w
```

**4. Monitore os pods escalando:**
```bash
kubectl get pods -n tech-challenge -w
```

Você verá o HPA aumentar o número de réplicas quando a CPU ultrapassar 70%.

---

## 🔗 Endpoints da API

| Serviço | Rota Local | Rota AWS (via Ingress) |
|---------|------------|------------------------|
| auth-service | `localhost:8001/*` | `/auth/*` |
| flag-service | `localhost:8002/*` | `/flags/*` |
| targeting-service | `localhost:8003/*` | `/targeting/*` |
| evaluation-service | `localhost:8004/*` | `/evaluate/*` |
| analytics-service | `localhost:8005/*` | `/analytics/*` |

---

## 📝 Variáveis de Ambiente

### Obrigatórias para todos os ambientes

| Variável | Serviço | Descrição |
|----------|---------|-----------|
| `DATABASE_URL` | auth, flag, targeting | Connection string PostgreSQL |
| `MASTER_KEY` | auth | Chave mestra para criar API keys |
| `AUTH_SERVICE_URL` | flag, targeting | URL interna do auth-service |
| `REDIS_URL` | evaluation | Connection string Redis |
| `AWS_SQS_URL` | evaluation, analytics | URL da fila SQS |
| `AWS_DYNAMODB_TABLE` | analytics | Nome da tabela (usar `ToggleMasterAnalytics`) |
| `AWS_REGION` | evaluation, analytics | Região AWS (ex: `us-east-1`) |

### Obrigatórias apenas para AWS Academy

| Variável | Serviço | Descrição |
|----------|---------|-----------|
| `AWS_ACCESS_KEY_ID` | evaluation, analytics | Access Key do AWS Academy |
| `AWS_SECRET_ACCESS_KEY` | evaluation, analytics | Secret Key do AWS Academy |
| `AWS_SESSION_TOKEN` | evaluation, analytics | Session Token do AWS Academy (expira a cada ~4h) |

---

## 🔧 Troubleshooting

### Erro: "InvalidClientTokenId: The security token included in the request is invalid"
- **Causa:** Token do AWS Academy expirou
- **Solução:** Pegue novas credenciais no AWS Academy e atualize o secret:
```bash
kubectl delete secret aws-secret -n tech-challenge
kubectl create secret generic aws-secret -n tech-challenge \
  --from-literal=AWS_REGION=us-east-1 \
  --from-literal=AWS_SQS_URL=<url> \
  --from-literal=AWS_DYNAMODB_TABLE=ToggleMasterAnalytics \
  --from-literal=AWS_ACCESS_KEY_ID=<nova-key> \
  --from-literal=AWS_SECRET_ACCESS_KEY=<nova-secret> \
  --from-literal=AWS_SESSION_TOKEN=<novo-token>
kubectl rollout restart deployment/evaluation-service -n tech-challenge
kubectl rollout restart deployment/analytics-service -n tech-challenge
```

### Erro: "Unable to locate credentials"
- **Causa:** Variáveis de ambiente AWS não estão sendo injetadas no pod
- **Solução:** Verifique se o deployment inclui as variáveis do secret:
```bash
kubectl get deployment <nome> -n tech-challenge -o yaml | grep -A 30 "env:"
```

### Erro: "relation does not exist"
- **Causa:** Tabelas não foram criadas no banco RDS
- **Solução:** Execute os scripts SQL de inicialização (ver Passo 9)

### Load Balancer com EXTERNAL-IP "pending"
- **Causa:** Conta AWS nova pode ter restrições para criar ELBs
- **Solução:** Use NodePort como alternativa:
```bash
kubectl patch svc ingress-nginx-controller -n ingress-nginx -p '{"spec": {"type": "NodePort"}}'
kubectl get nodes -o wide  # Pegar IP externo do node
# Acessar via http://<node-ip>:<node-port>
```

---

## 👨‍💻 Autores

**Vitor Gabriel de Almeida, Aleff Silva**
- Pós-Tech FIAP - Arquitetura Cloud e DevOps
- Tech Challenge Fase 2

---

## 📄 Licença

Este projeto é apenas para fins educacionais como parte do programa de pós-graduação da FIAP.