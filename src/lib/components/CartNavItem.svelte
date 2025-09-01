<script lang="ts">
	import { cartStore } from "@stores/cart";
	import { onMount } from "svelte";

	onMount(() => {
		cartStore.initialize();
	});

	$: cart = $cartStore;
	$: itemsText = cart.itemsCount === 1 ? "1 item" : `${cart.itemsCount} items`;
</script>

<a href="/cart" class="text-gray-700 hover:text-gray-900" data-testid="CartNavItem">
	{#if cart.isLoading}
		<span class="text-sm">Loading...</span>
	{:else}
		Cart ({itemsText})
	{/if}
</a>
