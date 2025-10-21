<!-- src/routes/equipos/+page.svelte -->
<script lang="ts">
  import { enhance } from '$app/forms'
  
  let formData = {
    numeroInventario: '',
    cantidad: 1,
    detalle: '',
    costo: '',
    destino: '',
    expedienteCompra: '',
    fechaRecepcion: '',
    ordenProvision: ''
  }
</script>

<h1>Registrar Nuevo Equipo</h1>

<form method="POST" action="/api/equipos" use:enhance>
  <div>
    <label for="numeroInventario">Número de Inventario:</label>
    <input id="numeroInventario" name="numeroInventario" bind:value={formData.numeroInventario} required>
  </div>
  
  <div>
    <label for="cantidad">Cantidad:</label>
    <input id="cantidad" name="cantidad" type="number" bind:value={formData.cantidad} min="1" required>
  </div>
  
  <div>
    <label for="detalle">Detalle:</label>
    <textarea id="detalle" name="detalle" bind:value={formData.detalle}></textarea>
  </div>
  
  <div>
    <label for="costo">Costo:</label>
    <input id="costo" name="costo" type="number" step="0.01" bind:value={formData.costo}>
  </div>
  
  <div>
    <label for="destino">Destino:</label>
    <input id="destino" name="destino" bind:value={formData.destino}>
  </div>
  
  <div>
    <label for="expedienteCompra">Expediente de Compra:</label>
    <input id="expedienteCompra" name="expedienteCompra" bind:value={formData.expedienteCompra}>
  </div>
  
  <button type="submit">Registrar Equipo</button>
</form>