<script lang="ts">
  import { page } from '$app/stores';
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