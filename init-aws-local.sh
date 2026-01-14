#!/bin/bash

echo "Aguardando LocalStack..."
sleep 10

echo "Criando fila SQS..."
aws --endpoint-url=http://localhost:4566 sqs create-queue --queue-name tech-challenge-events --region us-east-1

echo "Criando tabela DynamoDB..."
aws --endpoint-url=http://localhost:8000 dynamodb create-table \
  --table-name tech-challenge-analytics \
  --attribute-definitions AttributeName=event_id,AttributeType=S \
  --key-schema AttributeName=event_id,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1

echo "Recursos AWS locais criados!"