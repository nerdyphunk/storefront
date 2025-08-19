import type { PageLoad } from "./$types";

export const load: PageLoad = async () => {
	// For now, return empty cart
	return {
		cart: {
			items: [],
			total: { gross: { amount: 0, currency: "USD" } },
		},
	};
};
