<script lang="ts">
	import type { PageData } from "./$types";

	let { data }: { data: PageData } = $props();
</script>

<svelte:head>
	<title>Shopping Cart | Saleor Storefront</title>
	<meta name="description" content="Your shopping cart" />
</svelte:head>

<div class="mx-auto max-w-7xl px-4 py-8">
	<h1 class="mb-8 text-3xl font-bold">Shopping Cart</h1>

	<div class="rounded-lg bg-white p-6 shadow">
		<p class="text-gray-600">Your cart is currently empty.</p>

		<div class="mt-4">
			<a href="/products" class="inline-block rounded bg-blue-600 px-6 py-3 text-white hover:bg-blue-700">
				Continue Shopping
			</a>
		</div>
	</div>
</div>
