# Rails API

API construida con **Ruby on Rails 7.1.5.2** y **Ruby 3.3.0**.  
El proyecto está pensado para uso local y cuenta con manejo de procesos asíncronos, cron jobs, mailing configurable y conexión a múltiples bases de datos.

---

## 🚀 Tecnologías y Gems principales

- **Ruby on Rails 7.1.5.2**
- **Ruby 3.3.0**
- **Base de datos**: configuración para **dos conexiones**
  - **Lectura/Escritura** → Base de datos principal
  - **Solo lectura** → Base externa con información dummy de facturas
- **Gems destacadas**:
  - [`daemons`](https://github.com/thuehlinger/daemons) → ejecución de procesos en background
  - [`delayed_cron_job`](https://github.com/codez/delayed_cron_job) + [`delayed_job_active_record`](https://github.com/collectiveidea/delayed_job_active_record) → jobs asíncronos y cron jobs
  - [`draper`](https://github.com/drapergem/draper) → decoración de información
  - [`ransack`](https://github.com/activerecord-hackery/ransack) → filtrado flexible en consultas
  - [`letter_opener`](https://github.com/ryanb/letter_opener) → visualización de mails en desarrollo (si no se configura SMTP)

---

## ⚙️ Configuración inicial

1. Clonar el repositorio:

   ```bash
   git clone <URL_DEL_REPO>
   cd <NOMBRE_DEL_PROYECTO>
   ```

2. Instalar dependencias:

   ```bash
   bundle install
   ```

3. Configuración de variables de entorno:

   - Copiar el archivo de ejemplo:
     ```bash
     cp .env.example .env
     ```
   - Editar `.env` con tus valores (bases de datos, SMTP, etc.).

4. Configuración de bases de datos:

   ```bash
   rails db:create
   rails db:migrate
   ```

5. Ejecutar **seeds** (solo la primera vez):

   ```bash
   rails db:seed
   ```

   > ⚠️ Esto es importante ya que aquí se instancia el **cron job diario para el mailing de reportes**.

6. Activar el cache en desarrollo:

  ```bash
  rails dev:cache

---

## ▶️ Ejecución del proyecto

Iniciar el servidor Rails:

```bash
rails server
```

Por defecto estará disponible en:  
👉 [http://localhost:3000](http://localhost:3000)

---

## 📬 Mailing

- **SMTP**: configurable vía variables de entorno.
- **Modo desarrollo (por defecto)**: si no se configuran credenciales de SMTP, los correos se visualizarán en el navegador usando **letter_opener**.

---

## ⏱️ Jobs y procesos asíncronos

El proyecto utiliza **Delayed Job** para manejar colas de trabajos y cron jobs.  

En entorno **local**, los workers se administran con Rake:

- Ejecutar workers:

  ```bash
  rake jobs:work
  ```

- Limpiar la cola de jobs:

  ```bash
  rake jobs:clear
  ```

---

## 🧪 Tests

Para correr los tests:

```bash
rails test
```

---

## 📂 Estructura especial

- **Dos conexiones de base de datos** (lectura/escritura y solo lectura).
- **Decorators** con Draper para enriquecer la información expuesta en la API.
- **Filtros dinámicos** con Ransack para endpoints de búsqueda.
- **Cron job diario** instanciado en seeds para el mailing de reportes.
- **Jobs locales** administrados con `rake jobs:work` y `rake jobs:clear`.

---

## ✅ Requisitos previos

- Ruby 3.3.0
- Rails 7.1.5.2
- PostgreSQL o la base de datos configurada en `.env`
- Node.js & Yarn (para dependencias de Rails, si aplica)

---

## 📌 Notas

- Este proyecto está pensado para **uso local**.  
- La conexión a la base externa de solo lectura es obligatoria para acceder a la información dummy de facturas.  
- Configura siempre tu archivo `.env` antes de iniciar el proyecto.  
- Ejecutar `rails db:seed` la primera vez es fundamental para que funcione el cron de mailing.  
- En local, recuerda levantar los workers con `rake jobs:work`.  

---
