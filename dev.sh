#!/bin/bash
set -e

# Saleor SvelteKit Storefront - Development CLI
# Usage: ./dev.sh [command] [environment]

COMMAND=${1:-help}
ENV=${2:-development}

show_help() {
    echo "🌐 Saleor SvelteKit Storefront - Development CLI"
    echo ""
    echo "Usage: ./dev.sh [command] [environment]"
    echo ""
    echo "Commands:"
    echo "  start [env]     - Start development server"
    echo "  docker [env]    - Start in Docker"
    echo "  build [env]     - Build for production"
    echo "  test [env]      - Run tests"
    echo "  stop [env]      - Stop Docker containers"
    echo "  logs [env]      - Show Docker logs"
    echo "  status          - Show Docker container status"
    echo "  clean           - Clean Docker containers and images"
    echo "  install         - Install Playwright browsers"
    echo "  help            - Show this help"
    echo ""
    echo "Environments:"
    echo "  development     - Local development (default)"
    echo "  production      - Production build"
    echo "  test            - Testing environment"
    echo ""
    echo "Examples:"
    echo "  ./dev.sh start                    # Start local dev server"
    echo "  ./dev.sh docker development       # Start dev Docker container"
    echo "  ./dev.sh docker production        # Start prod Docker container"
    echo "  ./dev.sh test                     # Run tests"
    echo "  ./dev.sh build production         # Build for production"
}

start_local() {
    echo "🚀 Starting local development server ($ENV)..."
    case $ENV in
        development)
            pnpm exec dotenv -e .env.development -- pnpm run dev
            ;;
        production)
            pnpm run build:production && pnpm exec dotenv -e .env.production -- pnpm run start
            ;;
        test)
            pnpm exec dotenv -e .env.test -- pnpm run build && pnpm exec dotenv -e .env.test -- pnpm run start
            ;;
        *)
            echo "❌ Unknown environment: $ENV"
            exit 1
            ;;
    esac
}

start_docker() {
    echo "🐳 Starting Docker containers ($ENV)..."
    ./deploy.sh $ENV
}

build_project() {
    echo "🏗️  Building project ($ENV)..."
    case $ENV in
        development)
            pnpm exec dotenv -e .env.development -- pnpm run build
            ;;
        production)
            pnpm run build:production
            ;;
        test)
            pnpm exec dotenv -e .env.test -- pnpm run build
            ;;
        *)
            echo "❌ Unknown environment: $ENV"
            exit 1
            ;;
    esac
}

run_tests() {
    echo "🧪 Running tests ($ENV)..."
    
    # Check if Playwright browsers are installed
    if ! pnpm exec playwright --version > /dev/null 2>&1; then
        echo "📺 Installing Playwright browsers..."
        pnpm exec playwright install
        echo "✅ Playwright browsers installed!"
    fi
    
    case $ENV in
        local)
            pnpm exec dotenv -e .env.test -- pnpm exec playwright test
            ;;
        docker)
            BASE_URL=http://localhost:3000 pnpm exec dotenv -e .env.test -- pnpm exec playwright test
            ;;
        *)
            pnpm exec dotenv -e .env.test -- pnpm exec playwright test
            ;;
    esac
}

stop_containers() {
    echo "🛑 Stopping Docker containers ($ENV)..."
    ./stop.sh $ENV
}

show_logs() {
    echo "📝 Showing Docker logs ($ENV)..."
    ./logs.sh $ENV
}

show_status() {
    echo "📊 Checking Docker status..."
    ./status.sh
}

clean_docker() {
    echo "🧹 Cleaning Docker containers and images..."
    docker system prune -f
    echo "✅ Docker cleanup complete!"
}

install_browsers() {
    echo "📺 Installing Playwright browsers..."
    pnpm exec playwright install
    echo "✅ Playwright browsers installed!"
}

case $COMMAND in
    start)
        start_local
        ;;
    docker)
        start_docker
        ;;
    build)
        build_project
        ;;
    test)
        run_tests
        ;;
    stop)
        stop_containers
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_docker
        ;;
    install)
        install_browsers
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        show_help
        exit 1
        ;;
esac
