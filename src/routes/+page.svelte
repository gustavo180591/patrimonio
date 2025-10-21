<script lang="ts">
	import { onMount } from 'svelte';

	let mounted = $state(false);

	onMount(() => {
		mounted = true;
	});
</script>

<svelte:head>
	<title>Sistema de Gestión de Patrimonio</title>
	<meta name="description" content="Sistema integral para la gestión y control de equipos e inventario" />
</svelte:head>

<div class="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100">
	<!-- Header -->
	<header class="bg-white shadow-sm border-b">
		<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
			<div class="flex justify-between items-center py-4">
				<div class="flex items-center space-x-3">
					<div class="w-10 h-10 bg-blue-600 rounded-lg flex items-center justify-center">
						<svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
							<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path>
						</svg>
					</div>
					<h1 class="text-2xl font-bold text-gray-900">Patrimonio</h1>
				</div>

				<div class="flex items-center space-x-4">
					<a href="/api/auth/login" class="text-gray-600 hover:text-gray-900 transition-colors">
						Iniciar Sesión
					</a>
					<a href="/api/auth/register" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
						Registrarse
					</a>
				</div>
			</div>
		</div>
	</header>

	<!-- Hero Section -->
	<main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
		<div class="text-center mb-16">
			<h2 class="text-4xl sm:text-5xl font-bold text-gray-900 mb-6">
				Sistema de Gestión de
				<span class="text-blue-600">Patrimonio</span>
			</h2>
			<p class="text-xl text-gray-600 mb-8 max-w-3xl mx-auto">
				Controla y administra eficientemente todo tu inventario de equipos con nuestro sistema integral.
				Registro, seguimiento y generación de códigos QR para una gestión moderna y efectiva.
			</p>

			<div class="flex flex-col sm:flex-row gap-4 justify-center items-center">
				<a href="/api/equipos" class="bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors font-semibold shadow-lg">
					Ver Equipos
				</a>
				<a href="/api/auth/register" class="border-2 border-blue-600 text-blue-600 px-8 py-3 rounded-lg hover:bg-blue-50 transition-colors font-semibold">
					Comenzar Ahora
				</a>
			</div>
		</div>

		<!-- Features Grid -->
		<div class="grid md:grid-cols-3 gap-8 mb-16">
			<!-- Feature 1: Equipment Management -->
			<div class="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
				<div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mb-6">
					<svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
					</svg>
				</div>
				<h3 class="text-xl font-semibold text-gray-900 mb-4">Gestión de Equipos</h3>
				<p class="text-gray-600">
					Registra y administra todo tu inventario de equipos con información detallada como números de inventario,
					detalles técnicos, costos y destinos.
				</p>
			</div>

			<!-- Feature 2: QR Codes -->
			<div class="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
				<div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mb-6">
					<svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M12 12v4.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
					</svg>
				</div>
				<h3 class="text-xl font-semibold text-gray-900 mb-4">Códigos QR</h3>
				<p class="text-gray-600">
					Genera códigos QR únicos para cada equipo, facilitando la identificación rápida y el seguimiento
					de activos en tiempo real.
				</p>
			</div>

			<!-- Feature 3: Authentication -->
			<div class="bg-white rounded-xl shadow-lg p-8 hover:shadow-xl transition-shadow">
				<div class="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mb-6">
					<svg class="w-6 h-6 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"></path>
					</svg>
				</div>
				<h3 class="text-xl font-semibold text-gray-900 mb-4">Control de Acceso</h3>
				<p class="text-gray-600">
					Sistema de autenticación seguro con diferentes niveles de acceso para garantizar que cada usuario
					tenga los permisos adecuados.
				</p>
			</div>
		</div>

		<!-- Stats Section -->
		<div class="bg-white rounded-xl shadow-lg p-8">
			<h3 class="text-2xl font-bold text-gray-900 text-center mb-8">Características del Sistema</h3>
			<div class="grid grid-cols-2 md:grid-cols-4 gap-8">
				<div class="text-center">
					<div class="text-3xl font-bold text-blue-600 mb-2">📦</div>
					<div class="text-2xl font-bold text-gray-900">Inventario</div>
					<div class="text-gray-600">Control total</div>
				</div>
				<div class="text-center">
					<div class="text-3xl font-bold text-green-600 mb-2">📊</div>
					<div class="text-2xl font-bold text-gray-900">Reportes</div>
					<div class="text-gray-600">Análisis detallado</div>
				</div>
				<div class="text-center">
					<div class="text-3xl font-bold text-purple-600 mb-2">🔍</div>
					<div class="text-2xl font-bold text-gray-900">Búsqueda</div>
					<div class="text-gray-600">Rápida y eficiente</div>
				</div>
				<div class="text-center">
					<div class="text-3xl font-bold text-orange-600 mb-2">⚡</div>
					<div class="text-2xl font-bold text-gray-900">Rápido</div>
					<div class="text-gray-600">Tecnología moderna</div>
				</div>
			</div>
		</div>
	</main>

	<!-- Footer -->
	<footer class="bg-gray-800 text-white py-8 mt-16">
		<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
			<p class="text-gray-400">
				&copy; 2025 Sistema de Gestión de Patrimonio. Todos los derechos reservados.
			</p>
		</div>
	</footer>
</div>

<style>
	/* Custom animations for enhanced UX */
	@keyframes fadeInUp {
		from {
			opacity: 0;
			transform: translateY(30px);
		}
		to {
			opacity: 1;
			transform: translateY(0);
		}
	}

	.fade-in-up {
		animation: fadeInUp 0.6s ease-out forwards;
	}
</style>