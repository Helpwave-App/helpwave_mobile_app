# 📱 HelpWave

**Aplicación móvil de microvoluntariado digital basada en videollamadas para brindar asistencia remota, especialmente a personas adultas mayores.**

HelpWave conecta a personas que requieren asistencia rápida con voluntarios disponibles mediante videollamadas, permitiendo resolver tareas cotidianas y técnicas de forma remota, segura y solidaria.

---

## 🚀 Funcionalidades principales

- 🔐 Registro e inicio de sesión con Firebase
- 🆘 Solicitud de ayuda categorizada
- 📲 Notificaciones push a voluntarios
- 📹 Videollamadas integradas (Agora)
- ✅ Evaluación posterior a la llamada
- 🌟 Sistema de niveles por desempeño
- 🌐 Gestión de idiomas y disponibilidad

---

## 🧰 Tecnologías utilizadas

| Módulo        | Tecnología                                 |
|---------------|---------------------------------------------|
| Frontend      | Flutter 3.x, Dart                          |
| Estado        | Riverpod + StateNotifier                   |
| Backend       | Spring Boot, Java, PostgreSQL              |
| Comunicación  | Firebase Auth, Firestore, Cloud Messaging |
| Videollamadas | Agora Video SDK                            |
| CI/CD         | GitHub Actions + Firebase App Distribution |

---

## 🧪 Ejecución local

### 🔧 Requisitos previos

- Flutter instalado ([guía oficial](https://docs.flutter.dev/get-started/install))
- Archivo `google-services.json` en `android/app/`
- Permisos para acceder a Agora y Firebase

### ▶️ Comandos básicos

```bash
git clone https://github.com/tu-usuario/helpwave_mobile_app.git
cd helpwave_mobile_app
flutter pub get
flutter run
```

---

## 🔁 Versionado automático

El proyecto sigue **Semantic Versioning** (`major.minor.patch`). El archivo `pubspec.yaml` y `CHANGELOG.md` se actualizan automáticamente mediante [GitHub Actions](https://github.com/features/actions).

### 🎛️ Lanzamiento manual desde GitHub Actions

1. Ir a la pestaña **Actions → Build & Distribute HelpWave**
2. Clic en **“Run workflow”**
3. Seleccionar:
   - `patch`, `minor`, o `major`
   - Ingresar notas de la versión

> El workflow:
> - Actualiza la versión
> - Edita el `CHANGELOG.md`
> - Crea un `git tag`
> - Compila el APK
> - Lo distribuye a Firebase App Distribution

---

## 🚀 Distribución de builds

### 📂 Script local para distribución manual

```bash
./scripts/deploy.sh "Notas de esta versión"
```

Este script compila el APK en modo release y lo distribuye automáticamente a Firebase App Distribution.

### 👥 Testers actuales

- elvia.arteaga98@gmail.com  
- cuchcafabrizzio@gmail.com

---

## 👤 Autores

| Nombre           | Rol                       |
|------------------|---------------------------|
| Elvi Arteaga     | Arquitectura, Flutter Dev |
| Fabrizzio Cuchca | Backend & DevOps Engineer |

---

## 📜 Licencia

Este proyecto se distribuye bajo licencia **MIT**.  
Uso permitido con fines educativos, de investigación o sin fines de lucro.

---

## 🧩 Créditos y agradecimientos

Proyecto desarrollado como parte del trabajo de investigación para el título profesional en Ingeniería de Software.  
Inspirado por iniciativas de microvoluntariado digital.
