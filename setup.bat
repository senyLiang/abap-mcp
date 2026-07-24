@echo off
REM ============================================================
REM ABAP MCP Server - Quick Setup Script (Windows)
REM ============================================================
REM This script helps you configure the abap-mcp server locally.
REM Run it after cloning the repository.
REM ============================================================

echo.
echo ============================================================
echo   ABAP MCP Server - Setup
echo ============================================================
echo.

REM Check Java
java -version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Java not found. Please install Java 17+ from https://adoptium.net/
    exit /b 1
)
echo [OK] Java found

REM Check lib directory
if not exist "lib" mkdir lib

REM Check for JAR
if not exist "lib\jco-service-1.0.0-v5.jar" (
    echo.
    echo [MISSING] lib\jco-service-1.0.0-v5.jar
    echo   Copy the MCP server JAR to the lib\ directory.
    echo   Build from: ai-sap-abap-adt\jco-service (mvn clean package)
    echo.
) else (
    echo [OK] jco-service JAR found
)

REM Check for JCo
if not exist "lib\sapjco3.dll" (
    echo [MISSING] lib\sapjco3.dll
    echo   Download SAP JCo from SAP Support Portal
    echo.
) else (
    echo [OK] sapjco3.dll found
)

REM Check SNC library
set "SNC_DEFAULT=C:\Program Files\SAP\FrontEnd\SecureLogin\lib\sapcrypto.dll"
if exist "%SNC_DEFAULT%" (
    echo [OK] SNC library found at default location
    set "SNC_LIB=%SNC_DEFAULT%"
) else (
    echo [WARN] SNC library not at default location
    set /p SNC_LIB="  Enter path to sapcrypto.dll: "
)

REM Check SAP systems config
if not exist ".sap-systems.json" (
    echo.
    echo [SETUP] Creating .sap-systems.json from template...
    copy .sap-systems.template.json .sap-systems.json >nul
    echo   Please edit .sap-systems.json with your SAP system details.
    echo.
) else (
    echo [OK] .sap-systems.json exists
)

REM Generate paths summary
echo.
echo ============================================================
echo   Configuration Summary
echo ============================================================
echo.
echo   JAR:       %CD%\lib\jco-service-1.0.0-v5.jar
echo   JCo:       %CD%\lib
echo   SNC:       %SNC_LIB%
echo   Systems:   %CD%\.sap-systems.json
echo.
echo ============================================================
echo   Next Steps:
echo ============================================================
echo.
echo   1. Copy the missing dependencies to lib\
echo   2. Edit .sap-systems.json with your SAP system details
echo   3. Copy the config template for your AI tool:
echo      - Claude Desktop: configs\claude-desktop.json
echo      - Cursor:         configs\cursor-mcp.json
echo      - Windsurf:       configs\windsurf-mcp.json
echo      - VS Code:        configs\vscode-mcp.json
echo   4. Replace ${...} placeholders in the config with:
echo      ABAP_MCP_JAR = %CD%\lib\jco-service-1.0.0-v5.jar
echo      SAPJCO_PATH  = %CD%\lib
echo      SNC_LIB      = %SNC_LIB%
echo      SNC_LIB_DIR  = (directory of SNC_LIB)
echo.
echo   For Claude Code, run:
echo   claude mcp add abap-mcp --scope project -- java ^
echo     -Djava.net.preferIPv4Stack=true ^
echo     -Djco.middleware.snc_lib="%SNC_LIB%" ^
echo     -Dloader.path="%CD%\lib" ^
echo     -Djava.library.path="%CD%\lib;%SNC_LIB:\sapcrypto.dll=%" ^
echo     -jar "%CD%\lib\jco-service-1.0.0-v5.jar" ^
echo     --mcp --sap.adt.dangerous-operations.enabled=true
echo.
pause
