-- CreateTable
CREATE TABLE "usuarios" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "nombre" TEXT NOT NULL,
    "apellido" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "rol" TEXT NOT NULL DEFAULT 'usuario',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "usuarios_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "equipos" (
    "id" TEXT NOT NULL,
    "numeroInventario" TEXT NOT NULL,
    "cantidad" INTEGER NOT NULL,
    "detalle" TEXT,
    "estado" TEXT NOT NULL DEFAULT 'Nuevo',
    "fechaAlta" TIMESTAMP(3) NOT NULL,
    "fechaActualizacion" TIMESTAMP(3) NOT NULL,
    "fechaBaja" TIMESTAMP(3),
    "fechaRecepcion" TIMESTAMP(3),
    "ordenProvision" TEXT,
    "costo" DOUBLE PRECISION,
    "destino" TEXT,
    "expedienteCompra" TEXT,
    "codigoQR" TEXT NOT NULL,
    "usuarioId" TEXT NOT NULL,

    CONSTRAINT "equipos_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "usuarios_email_key" ON "usuarios"("email");

-- CreateIndex
CREATE UNIQUE INDEX "equipos_numeroInventario_key" ON "equipos"("numeroInventario");

-- AddForeignKey
ALTER TABLE "equipos" ADD CONSTRAINT "equipos_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;
