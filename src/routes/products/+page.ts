import { ProductListPaginatedDocument } from "../../gql/graphql";
import { executeGraphQL } from "../../lib/graphql";
import type { PageLoad } from "./$types";

export const load: PageLoad = async ({ url }) => {
	try {
		const channel = "default-channel";

		// Get pagination parameters from URL
		const first = parseInt(url.searchParams.get("first") || "12");
		const after = url.searchParams.get("after") || undefined;

		const data = await executeGraphQL(ProductListPaginatedDocument, {
			variables: {
				first,
				after,
				channel,
			},
		});

		if (data.products?.edges?.length) {
			const products = data.products.edges.map(({ node: product }) => product);
			const pageInfo = data.products.pageInfo;
			return { products, pageInfo };
		}

		return {
			products: [],
			pageInfo: null,
		};
	} catch (error) {
		console.error("Failed to fetch products:", error);
		return {
			products: [],
			pageInfo: null,
			error: "Failed to load products. Please check API configuration.",
		};
	}
};
