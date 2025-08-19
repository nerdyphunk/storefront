import { ProductListByCollectionDocument } from "../gql/graphql";
import { executeGraphQL } from "../lib/graphql";
import type { PageLoad } from "./$types";

export const load: PageLoad = async ({ url, fetch }) => {
	// Default channel for now, we'll add channel routing later
	const channel = "default-channel";

	// For now, just return empty data
	// const data = await executeGraphQL(ProductListByCollectionDocument, {
	// 	variables: {
	// 		slug: 'featured-products',
	// 		channel,
	// 	},
	// 	revalidate: 60,
	// });

	const data = { collection: null };

	if (!data.collection?.products) {
		return {
			products: null,
		};
	}

	const products = data.collection?.products.edges.map(({ node: product }) => product);

	return {
		products,
	};
};
