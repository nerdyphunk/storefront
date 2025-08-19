import { ProductDetailsDocument } from "../../../gql/graphql";
import { executeGraphQL } from "../../../lib/graphql";
import type { PageLoad } from "./$types";
import { error } from "@sveltejs/kit";

export const load: PageLoad = async ({ params }) => {
	// For now, return mock data
	// TODO: Implement real GraphQL query
	/*
	const data = await executeGraphQL(ProductDetailsDocument, {
		variables: {
			slug: params.slug,
			channel: 'default-channel'
		}
	});

	if (!data.product) {
		throw error(404, 'Product not found');
	}

	return {
		product: data.product
	};
	*/

	// Mock data for now
	return {
		product: {
			id: "1",
			name: `Product ${params.slug}`,
			slug: params.slug,
			description: "This is a sample product description.",
			thumbnail: {
				url: "https://via.placeholder.com/400x400",
				alt: `Product ${params.slug}`,
			},
			category: {
				name: "Sample Category",
			},
			pricing: {
				priceRange: {
					start: { gross: { amount: 29.99, currency: "USD" } },
				},
			},
		},
	};
};
