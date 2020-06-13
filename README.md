# QBASM
 Utilidad para compilar pseudocódigo a QBasic

## Directivas del pseudocódigo
- TODAS las palabras clave iran en MAYUSCULAS (ENTRAR y no Entrar).
- TODOS los nombres de funciones de usuario indicaran mediante el sufijo correspondiente el tipo de dato que devuelven (PedirNombre$, PedirTelefono&).
- En instrucciones del tipo VISUALIZAR los argumentos iran separados por punto y coma (;) y no por coma (,) (VISUALIZAR "N =";Num;" es primo").
- Las cadenas iran encerradas con comillas (").
- Cada linea de comentario comenzara con apostrofe (').
- NUNCA se acentuaran las palabras reservadas o los nombres de las variables, constantes, funciones o subprocedimientos (LOGICO y no LÓGICO, ultimo y no último).
- NUNCA se utilizara la Ñ en nombres de variables, constantes, funciones o procedimientos (Año, BAÑOS --> nombres no válidos).
- NUNCA se separara el primer parentesis del último caracter de las funciones predefinidas (COS(x) y no COS (x)).

Solo respetando estas directivas se podrá conseguir la máxima compilación posible, lo que significa el mínimo trabajo poscompilación.

## Pseudocódigo
Los corchetes ([]) indican elementos opcionales, \<expr> indica una expresión, \<Instrucciones> indica un bloque de instrucciones (puede dejarse vacio), \| indica elección (una u otra opción), \<cont> indica una variable contador y las llaves ({}) indican aclaraciones.

#### Tipos de datos:

|Tipo     | Suf | Rango                                         |
|---------|-----|-----------------------------------------------|
|NATURAL  | (&) | ± 2.147.483.647 (4b)                          |
|ENTERO   | (&) | ± 2.147.483.647 (4b)                          |
|REAL     | (#) | ± 1,79769313486236E+308 a ± 4,94065E-324 (8b) |
|CADENA   | ($) | Hasta 32.767 caracteres (6b + NumCar b)       |
|CARACTER | ($) | 1 Caracter (7b)                               |
|LOGICO   | (%) | V = -1; F = 0 (2b)                            |

#### Declaración de tipos:
      DECLARAR [GLOBAL] nomvar[(n HASTA m)] COMO tipo
{GLOBAL hace que una variable sea común a todo el programa, por defecto todas las variables son locales}

#### Declaración de registros:
      TIPO nomreg
          nomvar COMO tipo
          nomvar COMO tipo
      FINTIPO

#### Declaración de procedimientos:
      ACCION nomacc [(nomvar COMO tipo [, nomvar COMO tipo])]
          <Instrucciones>
          [TERMINAR ACCION]
          <Instrucciones>
      FINACCION

#### Declaración de funciones:
      FUNCION nomfun [(nomvar COMO tipo [, nomvar COMO tipo])]
          <Instrucciones>
          nomfun = <expr>
          [TERMINAR FUNCION]
          <Instrucciones>
      FINFUNCION

#### Asignación:
      nomvar <-- valor

#### Operadores lógicos:
       Y, O y NO

#### Operadores aritméticos:
  - Suma, resta (o negación): +, -
  - Multiplicación, División: *, /
  - Exponenciación: ^
  - División entera: DIV
  - Módulo (resto): MOD

#### Instrucciones de control:
  - TERMINAR
  - FIN
  - IRA
  - IRASUBRUTINA

#### Estructuras iterativas:
  - Bucle:

        ITERAR [MIENTRAS | HASTAQUE <expr>]
            <Intrucciones>
            [SI <expr> ENTONCES TERMINAR ITERAR]
            <Instrucciones>
        FINITERAR [MIENTRAS | HASTAQUE <expr>]
    {La salida del bucle se realizara al principio del mismo o al final, pero no se  pueden elegir ambos tipos de salida al mismo tiempo}

  - Bucle MIENTRAS:

        MIENTRAS <expr>
            <Instrucciones>
            [SI <expr> ENTONCES TERMINAR MIENTRAS]
            <Instrucciones>
        FINMIENTRAS

  - Bucle PARA:

        PARA <cont> <-- <expr> HASTA <expr> [INCREMENTO <expr>]
            <Instrucciones>
            [SI <expr> ENTONCES TERMINAR PARA]
        FINPARA [<cont>]
  {La variable contador del final del bucle es la misma del inicio del bucle, se puede indicar al final para obtener un pseudocódigo más legible}

#### Estructuras alternativas:
  - Alternativa simple/doble:

        SI <expr> ENTONCES
            <Instrucciones>
        [SINO]
            <Instrucciones>
        FINSI

  - Alternativa múltiple:

        CASO <espr> ENTONCES
            <Instrucciones>
        [ENOTROCASOSI <expr> ENTONCES]
            <Instrucciones>
        ENOTROCASO
            <Instrucciones>
        FINCASO

  - Alternativa múltiple ENCASODE:

        ENCASODE <espr>
            SEA <espr>
                <Instrucciones>
            [SEA <espr>]
                <Instrucciones>
            SEAOTROCASO
                <Instrucciones>
        FINENCASODE
      {SEAOTROCASO es opcional, pero se recomienda indicarla siempre}

#### Funciones:
- ABS, función
  - Propósito:
    Devolver el valor absoluto de la expresión n.
  - Sintaxis:

          ABS(n)
  - Comentarios:
    n tiene que ser una expresión numérica.

- ASC, función
  - Propósito:
    Devolver el valor numérico correspondiente al código ASCII del primer carácter de la cadena x\$.
  - Sintaxis:

        ASC(x$)
  - Comentarios:
    Si x\$ es nulo, se devuelve el error "Llamada ilegal a función". Véase la función CAR para la conversión recíproca de ASCII a cadena.

- ATN, función
  - Propósito:
    Devolver la arcotangente de x, con x expresado en radianes.
  - Sintaxis:

        ATN(x)
  - Comentarios:
    El resultado está en el intervalo -PI/2 a PI/2.

- PITA, instrucción
  - Propósito:
    Generar un sonido en el altavoz a 800 Hz durante 0.25 segundos.
  - Sintaxis:
        BEEP
  - Comentarios:
    PITA, Ctrl-G y VISUALIZA CAR(7) producen el mismo efecto.

- CARGA_BYTE, comando
  - Propósito:
    Cargar un fichero imagen en una zona cualquiera de la memoria de usuario.
  - Sintaxis:

        CARGA_BYTE nomfich[,despl]
  - Comentarios:
    - nomfich es una expresión de cadena válida que contiene el dispositivo y el nombre de fichero.
    - despl es una expresión numérica válida comprendida en el intervalo de 0 a 65,535. Este es el desplazamiento relativo el segmento declarado en la última instrucción DEFINE_SEGMENTO, donde se comenzará a cargar el fichero.
    Si se omite el desplazamiento, se asume el desplazamiento especificado en SALVA_BYTE, esto es, el fichero se carga en la misma dirección en la que se grabó.

- SALVA_BYTE, comando
  - Propósito:
    Grabar zonas de la memoria de usuario en el dispositivo especificado.
  - Sintaxis:

        SALVA_BYTE nomfich,despl,lon
  - Comentarios:
    - nomfich es una expresión de cadena válida que contiene el nombre del fichero.
    - despl es una expresión numérica válida comprendida en el intervalo de 0 a 65,535. Este es el desplazamiento relativo el segmento declarado en la última instrucción DEFINE_SEGMENTO, donde se comenzará a grabar el fichero.
    Se debe ejecutar una intrucción DEFINE_SEGMENTO antes de SALVA_BYTE, ya que siempre se utiliza la última dirección de esta instrucción para la grabación.
    - lon es una expresión numérica válida en el intervalo de 0 a 65,535 que especifica la longitud de la imagen de memoria que se va a grabar.
