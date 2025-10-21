-- CreateTable
CREATE TABLE "usuarios" (
    "id" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "nombre" VARCHAR(100) NOT NULL,
    "apellido" VARCHAR(100) NOT NULL,
    "password" VARCHAR(255) NOT NULL,
    "rol" VARCHAR(50) NOT NULL DEFAULT 'usuario',
    "createdAt" TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(6) NOT NULL,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "equipos" (
    "id" TEXT NOT NULL,
    "numeroInventario" VARCHAR(100) NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "detalle" TEXT,
    "estado" VARCHAR(50) NOT NULL DEFAULT 'Nuevo',
    "fechaAlta" TIMESTAMP(6) NOT NULL,
    "fechaActualizacion" TIMESTAMP(6) NOT NULL,
    "fechaBaja" TIMESTAMP(6),
    "fechaRecepcion" TIMESTAMP(6),
    "ordenProvision" VARCHAR(100),
    "costo" REAL,
    "destino" VARCHAR(255),
    "expedienteCompra" VARCHAR(100),
    "codigoQR" VARCHAR(255) NOT NULL,
    "usuarioId" TEXT NOT NULL,

    CONSTRAINT "equipos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE UNIQUE INDEX "equipos_numeroInventario_key" ON "equipos"("numeroInventario");

-- AddForeignKey
ALTER TABLE "equipos" ADD CONSTRAINT "equipos_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;
