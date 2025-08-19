import { expect, type Page } from "@playwright/test";

export async function clickOnRandomProductElement({ page }: { page: Page }) {
	const productLinks = page.getByTestId("ProductElement");
	await productLinks.first().waitFor();
	const count = await productLinks.count();
	const nth = Math.floor(Math.random() * count);
	return clickOnNthProductElement({ page, nth });
}

export async function clickOnNthProductElement({ page, nth }: { page: Page; nth: number }) {
	const productLinks = page.getByTestId("ProductElement");
	await productLinks.first().waitFor();
	const randomProductLink = productLinks.nth(nth);

	const name = await randomProductLink.getByRole("heading").textContent();
	const priceRange = await randomProductLink.getByTestId("ProductElement_PriceRange").textContent();
	const category = await randomProductLink.getByTestId("ProductElement_Category").textContent();

	await randomProductLink.click();

	await page.waitForURL("**/products/*");

	expect(name, "Missing product name").toBeTruthy();
	expect(priceRange, "Missing product priceRange").toBeTruthy();
	expect(category, "Missing product category").toBeTruthy();
	return { name: name!, priceRange: priceRange!, category: category! };
}

export async function getCurrentProductPrice({ page }: { page: Page }) {
	const price = await page.getByTestId("ProductElement_Price").textContent();
	expect(price, "Missing product price").toBeTruthy();
	return Number.parseFloat(price!.replace(/[^0-9\.]/g, ""));
}

export async function selectRandomAvailableVariant({ page }: { page: Page }) {
	// Wait for page to load
	await page.waitForLoadState("networkidle");

	// Check if we already have a variant in URL (auto-selected first variant)
	if (page.url().includes("?variant=")) {
		return;
	}

	// Try to find and select a variant manually
	try {
		await page.getByTestId("VariantSelector").waitFor({ timeout: 2000 });
		const variant = page.getByTestId("VariantSelector").getByRole("radio", { disabled: false });
		const count = await variant.count();
		if (count > 0) {
			await variant.nth(Math.floor(Math.random() * count)).click();
			// Wait for URL to update after click
			await page.waitForURL(/\?variant=.+/, { timeout: 5000 });
		}
	} catch (error) {
		// If no variant selector found, try to set first variant manually
		const firstVariantScript = `
			const firstVariant = document.querySelector('[name="variant"]');
			if (firstVariant && firstVariant.value) {
				const url = new URL(window.location.href);
				url.searchParams.set('variant', firstVariant.value);
				window.history.replaceState({}, '', url.toString());
			}
		`;
		await page.evaluate(firstVariantScript);

		// Check if URL was updated
		if (!page.url().includes("?variant=")) {
			console.log("Warning: Could not set variant parameter in URL");
		}
	}
}

export async function addCurrentProductToCart({ page }: { page: Page }) {
	expect(page.url()).toContain("/products/");

	// Wait for Add to cart button to be enabled and visible
	const checkoutButton = page.getByRole("button", { name: "Add to cart" });
	await checkoutButton.waitFor({ state: "visible" });
	await expect(checkoutButton).toBeEnabled();

	// Click the button
	await checkoutButton.click();

	// Wait a moment for the action to complete
	await page.waitForTimeout(1000);
}

export async function openCart({ page }: { page: Page }) {
	await page.getByTestId("CartNavItem").click();
	await page.getByText("Your Shopping Cart").waitFor();
}
