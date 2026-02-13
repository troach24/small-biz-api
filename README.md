# Small Biz API

A lightweight Rails API backend built with:

- Ruby on Rails (API mode)
- PostgreSQL
- Sidekiq
- Redis

This project serves as a clean backend foundation for background job processing and scalable API services.

---

## Tech Stack

- **Rails (API-only)**
- **Postgres** — primary database
- **Redis** — job queue datastore
- **Sidekiq** — background job processor

---

## 🛠 Development Setup

### 1. Install dependencies

```bash
bundle install
```

Ensure the following are installed and running:
- Ruby
- PostgreSQL
- Redis

---

### 2. Setup database

```bash
bin/rails db:create
bin/rails db:migrate
```

---

### 3. Start services (3 processes)

**Terminal 1 — Rails server**
```bash
bin/rails s
```

**Terminal 2 — Redis**
```bash
brew services start redis
# or
redis-server
```

**Terminal 3 — Sidekiq**
```bash
bundle exec sidekiq -C config/sidekiq.yml
```

---

## Health Check

```
GET /health
```

Example:

```bash
curl http://localhost:3000/health
```

Response:

```json
{
  "ok": true,
  "time": "UTC timestamp"
}
```

---

## Background Job Example

```
POST /jobs/ping
```

Example:

```bash
curl -X POST http://localhost:3000/jobs/ping \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

This enqueues a background job processed asynchronously by Sidekiq.

---

## Sidekiq Dashboard

Available at:

```
http://localhost:3000/sidekiq
```

(Development use only — not secured for production.)

---

## Project Structure

```
app/
  controllers/      # API endpoints
  jobs/             # Background jobs
config/
  routes.rb         # API routes
  sidekiq.yml       # Sidekiq configuration
db/
  schema.rb         # Database schema
```

Core files:

- `Procfile.dev` — local multi-process startup
- `Gemfile` — project dependencies
- `config/application.rb` — ActiveJob adapter config

---

## Architecture Overview

- Rails enqueues jobs using ActiveJob.
- Redis stores queued jobs.
- Sidekiq workers pull and execute jobs.
- API is stateless and JSON-only.

---

## Project Plan

### Phase 1 — Core Resource
- ✔︎ Add primary resource (Order)
- ✔︎ Add validations
- Add database indexes and constraints

### Phase 2 — Background Processing
- Implement idempotent jobs
- Configure retry strategies
- Add failure handling

### Phase 3 — Production Hardening
- Improve structured logging
- Add request instrumentation
- Add basic rate limiting
- Secure Sidekiq dashboard

---

## Goal

Provide a production-style backend template suitable for:

- Small business workflows
- Background job processing
- Backend engineering interview preparation

## Features
### Orders + Async Sync

“All endpoints are versioned under /api/v1.”
- CRUD endpoints for Orders
- POST /orders/:id/sync enqueues a background job
- Uses Sidekiq + Redis
- Integration logic isolated in service object (External::OrderSyncer)

