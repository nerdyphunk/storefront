#!/bin/bash
set -e

# Saleor SvelteKit Storefront - Development CLI
# Usage: ./dev.sh [command] [environment]

COMMAND=${1:-help}
ENV=${2:-development}

# Detect available package manager
if command -v pnpm > /dev/null 2>&1; then
    PKG_MANAGER="pnpm"
    PKG_EXEC="pnpm exec"
elif command -v npm > /dev/null 2>&1; then
    PKG_MANAGER="npm"
    PKG_EXEC="npx"
else
    echo "❌ No package manager found. Please install npm or pnpm."
    exit 1
fi

echo "📦 Using package manager: $PKG_MANAGER"

show_help() {
    echo "🌐 Saleor SvelteKit Storefront - Development CLI"
    echo ""
    echo "Usage: ./dev.sh [command] [environment]"
    echo ""
    echo "Commands:"
    echo "  start [env]     - Start development server"
    echo "  docker [env]    - Start in Docker (test env runs tests)"
    echo "  build [env]     - Build for production"
    echo "  test [env]      - Run tests locally"
    echo "  stop [env]      - Stop Docker containers"
    echo "  logs [env]      - Show Docker logs"
    echo "  status          - Show Docker container status"
    echo "  clean           - Clean Docker containers and images"
    echo "  install         - Install Playwright browsers"
    echo "  help            - Show this help"
    echo ""
    echo "Environments:"
    echo "  development     - Local development (port 3000)"
    echo "  production      - Production build (port 3001)"
    echo "  test            - Testing environment (port 3002)"
    echo ""
    echo "Examples:"
    echo "  ./dev.sh start                    # Start local dev server"
    echo "  ./dev.sh docker development       # Start dev Docker container"
    echo "  ./dev.sh docker production        # Start prod Docker container"
    echo "  ./dev.sh docker test              # Run tests in Docker"
    echo "  ./dev.sh test                     # Run tests locally"
    echo "  ./dev.sh build production         # Build for production"
}

start_local() {
    echo "🚀 Starting local development server ($ENV)..."
    case $ENV in
        development)
            $PKG_EXEC dotenv -e .env.development -- $PKG_MANAGER run dev
            ;;
        production)
            $PKG_MANAGER run build:production && $PKG_EXEC dotenv -e .env.production -- $PKG_MANAGER run start
            ;;
        test)
            $PKG_EXEC dotenv -e .env.test -- $PKG_MANAGER run build && $PKG_EXEC dotenv -e .env.test -- $PKG_MANAGER run start
            ;;
        *)
            echo "❌ Unknown environment: $ENV"
            exit 1
            ;;
    esac
}

start_docker() {
    if [ "$ENV" = "test" ]; then
        echo "🧪 Running Docker tests..."
        ./test-docker.sh
    else
        echo "🐳 Starting Docker containers ($ENV)..."
        ./deploy.sh $ENV
    fi
}

build_project() {
    echo "🏗️  Building project ($ENV)..."
    case $ENV in
        development)
            $PKG_EXEC dotenv -e .env.development -- $PKG_MANAGER run build
            ;;
        production)
            $PKG_MANAGER run build:production
            ;;
        test)
            $PKG_EXEC dotenv -e .env.test -- $PKG_MANAGER run build
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
    if ! $PKG_EXEC playwright --version > /dev/null 2>&1; then
        echo "📺 Installing Playwright browsers..."
        $PKG_EXEC playwright install
        echo "✅ Playwright browsers installed!"
    fi
    
    case $ENV in
        local)
            $PKG_EXEC dotenv -e .env.test -- $PKG_EXEC playwright test
            ;;
        docker)
            # Use correct port based on environment
            case "$ENV" in
                test)
                    BASE_URL=http://localhost:3002 $PKG_EXEC dotenv -e .env.test -- $PKG_EXEC playwright test
                    ;;
                production)
                    BASE_URL=http://localhost:3001 $PKG_EXEC dotenv -e .env.test -- $PKG_EXEC playwright test
                    ;;
                *)
                    BASE_URL=http://localhost:3000 $PKG_EXEC dotenv -e .env.test -- $PKG_EXEC playwright test
                    ;;
            esac
            ;;
        *)
            $PKG_EXEC dotenv -e .env.test -- $PKG_EXEC playwright test
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
    $PKG_EXEC playwright install
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
