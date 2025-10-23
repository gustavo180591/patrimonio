<!-- src/routes/api/auth/login/+page.svelte -->
<script lang="ts">
	import { enhance } from '$app/forms';
	import { goto } from '$app/navigation';

	// Type definitions
	interface LoginFormData {
		email: string;
		password: string;
	}

	interface LoginFormErrors {
		email?: string;
		password?: string;
		general?: string;
	}

	let formData: LoginFormData = $state({
		email: '',
		password: ''
	});

	let errors: LoginFormErrors = $state({});
	let isLoading = $state(false);

	function validateForm() {
		errors = {};

		if (!formData.email) {
			errors.email = 'El email es requerido';
		} else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
			errors.email = 'Email inválido';
		}

		if (!formData.password) {
			errors.password = 'La contraseña es requerida';
		}

		return Object.keys(errors).length === 0;
	}

	async function handleSubmit() {
		if (!validateForm()) return;

		isLoading = true;

		return async ({ result }: { result: { type: string; data?: { error?: string } } }) => {
			isLoading = false;

			if (result.type === 'success') {
				// Redirect to dashboard or home
				await goto('/');
			} else if (result.type === 'failure' && result.data?.error) {
				errors.general = result.data.error;
			}
		};
	}
</script>

<svelte:head>
	<title>Iniciar Sesión - Sistema de Patrimonio</title>
	<meta name="description" content="Inicia sesión en el sistema de gestión de patrimonio">
</svelte:head>

<div class="min-h-screen bg-linear-to-br from-blue-50 to-indigo-100 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
	<div class="max-w-md w-full space-y-8">
		<div class="text-center">
			<div class="mx-auto h-16 w-16 bg-blue-600 rounded-full flex items-center justify-center mb-4">
				<svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
				</svg>
			</div>
			<h2 class="text-3xl font-bold text-gray-900">Iniciar Sesión</h2>
			<p class="mt-2 text-sm text-gray-600">
				¿No tienes cuenta?
				<a href="/api/auth/register" class="font-medium text-blue-600 hover:text-blue-500">
					Regístrate aquí
				</a>
			</p>
		</div>

		<form method="POST" use:enhance={handleSubmit} class="mt-8 space-y-6 bg-white p-8 rounded-xl shadow-lg">
			{#if errors.general}
				<div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg">
					{errors.general}
				</div>
			{/if}

			<div>
				<label for="email" class="block text-sm font-medium text-gray-700">Email</label>
				<input
					id="email"
					name="email"
					type="email"
					bind:value={formData.email}
					class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 {errors.email ? 'border-red-300' : ''}"
					placeholder="tu@email.com"
				/>
				{#if errors.email}
					<p class="mt-1 text-sm text-red-600">{errors.email}</p>
				{/if}
			</div>

			<div>
				<label for="password" class="block text-sm font-medium text-gray-700">Contraseña</label>
				<input
					id="password"
					name="password"
					type="password"
					bind:value={formData.password}
					class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500 {errors.password ? 'border-red-300' : ''}"
					placeholder="••••••••"
				/>
				{#if errors.password}
					<p class="mt-1 text-sm text-red-600">{errors.password}</p>
				{/if}
			</div>

			<div>
				<button
					type="submit"
					disabled={isLoading}
					class="group relative w-full flex justify-center py-3 px-4 border border-transparent text-sm font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
				>
					{#if isLoading}
						<svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
							<circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
							<path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
						</svg>
						Iniciando sesión...
					{:else}
						Iniciar Sesión
					{/if}
				</button>
			</div>

			<div class="text-center">
				<a href="/" class="text-sm text-gray-600 hover:text-gray-900">
					← Volver al inicio
				</a>
			</div>
		</form>
	</div>
</div>
