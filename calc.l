%{
#include "calc.tab.h"
%}

digit   [0-9]

%%


"\\true"          { yylval.bval = 1; return BOOLEAN; }
"\\false"         { yylval.bval = 0; return BOOLEAN; }
"\\if"            { return IF; }
"\\not"           { return NOT; }
"\\and"           { return AND; }

{digit}+        { yylval.ival = atoi(yytext); return NUMBER; }



"+"             { return PLUS; }
"*"             { return TIMES; }
"("             { return LPAREN; }
")"             { return RPAREN; }
"<"               { return LESS; }
"="               { return EQ; }
"."               { return DOT; }
"|"               { return PIPE; }
\n              { return '\n'; } 

[ \t]+        { /* Ignorar espacios */ }


[a-zA-Z_][a-zA-Z0-9_]* {
                    yylval.sval = strdup(yytext);
                    return STRING;
                  }



.  {
    printf("Error léxico: carácter inesperado '%s' (ASCII: %d)\n", yytext, yytext[0]);
}

%%
int yywrap() { return 1; }