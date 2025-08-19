import { ProductListByCollectionDocument } from "../gql/graphql";
import { executeGraphQL } from "../lib/graphql";
import type { PageLoad } from "./$types";

export const load: PageLoad = async ({ url, fetch }) => {
	// Default channel for now, we'll add channel routing later
	const channel = "default-channel";

	// Mock featured products for now
	const mockProducts = [
		{
			id: "1",
			name: "Featured Product 1",
			slug: "featured-product-1",
			thumbnail: {
				url: "https://via.placeholder.com/300x300?text=Featured+1",
				alt: "Featured Product 1",
			},
			category: { name: "Featured" },
			pricing: {
				priceRange: {
					start: { gross: { amount: 149.99, currency: "USD" } },
					stop: { gross: { amount: 149.99, currency: "USD" } },
				},
			},
		},
		{
			id: "2",
			name: "Featured Product 2",
			slug: "featured-product-2",
			thumbnail: {
				url: "https://via.placeholder.com/300x300?text=Featured+2",
				alt: "Featured Product 2",
			},
			category: { name: "Featured" },
			pricing: {
				priceRange: {
					start: { gross: { amount: 89.99, currency: "USD" } },
					stop: { gross: { amount: 89.99, currency: "USD" } },
				},
			},
		},
	];

	return {
		products: mockProducts,
	};
};
