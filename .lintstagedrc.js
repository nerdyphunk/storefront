// SvelteKit lint-staged configuration

export default {
	// Skip linting for now during migration
	// "*.{js,cjs,mjs,jsx,ts,cts,mts,tsx,svelte}": ["eslint --fix"],
	"*.*": "prettier --write --ignore-unknown",
};
