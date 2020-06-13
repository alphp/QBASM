'Declaración de variables y constantes globales:
    CONSTANTE CIERTO <-- -1
    CONSTANTE FALSO <-- 0
    DECLARAR GLOBAL Lineas, LineasLib COMO ENTERO
    DECLARAR GLOBAL Algoritmo$, Codigo$, Auxiliar$

'Declaración de variables locales e iniciación de variables globales:
    DECLARAR Linea$
    Lineas <-- 0
    LineasLib <-- 0

'Inicio del código a nivel de módulo:
    BORRARPANTALLA
    NombreArchivo

    EN ERROR IRA ErrorArchivos
    ABRIR "QBASM.LIB" PARA ENTRADA COMO #1
    ITERAR MIENTRAS NO FINARCHIVO(1)
        ENTRARLINEA #1, Linea$
        LineasLib <-- LineasLib + 1
    FINITERAR
    CERRAR #1

    EN ERROR IRA ErrorArchivo1
    ABRIR Algoritmo$ PARA ENTRADA COMO #2
    ITERAR MIENTRAS NO FINARCHIVO(2)
        ENTRARLINEA #2, Linea$
        Lineas <-- Lineas + 1
    FINITERAR
    CERRAR #2

    COLOR 7
    VISUALIZAR "Ejecutando";
    COLOR 23
    VISUALIZAR "..."
    COLOR 15
    SI Codigo$ = "CON" ENTONCES
        COLOR 7
    FINSI

    EN ERROR IRA ErrorArchivo1
    ABRIR Algoritmo$ PARA ENTRADA COMO #2
    EN ERROR IRA ErrorArchivo2
    ABRIR Codigo$ PARA SALIDA COMO #3
    EN ERROR IRA 0

    GenerarCodigo

    CERRAR #2, #3

    SI Codigo$ = "CON" ENTONCES
        ESPERAR
    FINSI

    COLOR 7
    BORRARPANTALLA
    SISTEMA

'Rutinas de tratamiento de errores:
ErrorArchivos:
    BORRARPANTALLA
    VISUALIZAR
    VISUALIZAR "    Falta libreria (QBASM.LIB) o no se encuentra en la ruta actual."
    VISUALIZAR
    SISTEMA

ErrorArchivo1:
    BORRARPANTALLA
    VISUALIZAR "    Nombre de archivo incorrecto"
    VISUALIZAR
    VISUALIZAR "    Nuevo archivo (ENTRAR para terminar): ";
    ENTRAR "", Algoritmo$
    SI Algoritmo$ = "" THEN
        SISTEMA
    FINSI

ErrorArchivo2:
    VISUALIZAR "    Archivo de salida (ENTRAR para salida a pantalla): ";
    ENTRAR "", Codigo$
    VISUALIZAR
    Extensiones
    SI Auxiliar$ = "" THEN
        CONTINUAR
    SINO
        Auxiliar$ <-- ""
        CONTINUAR SIGUIENTE
    FINSI

ACCION Extensiones
    SI Codigo$ = "" ENTONCES
        Codigo$ <-- "CON"
    FINSI

    SI ENCAD(Algoritmo$, ".") = 0 ENTONCES
        Algoritmo$ <-- Algoritmo$ + ".ALG"
    FINSI

    SI ENCAD(Codigo$, ".") = 0 ENTONCES
        ENCASODE Codigo$
            SEA "CON", "SCRN", "PRN", "COM1", "COM2", "LPT1", "LPT2", "LPT3"
                TERMINAR ACCION
            SEAOTROCASO
                Codigo$ <-- Codigo$ + ".BAS"
        FINENCASODE
    FINSI

    ITERAR MIENTRAS Algoritmo$ = Codigo$
        Auxiliar$ <-- IZQ(Algoritmo$, ENCAD(Algoritmo$, ".")) + "BAK"
        EN ERROR IRA ErrorArchivo1
        NOMBRE Algoritmo$ COMO Auxiliar$
        EN ERROR IRA 0
        SI Auxiliar$ <> "" ENTONCES
            Algoritmo$ <-- Auxiliar$
        FINSI
    FINITERAR
FINACCION

ACCION GenerarCodigo
'Declaración e iniciación de variables locales:
    DECLARAR Lin, LinLib COMO ENTERO
    DECLARAR Linea$, Alg$(1 HASTA LineasLib) , Cod$(1 HASTA LineasLib)
    Lin <-- 0

'Inicio:
    ABRIR "QBASM.LIB" PARA ENTRADA COMO #1
    PARA LinLib <-- 1 HASTA LineasLib
        ENTRAR #1, Alg$(LinLib), Cod$(LinLib)
    FINPARA
    CERRAR #1

    MIENTRAS NO FINARCHIVO(2)
        ENTRARLINEA #2, Linea$
        Lin <-- Lin + 1

        PARA LinLib <-- 1 HASTA LineasLib
            Sustituir Linea$, Alg$(LinLib), Cod$(LinLib)
        FINPARA

        SI Codigo$ = "CON" Y Lin MOD 24 = 0 ENTONCES
            ESPERAR
        FINSI
        SI Codigo$ <> "CON" ENTONCES
            POSICIONARCURSOR 6, 15
            VISUALIZAR FORMATO "###% Procesado"; 100 * (Lin / Lineas)
        FINSI
        VISUALIZAR #3, Linea$
    FINPARA
FINACCION

ACCION NombreArchivo
    BORRARPANTALLA
    VISUALIZAR "    QBASM por Txampi Herrero: Utilidad para compilar pseudocodigo a QBasic"
    VISUALIZAR "                          (asume .ALG si no se especifica una extensión)"
    VISUALIZAR

    VISUALIZAR "        Archivo de entrada (ENTRAR para terminar): ";
    ENTRAR "", Algoritmo$
    SI Algoritmo$ = "" ENTONCES
        SISTEMA
    FINSI

    VISUALIZAR "        Archivo de salida (ENTRAR para salida a monitor): ";
    ENTRAR "", Codigo$
    Extensiones
FINACCION

ACCION Sustituir(Linea$, Pseudo$, Codigo$)
    ITERAR MIENTRAS NO ENCAD(Linea$, Pseudo$) = 0
        Linea$ <-- IZQ(Linea$, ENCAD(Linea$, Pseudo$) - 1) + Codigo$ + DER(Linea$, LON(Linea$) - LON(Pseudo$) - ENCAD(Linea$, Pseudo$) + 1)
    FINITERAR
FINACCION

