// src/routes/api/auth/register/+server.ts
import { json, fail, redirect } from '@sveltejs/kit';
import { prisma } from '$lib/prisma';
import bcrypt from 'bcryptjs';

// Handle GET request - redirect to the registration page
export function GET() {
  throw redirect(303, '/register');
}

export async function POST({ request }: { request: Request }) {
  try {
    const data = await request.json();
    const { email, nombre, password } = data;
    
    // Validate required fields
    if (!email || !password || !nombre) {
      return json(
        { error: 'Email, nombre y contraseña son requeridos' },
        { status: 400 }
      );
    }

    // Check for existing user
    const existingUser = await prisma.usuario.findUnique({
      where: { email }
    });

    if (existingUser) {
      return json(
        { error: 'El correo electrónico ya está registrado' },
        { status: 400 }
      );
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create user
    const user = await prisma.usuario.create({
      data: {
        email,
        nombre,
        password: hashedPassword,
        rol: 'usuario' // Default role
      },
      select: {
        id: true,
        email: true,
        nombre: true,
        rol: true
      }
    });

    return json({ user }, { status: 201 });

  } catch (error) {
    console.error('Registration error:', error);
    return json(
      { error: 'Error al procesar el registro' },
      { status: 500 }
    );
  }
}