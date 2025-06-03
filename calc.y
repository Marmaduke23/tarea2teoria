%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%union {
    int ival;      // para números
    int bval;      // para booleanos (1 o 0)
    char* sval;    // para strings
}

%token <ival> NUMBER
%token <bval> BOOLEAN
%token <sval> STRING

%token NOT IF AND PIPE LESS EQ
%token PLUS TIMES MINUS 
%token LPAREN RPAREN
%token DOT

%type <ival> expr nexpr bexpr
%type <sval> sexpr
%start input
%%
input:
      expr '\n'          { /* imprime resultado */ }
    | input expr '\n'    { /* imprime resultado */ }
    ;

expr:
      nexpr     { printf("%d\n", $1); }
    | bexpr     { printf("%s\n", $1 ? "\\true" : "\\false"); }
    | sexpr     { printf("'%s'\n", $1); free($1); }
;
nexpr:
    NUMBER                                  { $$ = $1; }
    | LPAREN nexpr PLUS nexpr RPAREN        {$$ = $2 + $4;}
    | LPAREN nexpr TIMES nexpr RPAREN       {$$ = $2 * $4;}
    | MINUS nexpr                           {$$ = - $2;}
    ;

bexpr:
      BOOLEAN                                 { $$ = $1; }
    | LPAREN bexpr AND bexpr RPAREN          { $$ = $2 && $4; }
    | LPAREN bexpr PIPE bexpr RPAREN         { $$ = $2 || $4; }
    | LPAREN NOT bexpr RPAREN                { $$ = !$3; }
    | LPAREN nexpr LESS nexpr RPAREN         { $$ = $2 < $4; }
    | LPAREN nexpr EQ nexpr RPAREN           { $$ = $2 == $4; }
    | LPAREN IF bexpr nexpr nexpr RPAREN       {$$ = $3 ? $4 : $5;}
    ;

sexpr:
      STRING                                  { $$ = $1; }
    ;


%%
int main(void) {
    printf("Ingrese una expresión:\n");
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
