# AutoDex Chile (SwiftUI)

Arquitectura propuesta inicial para una app iOS tipo “Pokédex de autos” enfocada en Chile.

> **Estado actual:** definición de arquitectura y estructura de proyecto (sin implementación funcional).

## Objetivo de esta fase

Diseñar una base clara para abrir y organizar el proyecto en Xcode antes de escribir la lógica completa.

## Arquitectura recomendada: MVVM

- **Model**: representa entidades de dominio (autos, resultados OCR, logros, estadísticas).
- **View**: UI en SwiftUI.
- **ViewModel**: orquesta estados de pantalla, validaciones y coordinación entre servicios/repositorios.
- **Services**: lógica de integración (OCR, lookup de vehículo, rareza, logros).
- **Repositories**: persistencia local de la colección “Pokédex”.
- **Utilities**: helpers puros y reutilizables (normalización/validación de patente, almacenamiento de imágenes).
- **Web**: componentes de UI para contenido web embebido (WebView).

## Estructura propuesta de carpetas y archivos

```text
AutoDexChile/
├─ App/
│  ├─ AutoDexChileApp.swift
│  └─ AppRouter.swift
├─ Models/
│  ├─ CarEntry.swift
│  ├─ VehicleLookupResult.swift
│  ├─ OCRResult.swift
│  ├─ Achievement.swift
│  └─ AppStats.swift
├─ Services/
│  ├─ OCRService.swift
│  ├─ VehicleLookupProviding.swift
│  ├─ ManualVehicleLookupService.swift
│  ├─ WebVehicleLookupService.swift
│  ├─ AchievementService.swift
│  └─ RarityService.swift
├─ Repositories/
│  └─ InventoryRepository.swift
├─ Utilities/
│  ├─ ChilePlateNormalizer.swift
│  ├─ ChilePlateValidator.swift
│  └─ ImageStorageHelper.swift
├─ ViewModels/
│  ├─ HomeViewModel.swift
│  ├─ ScanFlowViewModel.swift
│  ├─ PlateReviewViewModel.swift
│  ├─ LookupResultViewModel.swift
│  ├─ CarDetailViewModel.swift
│  └─ StatsViewModel.swift
├─ Views/
│  ├─ HomeView.swift
│  ├─ ScanFlowView.swift
│  ├─ PlateReviewView.swift
│  ├─ LookupResultView.swift
│  ├─ ManualEntryView.swift
│  ├─ CarDetailView.swift
│  └─ StatsView.swift
└─ Web/
   └─ VehicleLookupWebView.swift
```

---

## Responsabilidad por archivo

### App

- **AutoDexChileApp.swift**
  - Punto de entrada de la app.
  - Inyección inicial de dependencias principales.
- **AppRouter.swift**
  - Define rutas/pantallas y navegación raíz.

### Models

- **CarEntry.swift**
  - Modelo principal de un auto guardado en la colección.
  - Incluye patente limpia, fotos, datos lookup y metadatos.
- **VehicleLookupResult.swift**
  - Estructura de datos retornada por el lookup de vehículo.
- **OCRResult.swift**
  - Resultado bruto y procesado de OCR (texto detectado, confianza).
- **Achievement.swift**
  - Define logros desbloqueables y condiciones.
- **AppStats.swift**
  - Estadísticas agregadas de la colección (total, rarezas, etc.).

### Services

- **OCRService.swift**
  - Encapsula lectura OCR de imágenes de patentes.
- **VehicleLookupProviding.swift**
  - Protocolo para lookup de datos de vehículo.
- **ManualVehicleLookupService.swift**
  - Implementación manual/local/fallback para búsqueda.
- **WebVehicleLookupService.swift**
  - Implementación remota/web del lookup.
- **AchievementService.swift**
  - Evalúa y desbloquea logros según eventos.
- **RarityService.swift**
  - Calcula “rareza” de un auto según reglas del dominio.

### Repositories

- **InventoryRepository.swift**
  - CRUD de autos guardados (fuente única de verdad de inventario).
  - Abstracción de persistencia (UserDefaults, archivo o Core Data a futuro).

### Utilities

- **ChilePlateNormalizer.swift**
  - Limpia y normaliza string de patente chilena (formato consistente).
- **ChilePlateValidator.swift**
  - Valida formato/estructura de patente chilena.
- **ImageStorageHelper.swift**
  - Guardado/carga/borrado de imágenes locales.

### ViewModels

- **HomeViewModel.swift**
  - Estado de portada: resumen, accesos a escaneo y colección.
- **ScanFlowViewModel.swift**
  - Flujo completo de captura (auto + patente), OCR y transición.
- **PlateReviewViewModel.swift**
  - Permite editar/confirmar patente detectada y validación.
- **LookupResultViewModel.swift**
  - Maneja estado de búsqueda: loading, éxito, error, retry.
- **CarDetailViewModel.swift**
  - Lógica de detalle del auto guardado.
- **StatsViewModel.swift**
  - Agregación y presentación de estadísticas para UI.

### Views

- **HomeView.swift**
  - Pantalla principal (resumen + navegación).
- **ScanFlowView.swift**
  - UI del flujo de captura y OCR.
- **PlateReviewView.swift**
  - UI para revisar/corregir patente antes de buscar.
- **LookupResultView.swift**
  - Muestra resultados del lookup y acciones de guardado.
- **ManualEntryView.swift**
  - Entrada manual cuando OCR/lookup falla.
- **CarDetailView.swift**
  - Vista de detalle del auto dentro de la colección.
- **StatsView.swift**
  - Dashboard de métricas y progreso tipo Pokédex.

### Web

- **VehicleLookupWebView.swift**
  - Wrapper SwiftUI de `WKWebView` para consultas web/integraciones.

---

## Flujo principal de datos (alto nivel)

1. Usuario captura fotos en **ScanFlowView**.
2. **ScanFlowViewModel** usa **OCRService** para extraer patente.
3. **PlateReviewViewModel** aplica **ChilePlateNormalizer** y **ChilePlateValidator**.
4. **LookupResultViewModel** consulta **VehicleLookupProviding**.
5. Resultado se transforma en **CarEntry** y se persiste vía **InventoryRepository**.
6. **AchievementService** + **RarityService** actualizan progresión y estadísticas.

---

## Siguiente paso sugerido

Cuando confirmes esta estructura, el siguiente paso es crear el proyecto Xcode + archivos vacíos/stubs con protocolos y modelos mínimos para compilar.
