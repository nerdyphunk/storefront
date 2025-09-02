<script lang="ts">
	import type { ProductListItemFragment } from "@gql/graphql";
	import { formatMoneyRange } from "@lib/utils";
	import LinkWithChannel from "./LinkWithChannel.svelte";
	import ProductImageWrapper from "./ProductImageWrapper.svelte";

	let {
		product,
		loading,
		priority,
	}: {
		product: ProductListItemFragment;
		loading: "eager" | "lazy";
		priority?: boolean;
	} = $props();
</script>

<li data-testid="ProductElement">
	<LinkWithChannel href={`/products/${product.slug}`}>
		<div>
			{#if product?.thumbnail?.url}
				<ProductImageWrapper
					{loading}
					src={product.thumbnail.url}
					alt={product.thumbnail.alt ?? ""}
					width={512}
					height={512}
					sizes="512px"
					{priority}
				/>
			{/if}
			<div class="mt-2 flex justify-between">
				<div>
					<h3 class="mt-1 text-sm font-semibold text-neutral-900">{product.name}</h3>
					<p class="mt-1 text-sm text-neutral-500" data-testid="ProductElement_Category">
						{product.category?.name}
					</p>
				</div>
				<p class="mt-1 text-sm font-medium text-neutral-900" data-testid="ProductElement_PriceRange">
					{formatMoneyRange({
						start: product?.pricing?.priceRange?.start?.gross,
						stop: product?.pricing?.priceRange?.stop?.gross,
					})}
				</p>
			</div>
		</div>
	</LinkWithChannel>
</li>
