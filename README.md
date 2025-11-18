# proyecto_III_arqui
Sistema de comparación de precios de videojuegos entre Steam y Amazon.
# 🎮 Comparador de Precios de Videojuegos

Un sistema de scraping multicore que compara precios de videojuegos entre Steam y Amazon para encontrar las mejores ofertas.

## 🚀 Características

- **Scraping en paralelo** de múltiples tiendas simultáneamente
- **Base de datos SQLite** con SQLAlchemy para almacenamiento eficiente
- **Comparación inteligente** de precios entre Steam y Amazon
- **Datos completos**: precios, descuentos, ratings, géneros y portadas
- **Identificación automática** de la mejor oferta disponible

## 🛠️ Tecnologías Utilizadas

- Python 3.8+
- SQLAlchemy (ORM para base de datos)
- Playwright (Scraping de Amazon)
- Requests (API de Steam)
- ThreadPoolExecutor (Procesamiento paralelo)

## 📦 Instalación

1. **Clonar el repositorio**:
```bash
git clone https://github.com/tu-usuario/comparador-juegos.git
cd comparador-juegos
