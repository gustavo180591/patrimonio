<script lang="ts">
  import { onMount } from 'svelte';
  
  // Form state
  type FormErrors = {
    email?: string;
    nombre?: string;
    password?: string;
    confirmPassword?: string;
    general?: string;
  };

  let formData = {
    email: '',
    nombre: '',
    password: '',
    confirmPassword: ''
  };

  let errors: FormErrors = {};
  let isSubmitting = false;
  let showPassword = false;
  let showConfirmPassword = false;
  let registered = false;

  // Check for registration success
  onMount(() => {
    const urlParams = new URLSearchParams(window.location.search);
    registered = urlParams.get('registered') === 'true';
  });

  // Form validation
  function validateForm() {
    const newErrors: FormErrors = {};
    
    // Email validation
    if (!formData.email) {
      newErrors.email = 'El email es requerido';
    } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(formData.email)) {
      newErrors.email = 'Por favor ingresa un email válido';
    }

    // Name validation
    if (!formData.nombre?.trim()) {
      newErrors.nombre = 'El nombre es requerido';
    } else if (formData.nombre.trim().length < 2) {
      newErrors.nombre = 'El nombre debe tener al menos 2 caracteres';
    }

    // Password validation
    if (!formData.password) {
      newErrors.password = 'La contraseña es requerida';
    } else if (formData.password.length < 8) {
      newErrors.password = 'La contraseña debe tener al menos 8 caracteres';
    } else if (!/[A-Z]/.test(formData.password)) {
      newErrors.password = 'La contraseña debe contener al menos una letra mayúscula';
    } else if (!/[0-9]/.test(formData.password)) {
      newErrors.password = 'La contraseña debe contener al menos un número';
    }

    // Confirm password
    if (formData.password !== formData.confirmPassword) {
      newErrors.confirmPassword = 'Las contraseñas no coinciden';
    }

    errors = newErrors;
    return Object.keys(errors).length === 0;
  }

  // Handle form submission
  async function handleSubmit(event: Event) {
    event.preventDefault();
    
    if (!validateForm()) return;
    
    isSubmitting = true;
    errors = {}; // Clear previous errors
    
    try {
      const response = await fetch('/api/auth/register', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          email: formData.email.trim(),
          nombre: formData.nombre.trim(),
          password: formData.password
        })
      });
      
      const data = await response.json();
      
      if (!response.ok) {
        throw new Error(data.error || 'Error en el registro');
      }
      
      // Redirect to login on success
      window.location.href = '/login?registered=true';
    } catch (error: unknown) {
      errors = {
        ...errors,
        general: error instanceof Error ? error.message : 'Error al registrar el usuario'
      };
      console.error('Registration error:', error);
    } finally {
      isSubmitting = false;
    }
  }

  function togglePasswordVisibility() {
    showPassword = !showPassword;
  }

  function toggleConfirmPasswordVisibility() {
    showConfirmPassword = !showConfirmPassword;
  }
</script>

<svelte:head>
  <title>Registro de Usuario</title>
</svelte:head>

