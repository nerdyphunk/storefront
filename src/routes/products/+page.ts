import type { PageLoad } from "./$types";

export const load: PageLoad = async () => {
	// Mock products for now
	const mockProducts = [
		{
			id: "1",
			name: "Sample Product 1",
			slug: "sample-product-1",
			thumbnail: {
				url: "https://via.placeholder.com/300x300?text=Product+1",
				alt: "Sample Product 1",
			},
			category: { name: "Electronics" },
			pricing: {
				priceRange: {
					start: { gross: { amount: 99.99, currency: "USD" } },
					stop: { gross: { amount: 99.99, currency: "USD" } },
				},
			},
		},
		{
			id: "2",
			name: "Sample Product 2",
			slug: "sample-product-2",
			thumbnail: {
				url: "https://via.placeholder.com/300x300?text=Product+2",
				alt: "Sample Product 2",
			},
			category: { name: "Clothing" },
			pricing: {
				priceRange: {
					start: { gross: { amount: 49.99, currency: "USD" } },
					stop: { gross: { amount: 79.99, currency: "USD" } },
				},
			},
		},
		{
			id: "3",
			name: "Sample Product 3",
			slug: "sample-product-3",
			thumbnail: {
				url: "https://via.placeholder.com/300x300?text=Product+3",
				alt: "Sample Product 3",
			},
			category: { name: "Home & Garden" },
			pricing: {
				priceRange: {
					start: { gross: { amount: 29.99, currency: "USD" } },
					stop: { gross: { amount: 29.99, currency: "USD" } },
				},
			},
		},
	];

	return {
		products: mockProducts,
	};
};
