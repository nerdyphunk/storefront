import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";
import path from "path";

export default defineConfig({
	plugins: [sveltekit()],
	server: {
		port: parseInt(process.env.PORT || "3000"),
	},
	resolve: {
		alias: {
			"@": path.resolve("./src"),
			"@lib": path.resolve("./src/lib"),
			"@components": path.resolve("./src/lib/components"),
			"@stores": path.resolve("./src/lib/stores"),
			"@utils": path.resolve("./src/lib/utils"),
			"@gql": path.resolve("./src/gql"),
			"@graphql": path.resolve("./src/graphql"),
		},
	},
});
