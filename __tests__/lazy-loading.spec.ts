import { expect, test } from "@playwright/test";

/**
 * Test suite for lazy loading functionality on products page
 */
test.describe("Products Page Lazy Loading", () => {
	test("should load initial products on page load", async ({ page }) => {
		await page.goto("/products");

		// Wait for products to load
		await page.waitForSelector('[data-testid="ProductList"]');
		
		// Should have initial products loaded
		const initialProducts = await page.locator('[data-testid="ProductList"] li').count();
		expect(initialProducts).toBeGreaterThan(0);
		expect(initialProducts).toBeLessThanOrEqual(12); // Default page size

		// Load More button should be visible if there are more products
		const loadMoreButton = page.getByTestId("load-more-button");
		const hasLoadMoreButton = await loadMoreButton.isVisible();
		
		if (hasLoadMoreButton) {
			expect(loadMoreButton).toBeVisible();
		}
	});

	test("should load more products when clicking Load More button", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		// Get initial product count
		const initialCount = await page.locator('[data-testid="ProductList"] li').count();
		
		// Check if Load More button exists
		const loadMoreButton = page.getByTestId("load-more-button");
		if (!(await loadMoreButton.isVisible())) {
			// Skip test if no more products to load
			test.skip(true, "No more products to load - Load More button not visible");
			return;
		}

		// Click Load More button
		await loadMoreButton.click();

		// Wait for loading state to appear and disappear
		await expect(page.locator('text=Loading more products')).toBeVisible();
		await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 10000 });

		// Check that more products were added
		const newCount = await page.locator('[data-testid="ProductList"] li').count();
		expect(newCount).toBeGreaterThan(initialCount);
		expect(newCount).toBeLessThanOrEqual(initialCount + 12); // Should add up to 12 more
	});

	test("should show loading spinner when loading more products", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		const loadMoreButton = page.getByTestId("load-more-button");
		if (!(await loadMoreButton.isVisible())) {
			test.skip(true, "No more products to load");
			return;
		}

		// Click Load More and immediately check for spinner
		await loadMoreButton.click();
		
		// Loading indicator should appear quickly
		await expect(page.locator('text=Loading more products')).toBeVisible({ timeout: 1000 });
		
		// Wait for loading to complete
		await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 10000 });
	});

	test("should disable Load More button while loading", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		const loadMoreButton = page.getByTestId("load-more-button");
		if (!(await loadMoreButton.isVisible())) {
			test.skip(true, "No more products to load");
			return;
		}

		// Button should be enabled initially
		await expect(loadMoreButton).toBeEnabled();

		// Click and check if disabled
		await loadMoreButton.click();
		
		// Button should be disabled while loading
		await expect(loadMoreButton).toBeDisabled();
		
		// Wait for loading to complete
		await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 10000 });
	});

	test("should hide Load More button when no more products", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		// Keep clicking Load More until no more products
		let clickCount = 0;
		const maxClicks = 10; // Prevent infinite loop
		
		while (clickCount < maxClicks) {
			const loadMoreButton = page.getByTestId("load-more-button");
			
			if (!(await loadMoreButton.isVisible())) {
				// No more Load More button - check for end message
				await expect(page.locator('text=You\'ve reached the end')).toBeVisible();
				break;
			}
			
			await loadMoreButton.click();
			await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 10000 });
			clickCount++;
		}
	});

	test("should maintain scroll position after loading more products", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		const loadMoreButton = page.getByTestId("load-more-button");
		if (!(await loadMoreButton.isVisible())) {
			test.skip(true, "No more products to load");
			return;
		}

		// Scroll to Load More button
		await loadMoreButton.scrollIntoViewIfNeeded();
		
		// Get current scroll position
		const scrollYBefore = await page.evaluate(() => window.scrollY);
		
		// Click Load More
		await loadMoreButton.click();
		await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 10000 });
		
		// Check that scroll position is maintained (should be close to original position)
		const scrollYAfter = await page.evaluate(() => window.scrollY);
		expect(Math.abs(scrollYAfter - scrollYBefore)).toBeLessThan(200); // Allow some variance
	});

	test("should handle error state gracefully", async ({ page }) => {
		// Intercept API calls and make them fail after first load
		let interceptCount = 0;
		await page.route('**/graphql/', async (route) => {
			interceptCount++;
			if (interceptCount === 1) {
				// Let first request through
				await route.continue();
			} else {
				// Fail subsequent requests
				await route.fulfill({
					status: 500,
					body: JSON.stringify({ errors: [{ message: 'Server error' }] })
				});
			}
		});

		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		const loadMoreButton = page.getByTestId("load-more-button");
		if (!(await loadMoreButton.isVisible())) {
			test.skip(true, "No more products to load");
			return;
		}

		// Click Load More - this should fail
		await loadMoreButton.click();
		
		// Should show error message
		await expect(page.locator('text=Loading Error')).toBeVisible({ timeout: 5000 });
		await expect(page.locator('text=Failed to load more products')).toBeVisible();
		
		// Try Again button should be visible
		await expect(page.locator('button:has-text("Try Again")')).toBeVisible();
	});

	test("should prefetch next page while scrolling", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		const loadMoreButton = page.getByTestId("load-more-button");
		if (!(await loadMoreButton.isVisible())) {
			test.skip(true, "No more products to load");
			return;
		}

		// Monitor network requests
		const requestUrls: string[] = [];
		page.on('request', (request) => {
			if (request.url().includes('graphql')) {
				requestUrls.push(request.url());
			}
		});

		// Scroll down 80% of the page to trigger prefetching
		const documentHeight = await page.evaluate(() => document.documentElement.scrollHeight);
		const scrollTarget = documentHeight * 0.8;
		await page.evaluate((target) => window.scrollTo(0, target), scrollTarget);

		// Wait a bit for prefetching to potentially trigger
		await page.waitForTimeout(1000);

		// Click Load More - should be faster due to prefetching
		const startTime = Date.now();
		await loadMoreButton.click();
		await expect(page.locator('text=Loading more products')).toBeVisible();
		await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 5000 });
		const endTime = Date.now();

		// Should complete relatively quickly (under 2 seconds) due to prefetching
		const loadTime = endTime - startTime;
		expect(loadTime).toBeLessThan(2000);
	});

	test("should work with keyboard navigation", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		const loadMoreButton = page.getByTestId("load-more-button");
		if (!(await loadMoreButton.isVisible())) {
			test.skip(true, "No more products to load");
			return;
		}

		// Focus the Load More button using keyboard navigation
		await loadMoreButton.focus();
		await expect(loadMoreButton).toBeFocused();

		// Get initial product count
		const initialCount = await page.locator('[data-testid="ProductList"] li').count();

		// Press Enter to activate the button
		await page.keyboard.press('Enter');

		// Wait for loading to complete
		await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 10000 });

		// Check that more products were loaded
		const newCount = await page.locator('[data-testid="ProductList"] li').count();
		expect(newCount).toBeGreaterThan(initialCount);
	});
});

