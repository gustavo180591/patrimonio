-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enum types if they don't exist
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'estado_equipo') THEN
        CREATE TYPE estado_equipo AS ENUM ('disponible', 'asignado', 'en_mantenimiento', 'dado_de_baja');
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'tipo_equipo') THEN
        CREATE TYPE tipo_equipo AS ENUM ('laptop', 'desktop', 'monitor', 'impresora', 'otro');
    END IF;
END $$;

-- Create tables
CREATE TABLE IF NOT EXISTS equipos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    codigo_patrimonial VARCHAR(50) UNIQUE,
    tipo tipo_equipo NOT NULL,
    marca VARCHAR(100),
    modelo VARCHAR(100),
    numero_serie VARCHAR(100) UNIQUE,
    procesador VARCHAR(100),
    ram_gb INTEGER,
    almacenamiento_gb INTEGER,
    sistema_operativo VARCHAR(100),
    estado estado_equipo DEFAULT 'disponible',
    fecha_compra DATE,
    fecha_vencimiento_garantia DATE,
    proveedor VARCHAR(200),
    factura_numero VARCHAR(100),
    valor_compra DECIMAL(10, 2),
    expediente_compra VARCHAR(100),
    fecha_recepcion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    notas TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_equipos_codigo_patrimonial ON equipos(codigo_patrimonial);
CREATE INDEX IF NOT EXISTS idx_equipos_estado ON equipos(estado);
CREATE INDEX IF NOT EXISTS idx_equipos_tipo ON equipos(tipo);

-- Create function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to update updated_at
CREATE TRIGGER update_equipos_updated_at
BEFORE UPDATE ON equipos
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Create users table for authentication
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    nombre VARCHAR(100),
    apellido VARCHAR(100),
    rol VARCHAR(50) DEFAULT 'usuario',
    activo BOOLEAN DEFAULT true,
    ultimo_acceso TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create refresh tokens table
CREATE TABLE IF NOT EXISTS refresh_tokens (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(255) UNIQUE NOT NULL,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    revoked BOOLEAN DEFAULT false
);

-- Create index for refresh tokens
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_user_id ON refresh_tokens(user_id);
CREATE INDEX IF NOT EXISTS idx_refresh_tokens_token ON refresh_tokens(token);

-- Create default admin user if not exists
-- Password will be hashed on first login
INSERT INTO users (email, password_hash, nombre, apellido, rol, activo)
VALUES ('admin@example.com', '', 'Admin', 'Sistema', 'admin', true)
ON CONFLICT (email) DO NOTHING;
