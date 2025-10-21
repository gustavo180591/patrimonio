// src/routes/api/equipos/+server.ts
import { json } from '@sveltejs/kit'
import { prisma } from '$lib/prisma'

export async function POST({ request, locals }: { request: Request; locals: App.Locals }) {
  try {
    const { numeroInventario, cantidad, detalle, costo, destino, expedienteCompra, fechaRecepcion, ordenProvision } = await request.json()
    
    // Obtener usuario del token (asumiendo middleware de auth)
    const userId = locals.user?.id
    if (!userId) {
      return json({ error: 'Usuario no autenticado' }, { status: 401 })
    }
    
    // Crear equipo
    const equipo = await prisma.equipos.create({
      data: {
        numeroInventario,
        cantidad: parseInt(cantidad),
        detalle,
        costo: costo ? parseFloat(costo) : null,
        destino,
        expedienteCompra,
        fechaRecepcion: fechaRecepcion ? new Date(fechaRecepcion) : null,
        ordenProvision,
        codigoQR: `QR-${numeroInventario}-${Date.now()}`, // Generar código QR único
        usuarioId: userId,
        fechaAlta: new Date()
      }
    })
    
    return json({ equipo })
  } catch (error) {
    console.error('Error creating equipo:', error)
    return json({ error: 'Error interno del servidor' }, { status: 500 })
  }
}

export async function GET({ url }: { url: URL }) {
  try {
    const search = url.searchParams.get('search') || ''
    const page = parseInt(url.searchParams.get('page') || '1')
    const limit = parseInt(url.searchParams.get('limit') || '10')
    const skip = (page - 1) * limit
    
    const equipos = await prisma.equipos.findMany({
      where: {
        OR: [
          { numeroInventario: { contains: search } },
          { detalle: { contains: search } },
          { destino: { contains: search } }
        ]
      },
      include: {
        usuario: {
          select: { nombre: true, apellido: true }
        }
      },
      orderBy: { fechaAlta: 'desc' },
      skip,
      take: limit
    })
    
    const total = await prisma.equipos.count({
      where: {
        OR: [
          { numeroInventario: { contains: search } },
          { detalle: { contains: search } },
          { destino: { contains: search } }
        ]
      }
    })
    
    return json({ equipos, total, page, totalPages: Math.ceil(total / limit) })
  } catch (error) {
    console.error('Error fetching equipos:', error)
    return json({ error: 'Error interno del servidor' }, { status: 500 })
  }
}