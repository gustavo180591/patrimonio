<script lang="ts">
	import '../app.css';
	import { browser } from '$app/environment';

	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href="/favicon.svg" />
</svelte:head>

{#if browser}
	{@render children?.()}
{/if}
