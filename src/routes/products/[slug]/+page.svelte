<script lang="ts">
	import type { PageData } from "./$types";

	let { data }: { data: PageData } = $props();

	const { product } = data;
</script>

<svelte:head>
	<title>{product?.name || "Product"} | Saleor Storefront</title>
	<meta name="description" content={product?.seoDescription || product?.description || ""} />
</svelte:head>

{#if product}
	<div class="mx-auto max-w-7xl px-4 py-8">
		<div class="grid grid-cols-1 gap-8 lg:grid-cols-2">
			<!-- Product Images -->
			<div>
				{#if product.thumbnail}
					<img
						src={product.thumbnail.url}
						alt={product.thumbnail.alt || product.name}
						class="w-full rounded-lg"
					/>
				{/if}
			</div>

			<!-- Product Details -->
			<div>
				<h1 class="text-3xl font-bold">{product.name}</h1>

				{#if product.category}
					<p class="mt-2 text-gray-600">{product.category.name}</p>
				{/if}

				{#if product.description}
					<div class="prose mt-4 max-w-none">
						{@html product.description}
					</div>
				{/if}

				<!-- Pricing -->
				{#if product.pricing?.priceRange}
					<div class="mt-6">
						<p class="text-2xl font-bold text-gray-900">
							<!-- Price display logic here -->
							Price available
						</p>
					</div>
				{/if}

				<!-- Add to Cart Button -->
				<button class="mt-8 w-full rounded bg-blue-600 px-6 py-3 text-white hover:bg-blue-700">
					Add to Cart
				</button>
			</div>
		</div>
	</div>
{:else}
	<div class="mx-auto max-w-7xl px-4 py-8">
		<h1 class="text-2xl font-bold">Product not found</h1>
	</div>
{/if}