<div class="min-h-screen bg-gray-50 flex flex-col justify-center py-12 sm:px-6 lg:px-8">
  <div class="sm:mx-auto sm:w-full sm:max-w-md">
    <h2 class="mt-6 text-center text-3xl font-extrabold text-gray-900">
      Crear una cuenta
    </h2>
    <p class="mt-2 text-center text-sm text-gray-600">
      O{' '}
      <a href="/login" class="font-medium text-indigo-600 hover:text-indigo-500">
        inicia sesión si ya tienes una cuenta
      </a>
    </p>
  </div>

  <div class="mt-8 sm:mx-auto sm:w-full sm:max-w-md">
    <div class="bg-white py-8 px-4 shadow sm:rounded-lg sm:px-10">
      {#if registered}
        <div class="mb-4 bg-green-50 border border-green-200 text-green-800 px-4 py-3 rounded">
          <p>¡Registro exitoso! Por favor inicia sesión.</p>
        </div>
      {/if}

      {#if errors.general}
        <div class="mb-4 bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded">
          <p>{errors.general}</p>
        </div>
      {/if}

      <form class="space-y-6" on:submit={handleSubmit}>
        <div>
          <label for="email" class="block text-sm font-medium text-gray-700">
            Correo electrónico
          </label>
          <div class="mt-1 relative">
            <input
              id="email"
              name="email"
              type="email"
              autocomplete="email"
              required
              bind:value={formData.email}
              class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm {errors.email ? 'border-red-300 text-red-900' : ''}"
              placeholder="tucorreo@ejemplo.com"
            />
          </div>
          {#if errors.email}
            <p class="mt-1 text-sm text-red-600">{errors.email}</p>
          {/if}
        </div>

        <div>
          <label for="nombre" class="block text-sm font-medium text-gray-700">
            Nombre completo
          </label>
          <div class="mt-1">
            <input
              id="nombre"
              name="nombre"
              type="text"
              autocomplete="name"
              required
              bind:value={formData.nombre}
              class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm {errors.nombre ? 'border-red-300 text-red-900' : ''}"
              placeholder="Juan Pérez"
            />
          </div>
          {#if errors.nombre}
            <p class="mt-1 text-sm text-red-600">{errors.nombre}</p>
          {/if}
        </div>

        <div>
          <label for="password" class="block text-sm font-medium text-gray-700">
            Contraseña
          </label>
          <div class="mt-1 relative">
            <input
              id="password"
              name="password"
              type={showPassword ? 'text' : 'password'}
              autocomplete="new-password"
              required
              bind:value={formData.password}
              class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm {errors.password ? 'border-red-300 text-red-900' : ''}"
              placeholder="••••••••"
            />
            <button
              type="button"
              on:click={togglePasswordVisibility}
              class="absolute inset-y-0 right-0 pr-3 flex items-center"
              title={showPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'}
            >
              {#if showPassword}
                <svg class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                </svg>
              {:else}
                <svg class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              {/if}
            </button>
          </div>
          {#if errors.password}
            <p class="mt-1 text-sm text-red-600">{errors.password}</p>
          {/if}
          <p class="mt-1 text-xs text-gray-500">
            Mínimo 8 caracteres, incluyendo 1 mayúscula y 1 número
          </p>
        </div>

        <div>
          <label for="confirmPassword" class="block text-sm font-medium text-gray-700">
            Confirmar contraseña
          </label>
          <div class="mt-1 relative">
            <input
              id="confirmPassword"
              name="confirmPassword"
              type={showConfirmPassword ? 'text' : 'password'}
              autocomplete="new-password"
              required
              bind:value={formData.confirmPassword}
              class="appearance-none block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm placeholder-gray-400 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm {errors.confirmPassword ? 'border-red-300 text-red-900' : ''}"
              placeholder="••••••••"
            />
            <button
              type="button"
              on:click={toggleConfirmPasswordVisibility}
              class="absolute inset-y-0 right-0 pr-3 flex items-center"
              title={showConfirmPassword ? 'Ocultar contraseña' : 'Mostrar contraseña'}
            >
              {#if showConfirmPassword}
                <svg class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21" />
                </svg>
              {:else}
                <svg class="h-5 w-5 text-gray-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                </svg>
              {/if}
            </button>
          </div>
          {#if errors.confirmPassword}
            <p class="mt-1 text-sm text-red-600">{errors.confirmPassword}</p>
          {/if}
        </div>

        <div>
          <button
            type="submit"
            disabled={isSubmitting}
            class="w-full flex justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isSubmitting ? 'Registrando...' : 'Registrarse'}
          </button>
        </div>
      </form>
    </div>
  </div>
</div>

<style>
  /* Add any custom styles here if needed */
</style>