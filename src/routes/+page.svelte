<script lang="ts">
	import type { PageData } from "./$types";
	import ProductList from "@components/ProductList.svelte";

	let { data }: { data: PageData } = $props();
</script>

<svelte:head>
	<title>ACME Storefront, powered by Saleor & SvelteKit</title>
	<meta
		name="description"
		content="Storefront SvelteKit Example for building performant e-commerce experiences with Saleor - the composable, headless commerce platform for global brands."
	/>
</svelte:head>

<div class="mx-auto max-w-7xl px-4 py-12">
	<!-- Hero Section -->
	<div class="mb-16 text-center">
		<h1 class="mb-4 text-4xl font-bold text-gray-900">Welcome to Saleor Storefront</h1>
		<p class="mb-8 text-xl text-gray-600">Powered by SvelteKit - A modern e-commerce experience</p>
		<a href="/products" class="inline-block rounded-lg bg-blue-600 px-8 py-3 text-white hover:bg-blue-700">
			Shop Now
		</a>
	</div>

	<!-- Featured Products Section -->
	<section class="mb-16">
		<h2 class="mb-8 text-2xl font-bold text-gray-900">Featured Products</h2>
		{#if data.products}
			<ProductList products={data.products} />
		{:else}
			<p class="text-gray-600">No featured products available.</p>
		{/if}
	</section>
</div>
