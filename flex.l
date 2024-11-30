%{
    #include <stdio.h>
%}

%option noyywrap

DIGITO [0-9]
LETRA [a-zA-Z]
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
CONSTANTE_ENTERA {DIGITO}({DIGITO})*

%%

"inicio" {
    return INICIO;
}
"fin" {
    return FIN;
}
"escribir" {
    return ESCRIBIR;
}
"leer" {
    return LEER;
}
":=" { 
    return ASIGNACION; 
}
{CONSTANTE_ENTERA} {
    yylval.num = atoi(yytext); 
    return CONSTANTE;
}
IDENTIFICADOR { 
    return ID; 
}
";" { 
    return PUNTOYCOMA; 
}
"(" { 
    return PARENTIZQ; 
}
")" { 
    return PARENTDER; 
}
"+" { 
    return SUMA; 
}
"-" { 
    return RESTA; 
}
"," {
    return COMA;
}
[\t\n]+ { /* Ignora espacios y saltos de lineas */ }
. { 
    printf("Error léxico: Caracter no reconocido: '%s'\n", yytext);
}

%%

int main(){
    printf("Ingrese fuente micro\n");
    yylex();
    return 0;
}