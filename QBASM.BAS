DEFINT A-Z

'   Declaraciones de funciones y subprocedimientos:
DECLARE SUB NombreArchivo ()
DECLARE SUB Extensiones ()
DECLARE SUB GenerarCodigo ()
DECLARE SUB Sustituir (Linea$, Pseudo$, Codigo$)

'   Datos y constantes globales:
CONST V = -1
CONST F = 0
DIM Linea$
DIM SHARED Lineas, LineasLib AS INTEGER
DIM SHARED Algoritmo$, Codigo$, Auxiliar$

'   Inicio del código a nivel de módulo:
    CLS
    NombreArchivo

    ON ERROR GOTO ErrorArchivos
    OPEN "QBASM.LIB" FOR INPUT AS #1
    DO WHILE NOT EOF(1)
        LINE INPUT #1, Linea$
        LineasLib = LineasLib + 1
    LOOP
    CLOSE #1

    ON ERROR GOTO ErrorArchivo1
    OPEN Algoritmo$ FOR INPUT AS #2
    DO WHILE NOT EOF(2)
        LINE INPUT #2, Linea$
        Lineas = Lineas + 1
    LOOP
    CLOSE #2

    COLOR 7:  PRINT "Ejecutando";
    COLOR 23: PRINT "..."
    COLOR 15:  PRINT
    IF Codigo$ = "CON" THEN
        COLOR 7
    END IF

    ON ERROR GOTO ErrorArchivo1
    OPEN Algoritmo$ FOR INPUT AS #2
    ON ERROR GOTO ErrorArchivo2
    OPEN Codigo$ FOR OUTPUT AS #3
    ON ERROR GOTO 0

    GenerarCodigo

    CLOSE #2, #3

    IF Codigo$ = "CON" THEN
        SLEEP
    END IF

    COLOR 7: CLS
    SYSTEM

ErrorArchivos:
    CLS
    PRINT
    PRINT "     Falta libreria (QBASM.LIB) o no se encuentra en la ruta actual."
    PRINT
    SYSTEM

ErrorArchivo1:
    CLS
    PRINT "     Nombre de archivo incorrecto"
    PRINT
    INPUT "     Nuevo archivo (ENTRAR para terminar): ", Algoritmo$
    IF Algoritmo$ = "" THEN
        SYSTEM
    END IF

ErrorArchivo2:
    INPUT "     Archivo de salida (ENTRAR para salida a pantalla): ", Codigo$
    PRINT
    Extensiones
    IF Auxiliar$ = "" THEN
        RESUME
    ELSE
        Auxiliar$ = ""
        RESUME NEXT
    END IF

SUB Extensiones STATIC
    IF Codigo$ = "" THEN
        Codigo$ = "CON"
    END IF

    IF INSTR(Algoritmo$, ".") = 0 THEN
        Algoritmo$ = Algoritmo$ + ".ALG"
    END IF

    IF INSTR(Codigo$, ".") = 0 THEN
        SELECT CASE Codigo$
            CASE "CON", "SCRN", "PRN", "COM1", "COM2", "LPT1", "LPT2", "LPT3"
                EXIT SUB
            CASE ELSE
                Codigo$ = Codigo$ + ".BAS"
        END SELECT
    END IF

    DO WHILE Algoritmo$ = Codigo$
        Auxiliar$ = LEFT$(Algoritmo$, INSTR(Algoritmo$, ".")) + "BAK"
        ON ERROR GOTO ErrorArchivo1
        NAME Algoritmo$ AS Auxiliar$
        ON ERROR GOTO 0
        IF Auxiliar$ <> "" THEN
            Algoritmo$ = Auxiliar$
        END IF
    LOOP
END SUB

SUB GenerarCodigo
DIM Lin, LinLib AS INTEGER
DIM Linea$, Alg$(1 TO LineasLib), Cod$(1 TO LineasLib)

    LinLib = 0
    OPEN "QBASM.LIB" FOR INPUT AS #1
    DO WHILE NOT EOF(1)
        LinLib = LinLib + 1
        INPUT #1, Alg$(LinLib), Cod$(LinLib)
    LOOP
    CLOSE #1

    Lin = 0
    DO WHILE NOT EOF(2)
        LINE INPUT #2, Linea$
        Lin = Lin + 1

        FOR LinLib = 1 TO LineasLib
            Sustituir Linea$, Alg$(LinLib), Cod$(LinLib)
        NEXT

        IF Codigo$ = "CON" AND Lin MOD 24 = 0 THEN
            SLEEP
        END IF
        IF Codigo$ <> "CON" THEN
            LOCATE 6, 15: PRINT USING "###% Procesado"; 100 * (Lin / Lineas)
        END IF
        PRINT #3, Linea$
    LOOP
END SUB

SUB NombreArchivo STATIC
    CLS
    PRINT " Txampi Herrero: Utilidad para compilar pseudocodigo a QBasic"
    PRINT "             (asume .ALG si no se especifica una extensión)"
    PRINT

    INPUT "     Archivo de entrada (ENTRAR para terminar): ", Algoritmo$
    IF Algoritmo$ = "" THEN
        SYSTEM
    END IF

    INPUT "     Archivo de salida (ENTRAR para salida a monitor): ", Codigo$
    Extensiones
END SUB

SUB Sustituir (Linea$, Pseudo$, Codigo$)
    DO WHILE NOT INSTR(Linea$, Pseudo$) = 0
        Linea$ = LEFT$(Linea$, INSTR(Linea$, Pseudo$) - 1) + Codigo$ + RIGHT$(Linea$, LEN(Linea$) - LEN(Pseudo$) - INSTR(Linea$, Pseudo$) + 1)
    LOOP
END SUB

