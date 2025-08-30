import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";

export default defineConfig(({ mode }) => {
	// Vite автоматически устанавливает NODE_ENV:
	// - development для dev server
	// - production для build
	console.log(`🎨 Vite mode: ${mode}, NODE_ENV: ${process.env.NODE_ENV}`);

	return {
		plugins: [sveltekit()],
		server: {
			port: parseInt(process.env.PORT || "3000"),
		},
		preview: {
			port: parseInt(process.env.PORT || "4173"),
			host: true,
		},
		define: {
			// Доступно в клиентском коде как __APP_ENV__
			__APP_ENV__: JSON.stringify(mode),
		},
	};
});
