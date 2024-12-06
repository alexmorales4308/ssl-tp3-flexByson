%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern char *yytext;
    extern int yyleng;
    extern int yylex(void);
    extern void yyerror(char *cadena);


    typedef struct {
        char nombre[33];
        int valor;
        int inicializado;
    } Variable;

    #define MAX_VARS 100
    Variable tablaDeSimbolos[MAX_VARS];
    int contadorVariables = 0;

    int existeVariable(char *nombre);
    int asignarVariable(char *nombre, int valor);
    int obtenerVariable(char *nombre);
    
    char** agregarIdentificador(char** lista, char* item);
    int** agregarExpresion(int** lista, int item);
    void leer(char** lista);
    void escribir(int** lista);
%}

%union {
    int intValor;
    char* charValor;
    char** charArrayValor;
    int** intArrayValor;
}

%token INICIO FIN ESCRIBIR LEER
%token CONSTANTE 
%token ID 
%token ASIGNACION PUNTOYCOMA PARENTIZQ PARENTDER SUMA RESTA COMA

%type <intValor> expresion sentencia listaSentencias primaria CONSTANTE
%type <charValor> ID
%type <charArrayValor> listaIdentificadores
%type <intArrayValor> listaExpresiones

%left SUMA RESTA COMA
%right ASIGNACION

%start programa

%%

programa: 
    INICIO listaSentencias FIN {
        printf("Programa Micro Finalizado.\n");
        exit(0);
    }
    ;

listaSentencias:
    sentencia 
    | listaSentencias sentencia
    ;

sentencia:
    ID ASIGNACION expresion PUNTOYCOMA { asignarVariable($1, $3); }
    | LEER PARENTIZQ listaIdentificadores PARENTDER PUNTOYCOMA { leer($3); }
    | ESCRIBIR PARENTIZQ listaExpresiones PARENTDER PUNTOYCOMA { escribir($3); }
    ;

listaIdentificadores:
    ID { $$ = agregarIdentificador(NULL, $1); }
    | listaIdentificadores COMA ID { $$ = agregarIdentificador($1, $3); }
    ;

listaExpresiones:
    expresion { $$ = agregarExpresion(NULL, $1); }
    | listaExpresiones COMA expresion { $$ = agregarExpresion($1, $3); }
    ;

expresion:
    primaria
    | expresion SUMA expresion { $$ = $1 + $3; }
    | expresion RESTA expresion { $$ = $1 - $3; }
    ;

primaria:
    ID { $$ = obtenerVariable($1); }
    | CONSTANTE { $$ = $1; }
    | PARENTIZQ expresion PARENTDER { $$ = $2; }
    ;

%%

int existeVariable(char *nombre){
    for(int indice = 0; indice < contadorVariables; indice++){
        if(strcmp(tablaDeSimbolos[indice].nombre, nombre) == 0){
            return indice;
        }
    }

    return -1;
}

int asignarVariable(char *nombre, int valor){
    int indice = existeVariable(nombre);
    
    if(indice == -1){
        if(contadorVariables > MAX_VARS){
            printf("Error: No hay espacio suficiente en la tabla de simbolos.\n");
            return -1;
        }

        strcpy(tablaDeSimbolos[contadorVariables].nombre, nombre);
        tablaDeSimbolos[contadorVariables].valor = valor;
        tablaDeSimbolos[contadorVariables].inicializado = 1;
        contadorVariables++;
        return 0;
    }

    tablaDeSimbolos[indice].valor = valor;
    tablaDeSimbolos[indice].inicializado = 1;

    return 0;
}

int obtenerVariable(char *nombre){
    int indice = existeVariable(nombre);

    if(indice == -1){
        printf("Error semantico: '%s' no esta declarada.\n", nombre);
        exit(1);
    } else if(!tablaDeSimbolos[indice].inicializado){
        printf("Error semantico: '%s' no esta inicializada.\n", nombre);
        exit(1);
    }

    return tablaDeSimbolos[indice].valor;
}

char** agregarIdentificador(char** lista, char* item) {
    int longitud;
    for (longitud = 0; lista && lista[longitud] != NULL; longitud++);

    if(longitud == 0){
        lista = malloc(2 * sizeof(char*));
    }else{
        lista = realloc(lista, (longitud + 2) * sizeof(char*));
    }

    lista[longitud] = strdup(item);
    lista[longitud + 1] = NULL;
    return lista;
}

int** agregarExpresion(int** lista, int item){
    int longitud;
    for (longitud = 0; lista && lista[longitud] != NULL; longitud++);

    if(longitud == 0){
        lista = malloc(sizeof(int*));
    }else{
        lista = realloc(lista, (longitud + 1) * sizeof(int*));
    }

    lista[longitud] = malloc(sizeof(int));
    *lista[longitud] = item;
    lista[longitud + 1] = NULL;
    return lista;
}

void leer(char** lista){
    for(int indice = 0; lista[indice] != NULL; indice++){
        printf("Introduzca valor para: %s\n", lista[indice]);
        int valor;
        scanf("%d", &valor);
        asignarVariable(lista[indice], valor);
    } 
}

void escribir(int** lista){
    for(int indice = 0; lista[indice] != NULL; indice++){
        printf("%d ", *lista[indice]);
    }
    printf("\n");
}

void yyerror(char *cadena){
    printf("Error sintactico: '%s'.\n", cadena);
}

int yywrap(){
    return 1;
}

int main(){
    printf("Ingrese programa Micro: \n");
    yyparse();
    return 0;
}