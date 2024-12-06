%{
    #include <stdio.h>
    #include <string.h>
    #include "y.tab.h"
%}

%option noyywrap

DIGITO [0-9]
LETRA [a-zA-Z]
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
CONSTANTE_ENTERA {DIGITO}({DIGITO})*

%%

"inicio" { return INICIO; }
"fin" { return FIN; }
"escribir" { return ESCRIBIR; }
"leer" { return LEER; }
":=" { return ASIGNACION; }
{CONSTANTE_ENTERA} { yylval.intValor = atoi(yytext); return CONSTANTE; }
{IDENTIFICADOR} { yylval.charValor = strdup(yytext); return ID; }
";" { return PUNTOYCOMA; }
"(" { return PARENTIZQ; }
")" { return PARENTDER; }
"+" { return SUMA; }
"-" { return RESTA; }
"," { return COMA; }
[ \t\n]+ { /* Ignora espacios y saltos de lineas */ }
. { printf("Error lexico: Token no reconocido: '%s'\n", yytext); exit(0); }

%%


