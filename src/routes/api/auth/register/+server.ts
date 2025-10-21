// src/routes/api/auth/register/+server.ts
import { json } from '@sveltejs/kit'
import { prisma } from '$lib/prisma'
import bcrypt from 'bcryptjs'
import { fail } from '@sveltejs/kit'

export async function POST({ request }: { request: Request }) {
  try {
    const { email, nombre, apellido, password, rol } = await request.json()
    
    if (!email || !password || !nombre || !apellido) {
      return json({ error: 'Todos los campos son requeridos' }, { status: 400 })
    }
    
    // Verificar si el usuario ya existe
    const existingUser = await prisma.usuario.findUnique({
      where: { email }
    })
    
    if (existingUser) {
      return json({ error: 'El usuario ya existe' }, { status: 400 })
    }
    
    // Hashear contraseña
    const hashedPassword = await bcrypt.hash(password, 12)
    
    // Crear usuario
    const user = await prisma.usuario.create({
      data: {
        email,
        nombre,
        apellido,
        password: hashedPassword,
        rol: rol || 'usuario'
      }
    })
    
    return json({ user: { id: user.id, email: user.email, nombre: user.nombre } })
  } catch (error) {
    console.error('Error creating user:', error)
    return fail(500, { error: 'Error interno del servidor' })
  }
}