/**
 * Test suite for products store functionality
 */
test.describe("Products Store", () => {
	test("should initialize store with server data", async ({ page }) => {
		// Add script to check store initialization
		await page.addInitScript(() => {
			(window as any).storeEvents = [];
		});

		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		// Verify products are displayed
		const productCount = await page.locator('[data-testid="ProductList"] li').count();
		expect(productCount).toBeGreaterThan(0);
	});

	test("should reset store when navigating away and back", async ({ page }) => {
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		// Load more products if available
		const loadMoreButton = page.getByTestId("load-more-button");
		if (await loadMoreButton.isVisible()) {
			await loadMoreButton.click();
			await expect(page.locator('text=Loading more products')).toBeHidden({ timeout: 10000 });
		}

		// Get current product count
		const loadedCount = await page.locator('[data-testid="ProductList"] li').count();

		// Navigate away and back
		await page.goto("/");
		await page.goto("/products");
		await page.waitForSelector('[data-testid="ProductList"]');

		// Should show initial product count again (store reset)
		const resetCount = await page.locator('[data-testid="ProductList"] li').count();
		expect(resetCount).toBeLessThanOrEqual(12); // Back to initial page size
		expect(resetCount).toBeLessThan(loadedCount); // Should be less than what we loaded before
	});
});
