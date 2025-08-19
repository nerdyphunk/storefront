import { defineConfig, devices } from "@playwright/test";
import { config } from "dotenv";

// Load environment-specific config
const NODE_ENV = process.env.NODE_ENV || "test";
const envFile = `.env.${NODE_ENV}`;

// Try to load environment-specific config, fallback to .env
try {
	config({ path: envFile });
} catch {
	config(); // fallback to .env
}

const PORT = process.env.PORT || 3000;
const baseURL = process.env.BASE_URL || `http://localhost:${PORT}`;

// Test configuration
const testConfig = {
	testDir: "./__tests__",
	fullyParallel: true,
	workers: process.env.CI ? 3 : undefined,
	forbidOnly: !!process.env.CI,
	retries: process.env.CI ? 2 : 0,
	reporter: process.env.CI ? [["html"], ["github"], ["list"]] : [["html"], ["list"]],
	timeout: 60 * 1000,

	use: {
		baseURL,
		trace: "on-first-retry",
		screenshot: process.env.CI ? "only-on-failure" : "off",
		video: process.env.CI ? "retain-on-failure" : "off",
	},

	projects: [
		{
			name: "Desktop Chrome",
			use: { ...devices["Desktop Chrome"] },
		},
		// Uncomment for additional browser testing
		// {
		// 	name: "Desktop Firefox",
		// 	use: { ...devices["Desktop Firefox"] },
		// },
		// {
		// 	name: "Desktop Safari",
		// 	use: { ...devices["Desktop Safari"] },
		// },
		// {
		// 	name: "Mobile Chrome",
		// 	use: { ...devices["Pixel 5"] },
		// },
	],
};

// Web server configuration (only if BASE_URL is not set)
if (!process.env.BASE_URL) {
	// Auto-start development server for tests
	(testConfig as any).webServer = {
		command: "pnpm run dev",
		url: baseURL,
		reuseExistingServer: !process.env.CI,
		timeout: 120_000,
		env: {
			NODE_ENV: "development",
			// Inherit other environment variables
			...process.env,
		},
	};
}

export default defineConfig(testConfig);
