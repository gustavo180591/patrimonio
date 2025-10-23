<script lang="ts">
  import { enhance } from '$app/forms';
  import { goto } from '$app/navigation';
  import { page } from '$app/stores';

  // Form data
  let formData = {
    numeroInventario: '',
    cantidad: 1,
    detalle: '',
    costo: '',
    destino: '',
    expedienteCompra: '',
    fechaRecepcion: new Date().toISOString().split('T')[0],
    ordenProvision: ''
  };

  let error: string | null = null;
  let submitting = false;

  // Handle form submission
  async function handleSubmit({ 
    formElement, 
    formData, 
    action, 
    cancel 
  }: { 
    formElement: HTMLFormElement; 
    formData: FormData; 
    action: URL; 
    cancel: () => void; 
    controller: AbortController; 
    submitter: HTMLElement | null; 
  }) {
    submitting = true;
    error = null;
    
    try {
      const formDataObj = Object.fromEntries([...formData.entries()]);
      
      // Convert values to appropriate types
      const payload = {
        numeroInventario: String(formDataObj.numeroInventario || ''),
        cantidad: formDataObj.cantidad ? parseInt(String(formDataObj.cantidad), 10) : 0,
        detalle: String(formDataObj.detalle || ''),
        costo: formDataObj.costo ? parseFloat(String(formDataObj.costo)) : null,
        destino: String(formDataObj.destino || ''),
        expedienteCompra: String(formDataObj.expedienteCompra || ''),
        fechaRecepcion: formDataObj.fechaRecepcion || null,
        ordenProvision: String(formDataObj.ordenProvision || '')
      };

      const response = await fetch(action, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(payload)
      });
      
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || 'Error al guardar el equipo');
      }
      
      // Redirect to equipment list on success
      goto('/api/equipos');
    } catch (err) {
      error = err instanceof Error ? err.message : 'Error al procesar la solicitud';
      console.error('Error:', err);
    } finally {
      submitting = false;
    }
  }
</script>

<div class="max-w-4xl mx-auto p-6 bg-white rounded-lg shadow-md">
  <h1 class="text-2xl font-bold mb-6">Nuevo Equipo</h1>
  
  {#if error}
    <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
      {error}
    </div>
  {/if}
  
  <form method="POST" use:enhance={handleSubmit} class="space-y-6">
    <!-- Form fields remain the same -->
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div>
        <label for="numeroInventario" class="block text-sm font-medium text-gray-700 mb-1">Número de Inventario</label>
        <input
          type="text"
          id="numeroInventario"
          name="numeroInventario"
          bind:value={formData.numeroInventario}
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
          required
        />
      </div>
      
      <div>
        <label for="cantidad" class="block text-sm font-medium text-gray-700 mb-1">Cantidad</label>
        <input
          type="number"
          id="cantidad"
          name="cantidad"
          bind:value={formData.cantidad}
          min="1"
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
          required
        />
      </div>
      
      <div class="md:col-span-2">
        <label for="detalle" class="block text-sm font-medium text-gray-700 mb-1">Detalle</label>
        <input
          type="text"
          id="detalle"
          name="detalle"
          bind:value={formData.detalle}
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
          required
        />
      </div>
      
      <div>
        <label for="costo" class="block text-sm font-medium text-gray-700 mb-1">Costo (opcional)</label>
        <input
          type="number"
          id="costo"
          name="costo"
          step="0.01"
          bind:value={formData.costo}
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
        />
      </div>
      
      <div>
        <label for="destino" class="block text-sm font-medium text-gray-700 mb-1">Destino</label>
        <input
          type="text"
          id="destino"
          name="destino"
          bind:value={formData.destino}
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
        />
      </div>
      
      <div>
        <label for="expedienteCompra" class="block text-sm font-medium text-gray-700 mb-1">Expediente de Compra</label>
        <input
          type="text"
          id="expedienteCompra"
          name="expedienteCompra"
          bind:value={formData.expedienteCompra}
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
        />
      </div>
      
      <div>
        <label for="fechaRecepcion" class="block text-sm font-medium text-gray-700 mb-1">Fecha de Recepción</label>
        <input
          type="date"
          id="fechaRecepcion"
          name="fechaRecepcion"
          bind:value={formData.fechaRecepcion}
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
        />
      </div>
      
      <div>
        <label for="ordenProvision" class="block text-sm font-medium text-gray-700 mb-1">Orden de Provisión (opcional)</label>
        <input
          type="text"
          id="ordenProvision"
          name="ordenProvision"
          bind:value={formData.ordenProvision}
          class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
        />
      </div>
    </div>
    
    <div class="flex justify-end space-x-4 pt-4">
      <a
        href="/api/equipos"
        class="px-4 py-2 border border-gray-300 rounded-md shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
      >
        Cancelar
      </a>
      <button
        type="submit"
        class="px-4 py-2 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 disabled:opacity-50"
        disabled={submitting}
      >
        {submitting ? 'Guardando...' : 'Guardar Equipo'}
      </button>
    </div>
  </form>
</div>