<script lang="ts">
	import { page } from "$app/stores";

	let {
		href,
		children,
		...props
	}: {
		href: string;
		children?: any;
		[key: string]: any;
	} = $props();

	// For now, we'll use a simple approach without channel routing
	// TODO: Implement proper channel routing
	let finalHref = $derived(href);
</script>

<a {href} {...props}>
	{@render children?.()}
</a>
