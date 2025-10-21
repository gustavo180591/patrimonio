# Esquema de Base de Datos

## Modelo de Usuario (`usuario`)

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| id | UUID | Sí | Identificador único del usuario |
| email | String | Sí | Correo electrónico (único) |
| nombre | String | Sí | Nombre del usuario |
| apellido | String | Sí | Apellido del usuario |
| password | String | Sí | Contraseña hasheada |
| rol | String | No (default: 'usuario') | Rol del usuario ('admin' o 'usuario') |
| createdAt | DateTime | Sí | Fecha de creación |
| updatedAt | DateTime | Sí | Fecha de última actualización |

## Modelo de Equipo (`equipos`)

| Campo | Tipo | Requerido | Descripción |
|-------|------|-----------|-------------|
| id | UUID | Sí | Identificador único del equipo |
| numeroInventario | String | Sí | Número de inventario (único) |
| cantidad | Int | Sí | Cantidad de unidades |
| detalle | String | No | Descripción detallada |
| estado | String | No (default: 'Nuevo') | Estado del equipo |
| fechaAlta | DateTime | Sí | Fecha de alta del equipo |
| fechaActualizacion | DateTime | Sí | Fecha de última actualización |
| fechaBaja | DateTime | No | Fecha de baja (opcional) |
| fechaRecepcion | DateTime | No | Fecha de recepción |
| ordenProvision | String | No | Orden de provisión |
| costo | Float | No | Costo en AR$ |
| destino | String | No | Ubicación/destino del equipo |
| expedienteCompra | String | No | Número de expediente de compra |
| codigoQR | String | Sí | Código QR único |
| usuarioId | UUID | Sí | ID del usuario que registró el equipo |
| createdAt | DateTime | Sí | Fecha de creación |
| updatedAt | DateTime | Sí | Fecha de última actualización |

## Relaciones

- Un `Usuario` puede tener muchos `Equipos` (relación 1:N)
- Cada `Equipo` pertenece a un `Usuario`