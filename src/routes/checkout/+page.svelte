<script lang="ts">
	import type { PageData } from "./$types";
	import { cartStore } from "../../lib/stores/cart";
	import { onMount } from "svelte";

	let { data }: { data: PageData } = $props();

	onMount(() => {
		cartStore.initialize();
	});

	const cart = $derived($cartStore);

	let email = $state("");
	let country = $state("");
	let firstName = $state("");
	let lastName = $state("");
	let streetAddress = $state("");
	let city = $state("");
	let postalCode = $state("");
	let selectedDelivery = $state("");
	let isProcessing = $state(false);
	let orderComplete = $state(false);

	async function handleSubmit(event: Event) {
		event.preventDefault();
		isProcessing = true;
		// Simulate order processing
		await new Promise((resolve) => setTimeout(resolve, 1000));
		orderComplete = true;
		isProcessing = false;
	}
</script>

<svelte:head>
	<title>Checkout | Saleor Storefront</title>
	<meta name="description" content="Complete your order" />
</svelte:head>

<div class="mx-auto max-w-4xl px-4 py-8">
	{#if orderComplete}
		<!-- Order Confirmation -->
		<div class="rounded-lg bg-green-50 p-8 text-center">
			<h1 class="mb-4 text-3xl font-bold text-green-800">Thank you for placing your order.</h1>
			<p class="mb-6 text-green-600">Your order has been successfully processed.</p>

			<div class="rounded-lg bg-white p-6 shadow">
				<h2 class="mb-4 text-xl font-semibold">Order Summary</h2>
				<div data-testid="SummaryProductList">
					{#if cart.checkout?.lines?.length}
						{#each cart.checkout.lines as line}
							<div class="mb-2 flex justify-between" data-testid="SummaryItem">
								<span>{line.variant?.product?.name} x{line.quantity}</span>
								<span>{line.totalPrice?.gross?.amount} {line.totalPrice?.gross?.currency}</span>
							</div>
						{/each}
					{/if}
				</div>
			</div>
		</div>
	{:else}
		<!-- Checkout Form -->
		<h1 class="mb-8 text-3xl font-bold">Checkout</h1>

		<form onsubmit={handleSubmit} class="space-y-8">
			<!-- Customer Information -->
			<div class="rounded-lg bg-white p-6 shadow">
				<h2 class="mb-4 text-xl font-semibold">Customer Information</h2>
				<div class="grid gap-4">
					<div>
						<label for="email" class="block text-sm font-medium text-gray-700">Email</label>
						<input
							id="email"
							type="email"
							bind:value={email}
							class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500"
							required
						/>
					</div>
					<div>
						<label for="country" class="block text-sm font-medium text-gray-700">Country</label>
						<select
							id="country"
							bind:value={country}
							class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500"
							required
						>
							<option value="">Select Country</option>
							<option value="Poland">Poland</option>
							<option value="Germany">Germany</option>
							<option value="France">France</option>
						</select>
					</div>
				</div>
			</div>

			<!-- Shipping Address -->
			<div class="rounded-lg bg-white p-6 shadow" data-testid="shippingAddressSection">
				<h2 class="mb-4 text-xl font-semibold">Shipping Address</h2>
				<div class="grid grid-cols-1 gap-4 md:grid-cols-2">
					<div>
						<label for="firstName" class="block text-sm font-medium text-gray-700">First name</label>
						<input
							id="firstName"
							type="text"
							bind:value={firstName}
							class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500"
							required
						/>
					</div>
					<div>
						<label for="lastName" class="block text-sm font-medium text-gray-700">Last name</label>
						<input
							id="lastName"
							type="text"
							bind:value={lastName}
							class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500"
							required
						/>
					</div>
					<div class="md:col-span-2">
						<label for="streetAddress" class="block text-sm font-medium text-gray-700">Street address</label>
						<input
							id="streetAddress"
							type="text"
							bind:value={streetAddress}
							class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500"
							required
						/>
					</div>
					<div>
						<label for="city" class="block text-sm font-medium text-gray-700">City</label>
						<input
							id="city"
							type="text"
							bind:value={city}
							class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500"
							required
						/>
					</div>
					<div>
						<label for="postalCode" class="block text-sm font-medium text-gray-700">Postal code</label>
						<input
							id="postalCode"
							type="text"
							bind:value={postalCode}
							class="mt-1 block w-full rounded-md border border-gray-300 px-3 py-2 shadow-sm focus:border-blue-500 focus:outline-none focus:ring-blue-500"
							required
						/>
					</div>
				</div>
			</div>

			<!-- Delivery Methods -->
			<div class="rounded-lg bg-white p-6 shadow" data-testid="deliveryMethods">
				<h2 class="mb-4 text-xl font-semibold">Delivery Method</h2>
				<div class="space-y-2">
					<label class="flex items-center">
						<input type="radio" value="DHL" bind:group={selectedDelivery} class="mr-2" required />
						DHL - $10.00
					</label>
					<label class="flex items-center">
						<input type="radio" value="UPS" bind:group={selectedDelivery} class="mr-2" />
						UPS - $12.00
					</label>
				</div>
			</div>

			<!-- Payment Methods -->
			<div class="rounded-lg bg-white p-6 shadow" data-testid="paymentMethods">
				<h2 class="mb-4 text-xl font-semibold">Payment Method</h2>
				<div class="space-y-2">
					<label class="flex items-center">
						<input type="radio" value="dummy" name="payment" class="mr-2" checked />
						Dummy Payment Gateway
					</label>
				</div>
			</div>

			<!-- Order Summary -->
			{#if cart.checkout?.lines?.length}
				<div class="rounded-lg bg-white p-6 shadow">
					<h2 class="mb-4 text-xl font-semibold">Order Summary</h2>
					<div class="space-y-2">
						{#each cart.checkout.lines as line}
							<div class="flex justify-between">
								<span>{line.variant?.product?.name} x{line.quantity}</span>
								<span>{line.totalPrice?.gross?.amount} {line.totalPrice?.gross?.currency}</span>
							</div>
						{/each}
						{#if cart.checkout.totalPrice?.gross}
							<div class="border-t pt-2 font-bold">
								<div class="flex justify-between">
									<span>Total:</span>
									<span
										>{cart.checkout.totalPrice.gross.amount} {cart.checkout.totalPrice.gross.currency}</span
									>
								</div>
							</div>
						{/if}
					</div>
				</div>
			{/if}

			<!-- Submit Button -->
			<div class="flex justify-end">
				<button
					type="submit"
					class="rounded bg-blue-600 px-8 py-3 text-white hover:bg-blue-700 disabled:bg-gray-400"
					disabled={isProcessing}
				>
					{#if isProcessing}
						Processing...
					{:else}
						Make payment and create order
					{/if}
				</button>
			</div>
		</form>
	{/if}
</div>
