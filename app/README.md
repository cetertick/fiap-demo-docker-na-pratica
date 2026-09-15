# Aplicação do laboratório

API Node.js + TypeScript + PostgreSQL para demonstrar Dockerfile single-stage, multi-stage e Docker Compose.

## Execução local com Compose

```bash
cp .env.example .env
docker compose up -d --build
curl http://localhost:3000/health
```

## Endpoints

- `GET /health`
- `GET /info`
- `GET /tasks`
- `POST /tasks`
