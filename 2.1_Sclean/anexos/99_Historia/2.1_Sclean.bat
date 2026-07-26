@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Crear estructura - 2.1_Sclean

set "ROOT=2.1_Sclean"

echo.
echo ============================================
echo      Creando estructura de Sclean
echo ============================================
echo.

mkdir "%ROOT%" 2>nul

mkdir "%ROOT%\01_Filosofia" 2>nul
mkdir "%ROOT%\02_Funcional" 2>nul
mkdir "%ROOT%\03_Tecnico" 2>nul
mkdir "%ROOT%\04_Desarrollo" 2>nul
mkdir "%ROOT%\05_Recursos" 2>nul
mkdir "%ROOT%\anexos" 2>nul

type nul > "%ROOT%\00_README.md"
type nul > "%ROOT%\CHANGELOG.md"

type nul > "%ROOT%\01_Filosofia\Vision.md"
type nul > "%ROOT%\01_Filosofia\Objetivos.md"
type nul > "%ROOT%\01_Filosofia\Alcance.md"

type nul > "%ROOT%\02_Funcional\EspecificacionFuncional.md"
type nul > "%ROOT%\02_Funcional\FlujoTrabajo.md"
type nul > "%ROOT%\02_Funcional\Clasificacion.md"
type nul > "%ROOT%\02_Funcional\Nomenclatura.md"
type nul > "%ROOT%\02_Funcional\Restauracion.md"
type nul > "%ROOT%\02_Funcional\Reglas.md"
type nul > "%ROOT%\02_Funcional\Estados.md"

type nul > "%ROOT%\03_Tecnico\ArquitecturaTecnica.md"
type nul > "%ROOT%\03_Tecnico\Pipeline.md"
type nul > "%ROOT%\03_Tecnico\Modulos.md"
type nul > "%ROOT%\03_Tecnico\BaseDatos.md"
type nul > "%ROOT%\03_Tecnico\Dependencias.md"
type nul > "%ROOT%\03_Tecnico\Empaquetado.md"

type nul > "%ROOT%\04_Desarrollo\Roadmap.md"
type nul > "%ROOT%\04_Desarrollo\MVP.md"
type nul > "%ROOT%\04_Desarrollo\Backlog.md"
type nul > "%ROOT%\04_Desarrollo\CriteriosAceptacion.md"

type nul > "%ROOT%\05_Recursos\Glosario.md"
type nul > "%ROOT%\05_Recursos\Siglas.md"

echo > "%ROOT%\anexos\.gitkeep"

echo.
echo ============================================
echo Estructura creada correctamente.
echo ============================================
echo.
echo Carpeta:
echo   %ROOT%
echo.
pause