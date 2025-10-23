// src/routes/api/auth/login/+server.ts
import { json, fail } from '@sveltejs/kit';
import { prisma } from '$lib/prisma';
import bcrypt from 'bcryptjs';
import * as jwt from 'jsonwebtoken';

export async function POST({ request }: { request: Request }) {
  try {
    const { email, password } = await request.json();

    if (!email || !password) {
      return fail(400, { error: 'Email y contraseña son requeridos' });
    }

    // Buscar usuario
    const user = await prisma.usuario.findUnique({
      where: { email }
    });

    if (!user) {
      return fail(401, { error: 'Credenciales inválidas' });
    }

    // Verificar contraseña
    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      return fail(401, { error: 'Credenciales inválidas' });
    }

    // Generar JWT
    const token = jwt.sign(
      { userId: user.id, email: user.email, rol: user.rol },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '24h' }
    );

    return json({ token, user: { id: user.id, email: user.email, nombre: user.nombre, rol: user.rol } });

  } catch (error) {
    console.error('Error logging in:', error);
    return fail(500, { error: 'Error interno del servidor' });
  }
}