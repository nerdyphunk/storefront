<script lang="ts">
	import "../app.css";
	import { page } from "$app/stores";

	let { children } = $props();
</script>

<svelte:head>
	<title>Saleor Storefront example</title>
	<meta
		name="description"
		content="Starter pack for building performant e-commerce experiences with Saleor."
	/>
</svelte:head>

<div class="min-h-screen bg-gray-50">
	<!-- Header -->
	<header class="bg-white shadow-sm">
		<nav class="mx-auto max-w-7xl px-4 py-4">
			<div class="flex items-center justify-between">
				<a href="/" class="text-2xl font-bold text-gray-900"> Saleor Storefront </a>

				<div class="flex items-center space-x-6">
					<a href="/" class="text-gray-700 hover:text-gray-900">Home</a>
					<a href="/products" class="text-gray-700 hover:text-gray-900">Products</a>
					<a href="/cart" class="text-gray-700 hover:text-gray-900">Cart</a>
					<a href="/debug" class="text-sm text-gray-500 hover:text-gray-700">Debug</a>
				</div>
			</div>
		</nav>
	</header>

	<!-- Main Content -->
	<main>
		{@render children()}
	</main>

	<!-- Footer -->
	<footer class="bg-gray-800 text-white">
		<div class="mx-auto max-w-7xl px-4 py-8">
			<div class="text-center">
				<p>&copy; 2024 Saleor Storefront. Built with SvelteKit.</p>
			</div>
		</div>
	</footer>
</div>
