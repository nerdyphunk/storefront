[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fyour-username%2Fsaleor-sveltekit-storefront&env=PUBLIC_SALEOR_API_URL,PUBLIC_STOREFRONT_URL&envDescription=Saleor%20GraphQL%20API%20URL%20and%20Storefront%20URL&project-name=my-saleor-storefront&repository-name=my-saleor-storefront&demo-title=Saleor%20SvelteKit%20Storefront&demo-description=Modern%20e-commerce%20storefront%20with%20SvelteKit%20and%20Saleor.)

> ⚡ **Migrated from Next.js to SvelteKit** - Modern, fast, and developer-friendly e-commerce storefront.

<div align="center">
  <h1>Saleor SvelteKit Storefront</h1>
  ⚡ Migrated from Next.js to SvelteKit ⚡<br/>
  Starter pack for building performant e-commerce experiences with <a href="https://github.com/saleor/saleor">Saleor</a>.
</div>

<div align="center">
  <a href="https://saleor.io/">Website</a>
  <span> • </span>
  <a href="https://docs.saleor.io/docs/3.x">Docs</a>
  <span> • </span>
  <a href="https://saleor.io/roadmap">Roadmap</a>
  <span> • </span>
  <a href="https://twitter.com/getsaleor">Twitter</a>
  <span> • </span>
  <a href="https://saleor.io/discord">Discord</a>
</div>

<br/>

<div align="center">

[![Storefront Roadmap](https://img.shields.io/badge/ROADMAP-EFEFEF?style=for-the-badge)](https://saleor.io/roadmap)

</div>

> [!TIP]
> Questions or issues? Check our [Discord](https://saleor.io/discord) channel for help.

## ✨ Features

- **SvelteKit**: File-based routing, modern build system with Vite, SSR/SSG support
- **TypeScript**: Strongly typed codebase and GraphQL payloads with strict mode
- **GraphQL best practices**: Uses GraphQL Codegen and `TypedDocumentString` to reduce boilerplate and bundle size
- **TailwindCSS**: Utility-first CSS framework with full customization support
- **Docker Support**: Compatible with both `docker-compose` and `docker compose`
- **Modern tooling**: Prettier, Husky, Lint Staged, and Codegen preconfigured
- **Performance**: Lightweight bundle size and fast SSR with SvelteKit

**Global:**

- Dynamic menu
- Hamburger menu
- SEO data

**Checkout:**

- Single page checkout (including login)
- Portable to other frameworks (doesn't use Next.js components)
- Adyen integration
- Stripe integration
- Customer address book
- Vouchers and Gift Cards

**Product catalog:**

- Categories
- Variant selection
- Product attributes
- Image optimization

**My account:**

- Order completion
- Order details

## 🚀 Quick Start

### 1. Create Saleor backend instance

To quickly get started with the backend, use a free developer account at [Saleor Cloud](https://cloud.saleor.io/?utm_source=storefront&utm_medium=github).

Alternatively you can [run Saleor locally using docker](https://docs.saleor.io/docs/3.x/setup/docker-compose?utm_source=storefront&utm_medium=github).

### 2. Clone and setup storefront

```bash
# Clone repository
git clone <your-repo-url>
cd saleor-storefront

# Setup environment
cp .env.example .env
# Edit .env and set PUBLIC_SALEOR_API_URL to your Saleor GraphQL endpoint
```

### 3. Run the application

#### Option A: Docker (Recommended)

```bash
# Auto-detects docker-compose or docker compose
./deploy.sh

# Or using npm scripts
pnpm run docker:deploy
```

#### Option B: Local development

```bash
# Install dependencies
pnpm install

# Start development server
pnpm run dev
```

🌐 **Open http://localhost:3000**

📄 **See [QUICK_START.md](./QUICK_START.md) for detailed instructions**

## Payments

Currently, Saleor Storefront supports payments via the [Saleor Adyen App](https://docs.saleor.io/docs/3.x/developer/app-store/apps/adyen). To install and configure the payment app go to the "Apps" section in the Saleor Dashboard (App Store is only available in Saleor Cloud).

> WARNING:
> To configure the Adyen App, you must have an account with [Adyen](https://www.adyen.com/).

## 💻 Development

```bash
# Start development server
pnpm run dev

# Build for production
pnpm run build

# Preview production build
pnpm run preview
```

The app runs at `http://localhost:3000`.

### GraphQL Code Generation

After altering or creating new GraphQL queries in the `src/graphql` folder:

```bash
pnpm run generate
```

### Docker Management

```bash
./deploy.sh    # Deploy with auto-detection of docker compose version
./status.sh    # Check container status
./logs.sh      # View logs
./stop.sh      # Stop containers
```

## 📦 Migration from Next.js

This project has been migrated from Next.js to SvelteKit. See [MIGRATION.md](./MIGRATION.md) for details.

**Key changes:**

- ⚡ SvelteKit instead of Next.js
- 🏠 Svelte components instead of React
- 📦 Environment variables: `PUBLIC_*` instead of `NEXT_PUBLIC_*`
- 🐳 Docker support for both `docker-compose` and `docker compose`

---

## 📁 Documentation

- 🚀 [Quick Start Guide](./QUICK_START.md)
- 🐳 [Deployment Guide](./DEPLOYMENT.md)
- 🔄 [Migration Details](./MIGRATION.md)

## ✨ What's New in SvelteKit Version

- **Better Performance**: Smaller bundle size and faster SSR
- **Modern DX**: Hot reload, TypeScript support, better dev tools
- **Flexible Deployment**: Works with both Docker Compose versions
- **Simplified State Management**: Reactive Svelte stores instead of complex React state
- **Better SEO**: Built-in SSR/SSG support
