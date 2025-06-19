## [1.0.1] - 2025-06-19  🔖 Fixed language issue

- Se resolvieron errores en la carga y visualización de textos traducidos en la aplicación.
- Ajustes en el archivo de localización para mejorar la coherencia y precisión de las traducciones en español.
- Correcciones menores en claves mal referenciadas o faltantes en la configuración de **EasyLocalization**.

## [1.0.0] - 2025-06-15  - Release estable inicial

Esta versión marca la primera entrega funcional de **HelpWave**, una aplicación móvil diseñada para facilitar la asistencia remota mediante videollamadas entre usuarios solicitantes y voluntarios capacitados.

### 🧩 Funcionalidades principales

- Autenticación de usuarios con gestión de sesión persistente
- Registro de solicitudes de ayuda categorizadas por tipo de asistencia
- Sistema de emparejamiento (matching) con voluntarios disponibles, considerando habilidades y disponibilidad
- Videollamadas en tiempo real integradas con **Agora**
- Sistema de reporte y calificación posterior a la asistencia
- Cálculo dinámico del nivel del voluntario en función del desempeño (evaluaciones positivas)
- Soporte para notificaciones push mediante **Firebase Cloud Messaging**
- Gestión de perfil e idiomas preferidos por el usuario
- Interfaz multilenguaje gracias a **Easy Localization**

### ⚙️ Detalles técnicos

- Arquitectura basada en **Riverpod**, con estructura modular orientada por feature
- Automatización de CI/CD mediante **GitHub Actions** y despliegue en testers vía **Firebase App Distribution**
- Sistema de versionado semántico con actualización automática de `pubspec.yaml` y `CHANGELOG.md`
- Flujo de ramas estructurado bajo la metodología **GitFlow**

---

Esta versión establece los cimientos técnicos y funcionales del producto para su validación inicial en un entorno de pruebas controlado por usuarios reales.