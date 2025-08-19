<script lang="ts">
	import type { PageData } from "./$types";

	let { data }: { data: PageData } = $props();
</script>

<svelte:head>
	<title>API Debug | Saleor Storefront</title>
</svelte:head>

<div class="mx-auto max-w-4xl px-4 py-8">
	<h1 class="mb-8 text-3xl font-bold">API Debug Information</h1>

	<div class="space-y-6">
		<div class="rounded-lg bg-white p-6 shadow">
			<h2 class="mb-4 text-xl font-semibold">Environment Variables</h2>
			<div class="space-y-2">
				<p><strong>API URL:</strong> <code class="rounded bg-gray-100 px-2 py-1">{data.apiUrl}</code></p>
				<p>
					<strong>Status:</strong>
					{#if data.apiUrl}
						<span class="text-green-600">✅ Configured</span>
					{:else}
						<span class="text-red-600">❌ Missing</span>
					{/if}
				</p>
			</div>
		</div>

		<div class="rounded-lg bg-white p-6 shadow">
			<h2 class="mb-4 text-xl font-semibold">API Test Result</h2>
			{#if data.testResult.success}
				<div class="text-green-600">
					<p class="font-semibold">✅ API Connection Successful</p>
					<p class="mt-2">Found <strong>{data.testResult.productCount}</strong> products</p>
					{#if data.testResult.sampleProducts}
						<div class="mt-4">
							<p class="font-medium">Sample products:</p>
							<ul class="mt-2 list-inside list-disc space-y-1">
								{#each data.testResult.sampleProducts as product}
									<li>{product.name} - {product.id}</li>
								{/each}
							</ul>
						</div>
					{/if}
				</div>
			{:else}
				<div class="text-red-600">
					<p class="font-semibold">❌ API Connection Failed</p>
					{#if data.testResult.error}
						<p class="mt-2"><strong>Error:</strong> {data.testResult.error}</p>
					{/if}
				</div>
			{/if}
		</div>

		<div class="rounded-lg border border-blue-200 bg-blue-50 p-4">
			<h3 class="font-semibold text-blue-800">Troubleshooting Tips:</h3>
			<ul class="mt-2 list-inside list-disc space-y-1 text-blue-700">
				<li>Make sure <code>PUBLIC_SALEOR_API_URL</code> is set in Vercel environment variables</li>
				<li>Verify the URL ends with <code>/graphql/</code></li>
				<li>Check if your Saleor instance is accessible publicly</li>
				<li>Ensure CORS is configured properly in your Saleor backend</li>
			</ul>
		</div>

		<div class="text-center">
			<a href="/" class="inline-block rounded-lg bg-blue-600 px-6 py-3 text-white hover:bg-blue-700">
				← Back to Home
			</a>
		</div>
	</div>
</div>
