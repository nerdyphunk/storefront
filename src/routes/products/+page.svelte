<script lang="ts">
	import type { PageData } from "./$types";
	import ProductList from "../../lib/components/ProductList.svelte";

	let { data }: { data: PageData } = $props();
</script>

<svelte:head>
	<title>All Products | Saleor Storefront</title>
	<meta name="description" content="Browse all products in our store." />
</svelte:head>

<div class="mx-auto max-w-7xl px-4 py-8">
	<h1 class="mb-8 text-3xl font-bold">All Products</h1>

	{#if data.products && data.products.length > 0}
		<ProductList products={data.products} />
	{:else}
		<p class="text-gray-600">No products found.</p>
	{/if}
</div>
