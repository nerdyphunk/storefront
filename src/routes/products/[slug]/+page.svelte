<script lang="ts">
	import type { PageData } from "./$types";
	import AddToCartButton from "@components/AddToCartButton.svelte";
	import { formatMoneyRange } from "@lib/utils";
	import { page } from "$app/stores";

	let { data }: { data: PageData } = $props();

	const { product } = data;

	// Get selected variant from URL params
	const selectedVariantId = $derived($page.url.searchParams.get("variant"));
	const selectedVariant = $derived(
		selectedVariantId ? product?.variants?.find((v: any) => v.id === selectedVariantId) : product?.variants?.[0],
	);

	const currentPrice = $derived(selectedVariant?.pricing?.price?.gross);

	// Auto-select first variant if none selected
	$effect(() => {
		if (typeof window !== "undefined" && product?.variants?.length && !selectedVariantId) {
			const firstVariant = product.variants[0];
			if (firstVariant?.id) {
				const url = new URL(window.location.href);
				url.searchParams.set("variant", firstVariant.id);
				window.history.replaceState({}, "", url.toString());
			}
		}
	});
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

				<!-- Variants -->
				{#if product.variants && product.variants.length > 1}
					<div class="mt-6" data-testid="VariantSelector">
						<h3 class="text-sm font-medium text-gray-900">Select variant:</h3>
						<div class="mt-2 space-y-2">
							{#each product.variants as variant}
								<label class="flex items-center">
									<input
										type="radio"
										name="variant"
										value={variant.id}
										checked={selectedVariantId === variant.id ||
											(!selectedVariantId && variant === product.variants[0])}
										disabled={!variant.quantityAvailable}
										onchange={() => {
											const url = new URL(window.location.href);
											url.searchParams.set("variant", variant.id);
											window.history.replaceState({}, "", url.toString());
										}}
										class="mr-2"
									/>
									<span class={variant.quantityAvailable ? "" : "text-gray-400"}>
										{variant.name}
										{#if variant.pricing?.price?.gross}
											- {variant.pricing.price.gross.amount} {variant.pricing.price.gross.currency}
										{/if}
										{#if !variant.quantityAvailable}
											(Out of stock)
										{/if}
									</span>
								</label>
							{/each}
						</div>
					</div>
				{/if}

				<!-- Pricing -->
				<div class="mt-6">
					{#if currentPrice}
						<p class="text-2xl font-bold text-gray-900" data-testid="ProductElement_Price">
							{currentPrice.amount}
							{currentPrice.currency}
						</p>
					{:else if product.pricing?.priceRange}
						<p class="text-2xl font-bold text-gray-900" data-testid="ProductElement_Price">
							{formatMoneyRange({
								start: product.pricing.priceRange.start?.gross,
								stop: product.pricing.priceRange.stop?.gross,
							})}
						</p>
					{/if}
				</div>

				<!-- Add to Cart Button -->
				<div class="mt-8">
					{#if selectedVariant?.id}
						<AddToCartButton
							variantId={selectedVariant.id}
							disabled={!selectedVariant.quantityAvailable}
							class="w-full"
						/>
					{:else}
						<button disabled class="w-full cursor-not-allowed rounded bg-gray-400 px-6 py-3 text-white">
							Select a variant
						</button>
					{/if}
				</div>
			</div>
		</div>
	</div>
{:else}
	<div class="mx-auto max-w-7xl px-4 py-8">
		<h1 class="text-2xl font-bold">Product not found</h1>
	</div>
{/if}
