<script lang="ts">
	import type { PageData } from "./$types";
	import ProductList from "../lib/components/ProductList.svelte";

	let { data }: { data: PageData } = $props();
</script>

<svelte:head>
	<title>ACME Storefront, powered by Saleor & SvelteKit</title>
	<meta
		name="description"
		content="Storefront SvelteKit Example for building performant e-commerce experiences with Saleor - the composable, headless commerce platform for global brands."
	/>
</svelte:head>

<section class="mx-auto max-w-7xl p-8 pb-16">
	<h2 class="sr-only">Product list</h2>
	{#if data.products}
		<ProductList products={data.products} />
	{/if}
</section>
