<script lang="ts">
	import "../app.css";
	import { page } from "$app/stores";
	import { onMount } from "svelte";

	// Import DraftModeNotification when we create it
	// import DraftModeNotification from '$lib/components/DraftModeNotification.svelte';

	let { children } = $props();
</script>

<svelte:head>
	<title>Saleor Storefront example</title>
	<meta
		name="description"
		content="Starter pack for building performant e-commerce experiences with Saleor."
	/>
</svelte:head>

{@render children()}

<!-- TODO: Add DraftModeNotification component -->
<!-- <DraftModeNotification /> -->
