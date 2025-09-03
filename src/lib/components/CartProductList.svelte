<script lang="ts">
	import { cartStore } from "@stores/cart";
	import type { CheckoutFragmentFragment } from "$lib/../gql";

	let { checkout }: { checkout: CheckoutFragmentFragment | null } = $props();

	async function handleRemove(lineId: string) {
		await cartStore.removeItem(lineId);
	}
</script>

{#if checkout?.lines?.length}
	<ul class="space-y-4" data-testid="CartProductList">
		{#each checkout.lines as line}
			<li class="flex items-center justify-between border-b pb-4">
				<div class="flex items-center space-x-4">
					{#if line.variant?.product?.thumbnail}
						<img
							src={line.variant.product.thumbnail.url}
							alt={line.variant.product.thumbnail.alt || line.variant.product.name}
							class="h-16 w-16 rounded object-cover"
						/>
					{/if}
					<div>
						<h3 class="font-medium">{line.variant?.product?.name || "Unknown Product"}</h3>
						{#if line.variant?.name && line.variant.name !== line.variant.product?.name}
							<p class="text-sm text-gray-600">{line.variant.name}</p>
						{/if}
						<p class="text-sm text-gray-600">Qty: {line.quantity}</p>
					</div>
				</div>

				<div class="flex items-center space-x-4">
					{#if line.totalPrice?.gross}
						<span class="font-medium">
							{Number(line.totalPrice.gross.amount).toFixed(2)}
							{line.totalPrice.gross.currency}
						</span>
					{/if}

					<button onclick={() => handleRemove(line.id)} class="text-sm text-red-600 hover:text-red-800">
						Remove
					</button>
				</div>
			</li>
		{/each}
	</ul>

	{#if checkout.totalPrice?.gross}
		<div class="mt-6 border-t pt-4">
			<div class="flex justify-between text-xl font-bold">
				<span>Total:</span>
				<span>{Number(checkout.totalPrice.gross.amount).toFixed(2)} {checkout.totalPrice.gross.currency}</span
				>
			</div>
		</div>
	{/if}
{:else}
	<p class="text-gray-600">Your cart is empty.</p>
{/if}
