<script lang="ts">
	let {
		src,
		alt,
		width,
		height,
		sizes,
		loading,
		priority,
	}: {
		src: string;
		alt: string;
		width: number;
		height: number;
		sizes: string;
		loading: "eager" | "lazy";
		priority?: boolean;
	} = $props();
</script>

<div class="aspect-square overflow-hidden bg-neutral-50">
	<img
		{src}
		{alt}
		{width}
		{height}
		loading={priority ? "eager" : loading}
		class="h-full w-full object-contain object-center p-2"
	/>
</div>
