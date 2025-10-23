# Technology Stack

## Runtime Environment
- **Node.js**: 18.20.8
- **npm**: 10.8.2
- **Operating System**: Linux

## Core Framework
- **SvelteKit**: 1.30.4 (Full-stack web framework for Svelte)
- **Svelte**: 4.2.20 (Frontend framework)
- **Vite**: 4.5.14 (Build tool and dev server)

## Database & ORM
- **PostgreSQL**: 16 (Primary database)
- **Prisma**: 5.0.0 (Database ORM and migration tool)
- **@prisma/client**: 6.17.0 (Database client)

## Authentication & Security
- **jsonwebtoken**: 9.0.2 (JWT token generation and verification)
- **bcryptjs**: 3.0.2 (Password hashing)
- **@types/jsonwebtoken**: 9.0.10 (TypeScript types for JWT)
- **@types/bcryptjs**: 2.4.6 (TypeScript types for bcryptjs)

## Styling & UI
- **TailwindCSS**: 3.4.0 (Utility-first CSS framework)
- **@tailwindcss/forms**: 0.5.10 (Form styling plugin)
- **@tailwindcss/typography**: 0.5.18 (Typography plugin)
- **@tailwindcss/vite**: 4.1.13 (Vite integration)

## Development Tools
- **TypeScript**: 5.9.2 (Type checking)
- **ESLint**: 9.36.0 (Code linting)
  - **@eslint/js**: 9.36.0 (Core ESLint rules)
  - **@eslint/compat**: 1.4.0 (Compatibility utilities)
  - **eslint-plugin-svelte**: 2.35.0 (Svelte-specific rules)
  - **eslint-config-prettier**: 10.1.8 (Prettier compatibility)
- **globals**: 16.4.0 (ESLint global variables)
- **Prettier**: 3.6.2 (Code formatting)
  - **prettier-plugin-svelte**: 3.4.0 (Svelte formatting)
  - **prettier-plugin-tailwindcss**: 0.6.14 (Tailwind class sorting)
- **svelte-check**: 3.6.0 (Svelte type checking)

## Utilities
- **qrcode**: 1.5.4 (QR code generation)
- **@types/qrcode**: 1.5.5 (TypeScript types for QR code)
- **svelte-sonner**: 1.0.5 (Toast notifications)
- **@types/node**: 20 (Node.js types)

## Deployment & Infrastructure
- **Docker**: Containerization
- **Docker Compose**: Multi-container orchestration
- **PostgreSQL Container**: patrimonio-db (Port 5433 → 5432)

## Development Commands
- `npm run dev`: Start development server
- `npm run build`: Build for production
- `npm run preview`: Preview production build
- `npm run check`: Type checking and Svelte diagnostics
- `npm run check:watch`: Watch mode for type checking
- `npm run lint`: Code linting
- `npm run format`: Code formatting

## Project Structure
- **Frontend**: SvelteKit with SSR (Server-Side Rendering)
- **Backend**: SvelteKit API routes
- **Database**: Prisma with PostgreSQL
- **Styling**: TailwindCSS with responsive design
- **Type Safety**: Full TypeScript coverage
- **Code Quality**: ESLint + Prettier
