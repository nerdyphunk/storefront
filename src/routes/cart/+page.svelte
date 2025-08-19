<script lang="ts">
	import type { PageData } from "./$types";
	import { cartStore } from "../../lib/stores/cart";
	import CartProductList from "../../lib/components/CartProductList.svelte";
	import { onMount } from "svelte";

	let { data }: { data: PageData } = $props();

	onMount(() => {
		cartStore.initialize();
	});

	const cart = $derived($cartStore);
</script>

<svelte:head>
	<title>Shopping Cart | Saleor Storefront</title>
	<meta name="description" content="Your shopping cart" />
</svelte:head>

<div class="mx-auto max-w-7xl px-4 py-8">
	<h1 class="mb-8 text-3xl font-bold">Your Shopping Cart</h1>

	{#if cart.isLoading}
		<div class="flex justify-center py-8">
			<div class="h-8 w-8 animate-spin rounded-full border-b-2 border-blue-600"></div>
		</div>
	{:else}
		<div class="rounded-lg bg-white p-6 shadow">
			<CartProductList checkout={cart.checkout} />

			{#if cart.checkout?.lines?.length}
				<div class="mt-8 flex justify-end space-x-4">
					<a href="/products" class="rounded bg-gray-200 px-6 py-3 text-gray-800 hover:bg-gray-300">
						Continue Shopping
					</a>
					<button class="rounded bg-blue-600 px-6 py-3 text-white hover:bg-blue-700">
						Proceed to Checkout
					</button>
				</div>
			{:else}
				<div class="py-8 text-center">
					<p class="mb-4 text-gray-600">Your cart is currently empty.</p>
					<a href="/products" class="inline-block rounded bg-blue-600 px-6 py-3 text-white hover:bg-blue-700">
						Continue Shopping
					</a>
				</div>
			{/if}
		</div>
	{/if}

	{#if cart.error}
		<div class="mt-4 rounded bg-red-100 p-4 text-red-700">
			{cart.error}
		</div>
	{/if}
</div>
