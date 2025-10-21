// src/routes/api/auth/login/+server.ts
import { json } from '@sveltejs/kit'
import { prisma } from '$lib/prisma'
import bcrypt from 'bcryptjs'
import * as jwt from 'jsonwebtoken'

export async function POST({ request }: { request: Request }) {
  try {
    const { email, password } = await request.json()
    
    // Buscar usuario
    const user = await prisma.usuario.findUnique({
      where: { email }
    })
    
    if (!user) {
      return json({ error: 'Credenciales inválidas' }, { status: 401 })
    }
    
    // Verificar contraseña
    const isValid = await bcrypt.compare(password, user.password)
    if (!isValid) {
      return json({ error: 'Credenciales inválidas' }, { status: 401 })
    }
    
    // Generar JWT
    const token = jwt.sign(
      { userId: user.id, email: user.email, rol: user.rol },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '24h' }
    )
    
    return json({ token, user: { id: user.id, email: user.email, nombre: user.nombre, rol: user.rol } })
  } catch (error) {
    console.error('Error logging in:', error)
    return json({ error: 'Error interno del servidor' }, { status: 500 })
  }
}