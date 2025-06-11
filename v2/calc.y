%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);
extern FILE *yyin;
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
    expr
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
    | PIPE sexpr PIPE                       { $$ = strlen($2); free($2);}
    | LPAREN IF bexpr nexpr nexpr RPAREN    {$$ = $3 ? $4 : $5;}
    ;  

bexpr:
      BOOLEAN                                 { $$ = $1; }
    | LPAREN bexpr AND bexpr RPAREN          { $$ = $2 && $4; }
    | LPAREN NOT bexpr RPAREN                { $$ = !$3; }
    | LPAREN nexpr LESS nexpr RPAREN         { $$ = $2 < $4; }
    | LPAREN nexpr EQ nexpr RPAREN           { $$ = $2 == $4; }
    | LPAREN IF bexpr bexpr bexpr RPAREN       {$$ = $3 ? $4 : $5;}
    ;

sexpr:
      STRING                                  { $$ = $1; }
    | LPAREN sexpr DOT sexpr RPAREN           { 
        size_t len1 = strlen($2);
        size_t len2 = strlen($4);
        char* result = malloc(len1 + len2 + 1);  // +1 para el '\0'

        if (!result) {
            fprintf(stderr, "Error: no se pudo asignar memoria\n");
            exit(1);
        }

        strcpy(result, $2);
        strcat(result, $4);

        free($2);
        free($4);

        $$ = result;
    }
    | LPAREN IF bexpr sexpr sexpr RPAREN       {
        if ($3) {
            free($5);
            $$ = $4;
        } else {
            free($4);
            $$ = $5;
        }
    }
    ; 


%%
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s archivo.txt\n", argv[0]);
        exit(1);
    }

    FILE *archivo = fopen(argv[1], "r");
    if (!archivo) {
        perror("No se pudo abrir el archivo");
        exit(1);
    }

    yyin = archivo;
    yyparse();
    fclose(archivo);
    return 0;
}
void yyerror(const char *s) {
    fprintf(stderr, "Error de sintaxis: %s\n", s);
}