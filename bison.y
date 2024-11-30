%{
    #include <stdio.h>

    void yyerror(const char *s);
    int yylex();
%}

%option noyywrap

%token INICIO FIN ESCRIBIR LEER
%token ASIGNACION CONSTANTE ID 
%token PUNTOYCOMA PARENTIZQ PARENTDER SUMA RESTA COMA

%start program

%%

programa: 
    INICIO cuerpo FIN;

cuerpo:
    sentencia 
    | cuerpo sentencia;

sentencia:
    ID ASIGNACION expresion PUNTOYCOMA
    | LEER PARENTIZQ identificadores PARENTDER PUNTOYCOMA
    | ESCRIBIR PARENTIZQ expresiones PARENTDER PUNTOYCOMA;

identificadores:
    ID
    | identificadores COMA ID;

expresiones:
    expresion
    | expresiones COMA expresion;

expresion:
    expresion SUMA expresion { $$ = $1 + $3; }
    | expresion RESTA expresion { $$ = $1 - $3; }
    | PARENTIZQ expresion PARENTDER { $$ = $2; }
    | CONSTANTE { $$ = $1; }
    | ID { $$ = 0; };

%%

void yyerror(const char *cadena){
    printf("Error sintáctico: '%s'\n", cadena);
}

int main(){
    printf("Ingrese programa: \n");

    if (yyparse() == 0) {
        printf("Análisis completo.\n");
    }
    
    return 0;
}