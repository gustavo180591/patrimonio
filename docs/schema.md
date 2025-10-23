// This is your Prisma schema file,
// learn more about it in the docs: https://pris.ly/d/prisma-schema

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

// Modelo de Usuario
model Usuario {
  id        String   @id @default(cuid())
  email     String   @unique
  nombre    String
  apellido  String
  password  String
  rol       String   @default("usuario")
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  // Relaciones
  equipos Equipos[]

  @@map("usuarios")
}

// Modelo de Equipos (Activos del Inventario)
model Equipos {
  id                 String    @id @default(cuid())
  numeroInventario   String    @unique
  cantidad           Int
  detalle            String?
  estado             String    @default("Nuevo")
  fechaAlta          DateTime
  fechaActualizacion DateTime  @updatedAt
  fechaBaja          DateTime?
  fechaRecepcion     DateTime?
  ordenProvision     String?
  costo              Float?
  destino            String?
  expedienteCompra   String?
  codigoQR           String
  usuarioId          String

  // Relaciones
  usuario Usuario @relation(fields: [usuarioId], references: [id], onDelete: Cascade)

  @@map("equipos")
}
