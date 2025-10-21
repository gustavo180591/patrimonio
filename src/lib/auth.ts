// src/lib/auth.ts
import * as jwt from 'jsonwebtoken'
import { prisma } from '$lib/prisma'

interface JWTPayload {
  userId: string
  email: string
  rol: string
}

export async function getUserFromToken(token: string) {
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key') as JWTPayload
    const user = await prisma.usuario.findUnique({
      where: { id: decoded.userId }
    })
    return user
  } catch {
    return null
  }
}