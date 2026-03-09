# Guia de contribución en Bloomind

Para que el desarrollo de **Bloomind** sea ordenado y evitar conflictos entre el trabajo de todos, seguiremos este flujo de trabajo obligatorio. Este documento explica cómo trabajar con Git y GitHub dentro del proyecto.

---

## 1. Estructura de Ramas del Proyecto
El proyecto usa una estructura de ramas simple y controlada:

* **`main`** (Rama principal)
    * `↑`
* **`develop`** (Rama de integración)
    * `↑`
* **`feature/*`** (Ramas de trabajo)

### 🌳 `main`
Contiene solo versiones estables y entregables del proyecto.
* **Reglas:**
    * Nadie hace *push* directo.
    * Solo se actualiza desde `develop`.
    * Solo el líder del proyecto hace el *merge* final.

### 🌱 `develop`
Es la rama principal de desarrollo. Aquí se integran todas las funcionalidades nuevas después de revisión.
* **Reglas:**
    * Todo cambio debe llegar mediante *Pull Request*.
    * Nadie trabaja directamente en `develop`.

### 🌿 `feature/*`
Son ramas individuales para cada tarea ejemplos:
 `feature/crear-rutinas`
 `feature/agregar-actividades`
 `feature/controlador-habitos`

---

## 2. Flujo de Trabajo Diario

### Paso A — Sincronización (Antes de empezar)
Antes de escribir una sola línea de código, asegúrate de tener la versión más reciente del proyecto:
```bash
git checkout develop
git pull origin develop
```
---

### Paso B — Crear tu rama de trabajo
Cada tarea debe hacerse en su propia rama.
Reglas:
•	Sin espacios
•	Sin tildes
•	Usar guiones
```bash
git checkout -b feature/nombre-de-tu-tarea
```
Ejemplo:
```bash
git checkout -b feature/controlador-rutinas
```
________________________________________
### Paso C — Guardar tu progreso
Haz commits claros y frecuentes.
```bash
git add .
git commit -m "feat: agregado controlador de rutinas"
```
Evita commits como:
cambios
arreglo
update
________________________________________
### Paso D — Subir tu trabajo
Cuando hayas terminado tu tarea:
```bash
git push -u origin feature/nombre-de-tu-tarea
```
________________________________________
### Paso E — Crear Pull Request
1.	Ve al repositorio en GitHub
2.	Crea un Pull Request
3.	Selecciona:
•	base (Destino): Es la rama estable y principal donde quieres que se incorporen tus cambios. develop.
•	compare (Origen): Es tu rama de trabajo (feature branch) que contiene tus commits nuevos y cambios. 

4.	Solicita revisión.
________________________________________
## 📋 3. Checklist antes de abrir un Pull Request
Antes de crear un PR asegúrate de revisar si:
•	El código compila correctamente
•	No rompe funcionalidades existentes
•	El código está limpio y organizado
•	No hay archivos innecesarios
•	Probaste tu funcionalidad localmente
________________________________________
## 🔁 4. Actualizar tu rama con develop
Si alguien hizo cambios en develop, debes actualizar tu rama antes de continuar.
git checkout develop
git pull origin develop
git checkout feature/tu-rama
git merge develop
Esto evita conflictos al final.
________________________________________
## ⚠️ 5. Si aparece un conflicto
Un conflicto ocurre cuando dos personas modifican el mismo código.
Pasos:
1.	Git marcará el conflicto en los archivos.
2.	Edita el archivo manualmente.
3.	Decide qué código conservar.
4.	Guarda el archivo.
Luego:
```bash
git add .
git commit -m "fix: resolver conflicto de merge"
```
________________________________________
## 6. Comandos Útiles
Ver estado del proyecto:
```bash
git status
```
Ver ramas disponibles:
```bash
git branch
```
Ver historial resumido:
```bash
git log --oneline
```
Cambiar de rama:
```bash
git checkout nombre-rama
```
________________________________________
## 📝 7. Convención de Commits
Usaremos prefijos para que el historial sea claro.
Nuevas funcionalidades
feat: agregar controlador de hábitos
Corrección de errores
fix: corregido error en validación de usuario
________________________________________
## 8. Reglas de Oro del Código (Bloomind)
Para mantener la integridad de la arquitectura y evitar errores en cascada:
Modelos e Interfaces
No modifiques atributos o métodos que ya estén siendo utilizados.
________________________________________
Principio de Extensión
Si necesitas una nueva funcionalidad:
✔ extiende la clase, agrega nuevos metodos
✔ crea una nueva clase
❌ no rompas lo que ya funciona.
________________________________________
Comunicación
Si necesitas cambiar algo que afecta a varios módulos:
consulta primero con el líder del proyecto.
________________________________________
## 🚨 9. Reglas Importantes del Equipo
Nunca trabajar directamente en:
main
develop
Siempre usar ramas:
feature/*
Nunca hacer:
git push origin main
Siempre usar Pull Request.
________________________________________
Si todos seguimos este flujo, el desarrollo será mucho más rápido, limpio y profesional.


