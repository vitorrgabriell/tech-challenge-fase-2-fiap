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

**3. Aguarde todos os 10 containers subirem:**
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
-H "Authorization: Bearer admin-secreto-123" \
-d '{"name": "minha-chave"}'
```

**6. Use a chave para acessar os outros serviços:**
```bash
curl http://localhost:8002/flags \
-H "Authorization: Bearer <sua-chave-api>"
```

---

## Opção 2: Ambiente AWS (EKS)

### Pré-requisitos
- Conta AWS (Academy ou pessoal)
- AWS CLI configurado
- kubectl instalado
- Docker instalado

### Passo 1: Criar Infraestrutura AWS

**1.1. Criar repositórios no ECR:**
```bash
# Criar 5 repositórios
aws ecr create-repository --repository-name tech-challenge/auth-service
aws ecr create-repository --repository-name tech-challenge/flag-service
aws ecr create-repository --repository-name tech-challenge/targeting-service
aws ecr create-repository --repository-name tech-challenge/evaluation-service
aws ecr create-repository --repository-name tech-challenge/analytics-service
```

**1.2. Criar recursos via Console AWS:**
- 3x RDS PostgreSQL (auth-db, flag-db, targeting-db)
- 1x ElastiCache Redis
- 1x Tabela DynamoDB
- 1x Fila SQS
- 1x Cluster EKS com Node Group

### Passo 2: Build e Push das Imagens

**2.1. Login no ECR:**
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
```

**2.2. Build e push de cada serviço:**
```bash
# Exemplo para auth-service (repetir para os outros 4)
docker build -t <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/auth-service:latest ./auth-service
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/tech-challenge/auth-service:latest
```

### Passo 3: Configurar kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name tech-challenge-cluster
kubectl get nodes  # Verificar conexão
```

### Passo 4: Deploy no Kubernetes

**4.1. Aplicar os manifestos na ordem:**
```bash
# Namespace
kubectl apply -f k8s/namespaces/

# Secrets (editar com seus endpoints RDS/Redis/SQS)
kubectl apply -f k8s/secrets/

# ConfigMaps
kubectl apply -f k8s/configmaps/

# Deployments
kubectl apply -f k8s/deployments/

# Services
kubectl apply -f k8s/services/

# Ingress
kubectl apply -f k8s/ingress/

# HPAs
kubectl apply -f k8s/hpa/
```

**4.2. Instalar Nginx Ingress Controller:**
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/aws/deploy.yaml
```

**4.3. Inicializar tabelas nos bancos RDS:**
```bash
# Conectar em cada RDS e executar os scripts db/init.sql
kubectl run psql-client --rm -it --restart=Never -n tech-challenge \
  --image=postgres:15 \
  --env="PGPASSWORD=<senha>" \
  -- psql -h <endpoint-rds> -U postgres -d postgres
```

### Passo 5: Verificar o Deploy

```bash
# Ver pods
kubectl get pods -n tech-challenge

# Ver services
kubectl get svc -n tech-challenge

# Ver HPAs
kubectl get hpa -n tech-challenge

# Pegar URL do Load Balancer
kubectl get svc -n ingress-nginx
```

### Passo 6: Testar os Endpoints

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
-H "Authorization: Bearer <master-key>" \
-d '{"name": "minha-chave"}'
```

---

## 📈 Testando a Escalabilidade (HPA)

**1. Instale o hey (ferramenta de load testing):**
```bash
sudo apt install hey -y
```

**2. Gere carga no evaluation-service:**
```bash
hey -z 120s -c 200 http://<load-balancer-url>/evaluate/health
```

**3. Em outro terminal, monitore o HPA:**
```bash
kubectl get hpa -n tech-challenge -w
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

## 📝 Variáveis de Ambiente Importantes

| Variável | Serviço | Descrição |
|----------|---------|-----------|
| `DATABASE_URL` | auth, flag, targeting | Connection string PostgreSQL |
| `MASTER_KEY` | auth | Chave mestra para criar API keys |
| `AUTH_SERVICE_URL` | flag, targeting | URL do auth-service |
| `REDIS_URL` | evaluation | Connection string Redis |
| `AWS_SQS_URL` | evaluation, analytics | URL da fila SQS |
| `AWS_DYNAMODB_TABLE` | analytics | Nome da tabela DynamoDB |
| `AWS_REGION` | evaluation, analytics | Região AWS |

---

## 👨‍💻 Autores

**Vitor Gabriel de Almeida, Aleff Silva**
- Pós-Tech FIAP - Arquitetura Cloud e DevOps
- Tech Challenge Fase 2

---

## 📄 Licença

Este projeto é apenas para fins educacionais como parte do programa de pós-graduação da FIAP.