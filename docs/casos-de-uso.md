# Casos de Uso

## 1. Autenticación de Usuario
**Actor**: Usuario/Administrador  
**Descripción**: Permite al usuario autenticarse en el sistema.  
**Flujo Principal**:
1. El usuario ingresa email y contraseña
2. El sistema valida las credenciales
3. El sistema genera un token JWT
4. El sistema redirige al dashboard

## 2. Registrar Nuevo Equipo
**Actor**: Usuario/Administrador  
**Descripción**: Permite registrar un nuevo equipo en el inventario.  
**Precondiciones**: Usuario autenticado  
**Flujo Principal**:
1. El usuario completa el formulario con los datos del equipo
2. El sistema valida los datos ingresados
3. El sistema genera un código QR único
4. El sistema guarda el equipo en la base de datos
5. El sistema muestra el código QR generado

## 3. Generar Código QR
**Actor**: Usuario/Administrador  
**Descripción**: Genera un código QR para un equipo existente.  
**Precondiciones**: Equipo existente en el sistema  
**Flujo Principal**:
1. El usuario selecciona un equipo
2. El sistema genera/recupera el código QR
3. El sistema muestra el código QR para imprimir

## 4. Consultar Inventario
**Actor**: Usuario/Administrador  
**Descripción**: Permite consultar el inventario de equipos.  
**Flujo Principal**:
1. El usuario accede a la sección de inventario
2. El sistema muestra la lista de equipos
3. El usuario puede filtrar y ordenar los resultados

## 5. Actualizar Datos de Equipo
**Actor**: Usuario/Administrador  
**Descripción**: Permite actualizar los datos de un equipo existente.  
**Precondiciones**: Equipo existente en el sistema  
**Flujo Principal**:
1. El usuario selecciona un equipo
2. El sistema muestra el formulario con los datos actuales
3. El usuario realiza las modificaciones necesarias
4. El sistema valida y guarda los cambios

## 6. Dar de Baja Equipo
**Actor**: Administrador  
**Descripción**: Permite dar de baja lógica a un equipo.  
**Precondiciones**: Usuario con rol de administrador  
**Flujo Principal**:
1. El administrador selecciona un equipo
2. El sistema solicita confirmación
3. El sistema actualiza el estado del equipo a "Dado de baja"
4. El sistema registra la fecha de baja