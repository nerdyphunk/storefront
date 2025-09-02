<script lang="ts">
	import { cartStore } from "@stores/cart";

	let {
		variantId,
		quantity = 1,
		channel = "default-channel",
		disabled = false,
		class: className = "",
	}: {
		variantId: string;
		quantity?: number;
		channel?: string;
		disabled?: boolean;
		class?: string;
	} = $props();

	const cart = $derived($cartStore);
	const isLoading = $derived(cart.isLoading);

	async function handleAddToCart() {
		if (variantId) {
			await cartStore.addItem(variantId, quantity, channel);
		}
	}
</script>

<button
	onclick={handleAddToCart}
	disabled={disabled || isLoading || !variantId}
	class="inline-flex items-center justify-center rounded-lg bg-blue-600 px-6 py-3 text-white hover:bg-blue-700 disabled:cursor-not-allowed disabled:bg-gray-400 {className}"
>
	{#if isLoading}
		<span class="mr-2">
			<svg class="h-4 w-4 animate-spin" viewBox="0 0 24 24" fill="none">
				<circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
				<path
					class="opacity-75"
					fill="currentColor"
					d="m4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
				></path>
			</svg>
		</span>
		Adding...
	{:else}
		Add to cart
	{/if}
</button>

{#if cart.error}
	<p class="mt-2 text-sm text-red-600">{cart.error}</p>
{/if}
