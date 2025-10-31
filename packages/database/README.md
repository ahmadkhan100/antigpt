# @antigpt/database

Centralized Prisma schema and client for the AntiGPT platform. This package owns the database schema, migration tooling, and reusable Prisma client instance for other apps/packages in the monorepo.

## Environment

Create a `.env` file at the repo root (or set `DATABASE_URL` in your shell) with a connection string:

```
DATABASE_URL="postgresql://USER:PASSWORD@HOST:PORT/DATABASE?schema=public"
```

Local development can point to a Cloud SQL proxy connection or any Postgres instance. Production should use the private Cloud SQL connection name emitted by Terraform.

## Available Scripts

Run these from the repository root (Turbo will forward them to this workspace):

- `npm run prisma:generate` – Generate the Prisma client
- `npm run prisma:migrate -- --name <name>` – Create/apply a migration locally
- `npm run prisma:deploy` – Apply migrations in CI / production
- `npm run prisma:studio` – Open Prisma Studio

Alternatively execute them directly inside the package:

```bash
npm run prisma:generate --workspace @antigpt/database
```

Generated Prisma client files live under `packages/database/node_modules/.prisma`, and migrations reside in `packages/database/prisma/migrations/` once created.

