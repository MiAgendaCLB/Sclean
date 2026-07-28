Estando en esa carpeta (`vive-doc-prep`), el comando único es:

```cmd
python build_scripts\empaquetar.py
```

Esto hace todo: corre PyInstaller (`--onedir`), copia los binarios externos (tesseract/gswin64c/qpdf localizados en tu PATH) a `dist\Sclean\bin\`, y copia `tessdata` (incluyendo `configs/`, `tessconfigs/` y el español si lo tienes instalado) a `dist\Sclean\tessdata\`.

**Requisito previo** (una sola vez, si no lo has hecho ya en esa máquina):

```cmd
pip install -r requirements.txt pyinstaller
```

**Resultado:** el ejecutable queda en `dist\Sclean\Sclean.exe`. Para usar la app, ejecutas ese `.exe` (doble clic o `dist\Sclean\Sclean.exe` desde cmd) — ese es el que abre el navegador solo, no el script de empaquetado.

Si Tesseract/Ghostscript/qpdf no están en el PATH del sistema en esa máquina, el script imprime una advertencia explícita indicando cuál faltó, sin fallar el build completo.