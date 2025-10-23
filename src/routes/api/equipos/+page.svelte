<script lang="ts">
  import { onMount } from 'svelte';
  import { page } from '$app/stores';
  import { goto } from '$app/navigation';
  import { enhance } from '$app/forms';
  
  // State
  let equipos = [];
  let loading = true;
  let error = null;
  let search = '';
  let currentPage = 1;
  const itemsPerPage = 10;
  let totalItems = 0;
  let sortField = 'fechaAlta';
  let sortDirection = 'desc';
  
  // Fetch equipos with pagination and search
  async function fetchEquipos() {
    try {
      loading = true;
      const params = new URLSearchParams({
        search,
        page: currentPage.toString(),
        limit: itemsPerPage.toString(),
        sort: sortField,
        order: sortDirection
      });
      
      const response = await fetch(`/api/equipos?${params}`);
      if (!response.ok) throw new Error('Error al cargar los equipos');
      
      const data = await response.json();
      equipos = data.equipos;
      totalItems = data.total;
      error = null;
    } catch (err) {
      console.error('Error:', err);
      error = 'Error al cargar los equipos. Por favor, intente nuevamente.';
    } finally {
      loading = false;
    }
  }
  
  // Handle search with debounce
  let searchTimeout;
  function handleSearch() {
    clearTimeout(searchTimeout);
    currentPage = 1;
    searchTimeout = setTimeout(fetchEquipos, 300);
  }
  
  // Handle sort
  function handleSort(field) {
    if (sortField === field) {
      sortDirection = sortDirection === 'asc' ? 'desc' : 'asc';
    } else {
      sortField = field;
      sortDirection = 'asc';
    }
    fetchEquipos();
  }
  
  // Format date
  function formatDate(dateString) {
    if (!dateString) return 'N/A';
    return new Date(dateString).toLocaleDateString('es-AR');
  }
  
  // Format currency
  function formatCurrency(amount) {
    if (amount === null || amount === undefined) return 'N/A';
    return new Intl.NumberFormat('es-AR', {
      style: 'currency',
      currency: 'ARS'
    }).format(amount);
  }
  
  // Initial fetch
  onMount(fetchEquipos);
  
  // Watch for URL changes
  $: if ($page.url.searchParams.get('page') !== String(currentPage)) {
    currentPage = parseInt($page.url.searchParams.get('page') || '1');
    fetchEquipos();
  }
  
  // Update URL when page changes
  $: if ($page.url.searchParams.get('page') !== String(currentPage)) {
    const params = new URLSearchParams($page.url.searchParams);
    params.set('page', currentPage);
    goto(`?${params.toString()}`, { replaceState: true, keepFocus: true });
  }
</script>

