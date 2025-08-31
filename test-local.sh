#!/bin/bash
set -e

echo "🧪 Saleor Storefront - Local Test Runner"
echo "=========================================="
echo ""

# Check if development server is already running
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Development server detected on http://localhost:3000"
    echo "🧪 Running tests against existing server..."
    echo ""
    BASE_URL=http://localhost:3000 npx dotenv-cli -e .env.test -- npx playwright test
else
    echo "⚠️  No development server detected on http://localhost:3000"
    echo "🚀 Two options:"
    echo ""
    echo "   Option 1: Manual server (RECOMMENDED)"
    echo "   - Run: npm run dev:local (in another terminal)"
    echo "   - Then run this script again"
    echo ""
    echo "   Option 2: Auto-start server (slower)"
    echo "   - Tests will start their own server (takes ~3 minutes)"
    echo ""
    read -p "   Choose option (1/2) or Ctrl+C to cancel: " choice
    
    case $choice in
        1)
            echo "📝 Please start the dev server and run this script again:"
            echo "   npm run dev:local"
            exit 1
            ;;
        2)
            echo "🔄 Starting tests with auto-server (this may take a while)..."
            npx dotenv-cli -e .env.test -- npx playwright test
            ;;
        *)
            echo "❌ Invalid choice. Please run the script again."
            exit 1
            ;;
    esac
fi
