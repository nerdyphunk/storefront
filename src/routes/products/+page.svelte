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

	{#if data.error}
		<div class="mb-6 rounded-lg border border-red-200 bg-red-50 p-4">
			<h2 class="font-semibold text-red-800">API Error</h2>
			<p class="mt-1 text-red-600">{data.error}</p>
			<a href="/debug" class="mt-2 inline-block text-red-700 underline">Check API Debug Page</a>
		</div>
	{:else if data.products && data.products.length > 0}
		<ProductList products={data.products} />
		{#if data.pageInfo?.hasNextPage}
			<div class="mt-8 text-center">
				<a
					href="?after={data.pageInfo.endCursor}"
					class="rounded-lg bg-blue-600 px-6 py-3 text-white hover:bg-blue-700"
				>
					Load More
				</a>
			</div>
		{/if}
	{:else}
		<div class="py-12 text-center">
			<p class="mb-4 text-gray-600">No products found.</p>
			<a href="/debug" class="text-blue-600 underline">Check API Configuration</a>
		</div>
	{/if}
</div>