<div class="container mx-auto px-4 py-8">
  <div class="flex justify-between items-center mb-6">
    <h1 class="text-2xl font-bold text-gray-800">Gestión de Equipos</h1>
    <a href="/api/equipos/nuevo" class="bg-blue-600 text-white px-4 py-2 rounded-lg hover:bg-blue-700 transition-colors">
      + Nuevo Equipo
    </a>
  </div>
  
  <!-- Search and Filters -->
  <div class="bg-white rounded-lg shadow p-4 mb-6">
    <div class="flex flex-col md:flex-row gap-4">
      <div class="flex-1">
        <label for="search" class="block text-sm font-medium text-gray-700 mb-1">Buscar</label>
        <input 
          type="text" 
          id="search" 
          bind:value={search} 
          on:input={handleSearch}
          placeholder="Buscar por inventario, detalle o destino..."
          class="w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
      </div>
    </div>
  </div>
  
  <!-- Error Message -->
  {#if error}
    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 mb-6" role="alert">
      <p class="font-bold">Error</p>
      <p>{error}</p>
    </div>
  {/if}
  
  <!-- Loading State -->
  {#if loading && equipos.length === 0}
    <div class="flex justify-center items-center h-64">
      <div class="animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-blue-500"></div>
    </div>
  {:else}
    <!-- Equipment Table -->
    <div class="bg-white shadow overflow-hidden rounded-lg">
      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th 
                scope="col" 
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                on:click={() => handleSort('numeroInventario')}
              >
                <div class="flex items-center">
                  Inventario
                  {#if sortField === 'numeroInventario'}
                    <span class="ml-1">{sortDirection === 'asc' ? '↑' : '↓'}</span>
                  {/if}
                </div>
              </th>
              <th 
                scope="col" 
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Detalle
              </th>
              <th 
                scope="col" 
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Cantidad
              </th>
              <th 
                scope="col" 
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Costo
              </th>
              <th 
                scope="col" 
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Destino
              </th>
              <th 
                scope="col" 
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
              >
                Expediente
              </th>
              <th 
                scope="col" 
                class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider"
                on:click={() => handleSort('fechaRecepcion')}
              >
                <div class="flex items-center">
                  Fecha Recepción
                  {#if sortField === 'fechaRecepcion'}
                    <span class="ml-1">{sortDirection === 'asc' ? '↑' : '↓'}</span>
                  {/if}
                </div>
              </th>
              <th scope="col" class="relative px-6 py-3">
                <span class="sr-only">Acciones</span>
              </th>
            </tr>
          </thead>
          <tbody class="bg-white divide-y divide-gray-200">
            {#each equipos as equipo}
              <tr class="hover:bg-gray-50">
                <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900">
                  {equipo.numeroInventario}
                </td>
                <td class="px-6 py-4 text-sm text-gray-500">
                  <div class="line-clamp-2">{equipo.detalle}</div>
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {equipo.cantidad}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {formatCurrency(equipo.costo)}
                </td>
                <td class="px-6 py-4 text-sm text-gray-500">
                  {equipo.destino || 'N/A'}
                </td>
                <td class="px-6 py-4 text-sm text-gray-500">
                  {equipo.expedienteCompra || 'N/A'}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                  {formatDate(equipo.fechaRecepcion)}
                </td>
                <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                  <a href={`/api/equipos/${equipo.id}`} class="text-blue-600 hover:text-blue-900 mr-4">Ver</a>
                  <a href={`/api/equipos/editar/${equipo.id}`} class="text-indigo-600 hover:text-indigo-900">Editar</a>
                </td>
              </tr>
            {:else}
              <tr>
                <td colspan="7" class="px-6 py-4 text-center text-sm text-gray-500">
                  No se encontraron equipos
                </td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
      
      <!-- Pagination -->
      {#if totalItems > itemsPerPage}
        <div class="bg-white px-4 py-3 flex items-center justify-between border-t border-gray-200 sm:px-6">
          <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
            <div>
              <p class="text-sm text-gray-700">
                Mostrando <span class="font-medium">{(currentPage - 1) * itemsPerPage + 1}</span> a 
                <span class="font-medium">
                  {Math.min(currentPage * itemsPerPage, totalItems)}
                </span> de <span class="font-medium">{totalItems}</span> resultados
              </p>
            </div>
            <div>
              <nav class="relative z-0 inline-flex rounded-md shadow-sm -space-x-px" aria-label="Pagination">
                <button
                  on:click={() => currentPage > 1 && currentPage--}
                  disabled={currentPage === 1}
                  class="relative inline-flex items-center px-2 py-2 rounded-l-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span class="sr-only">Anterior</span>
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
                  </svg>
                </button>
                
                {#each Array(Math.ceil(totalItems / itemsPerPage)) as _, i}
                  {#if i + 1 === currentPage}
                    <span class="relative inline-flex items-center px-4 py-2 border border-blue-500 bg-blue-50 text-blue-600 text-sm font-medium">
                      {i + 1}
                    </span>
                  {:else}
                    <button
                      on:click={() => currentPage = i + 1}
                      class="relative inline-flex items-center px-4 py-2 border border-gray-300 bg-white text-sm font-medium text-gray-700 hover:bg-gray-50"
                    >
                      {i + 1}
                    </button>
                  {/if}
                {/each}
                
                <button
                  on:click={() => currentPage < Math.ceil(totalItems / itemsPerPage) && currentPage++}
                  disabled={currentPage >= Math.ceil(totalItems / itemsPerPage)}
                  class="relative inline-flex items-center px-2 py-2 rounded-r-md border border-gray-300 bg-white text-sm font-medium text-gray-500 hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span class="sr-only">Siguiente</span>
                  <svg class="h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
                  </svg>
                </button>
              </nav>
            </div>
          </div>
        </div>
      {/if}
    </div>
  {/if}
</div>

<style>
  .line-clamp-2 {
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;  
    overflow: hidden;
  }
  
  @media (max-width: 768px) {
    .overflow-x-auto {
      -webkit-overflow-scrolling: touch;
    }
    
    table {
      display: block;
      width: 100%;
      overflow-x: auto;
    }
    
    th, td {
      min-width: 120px;
    }
  }
</style>