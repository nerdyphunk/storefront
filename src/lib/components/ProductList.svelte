<script lang="ts">
	import type { ProductListItemFragment } from "$lib/../gql";
	import ProductElement from "./ProductElement.svelte";

	let { products }: { products: readonly ProductListItemFragment[] } = $props();
</script>

<ul role="list" data-testid="ProductList" class="grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3">
	{#each products as product, index}
		<ProductElement {product} priority={index < 2} loading={index < 3 ? "eager" : "lazy"} />
	{/each}
</ul>
