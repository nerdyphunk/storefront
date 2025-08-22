<script lang="ts">
	let { size = "medium", class: className = "" }: {
		size?: "small" | "medium" | "large";
		class?: string;
	} = $props();
	
	const sizeClasses = {
		small: "h-4 w-4",
		medium: "h-8 w-8",
		large: "h-12 w-12"
	};
</script>

<div 
	class="inline-block animate-spin rounded-full border-2 border-solid border-current border-e-transparent align-[-0.125em] text-blue-600 motion-reduce:animate-[spin_1.5s_linear_infinite] {sizeClasses[size]} {className}"
	role="status"
	aria-label="Loading"
>
	<span class="sr-only">Loading...</span>
</div>