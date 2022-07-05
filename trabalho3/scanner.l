/*  Trabalho de Compiladores                */
/*  Analizador lexico                       */
/*  Professor: Marco Antonio Barbosa        */
/*  Aluno: Patrick Catto                    */

/* just like Unix wc */

%option header-file="lex.yy.h"
%option noyywrap

%top{
/* This goes at the top of the generated file */
#include "parser.tab.h"
}

%{
#include <stdio.h>
#include "parser.tab.h"
#include <stdlib.h>
extern YYSTYPE yylval;
#include <string.h>


int erros = 0;
int lines = 1;
int space = 0;
%}

id [a-zA-Z_][a-zA-Z0-9_]*
int "-"?[0-9]+ 
float {int}"."[0-9]+

%%



            /*tipos (inteiro, real e booleano)*/
{int}                   {   yylval.value = atoi(yytext)     ;
                            return Num                      ; }                 
{float}                 {   return Num                      ; }                 
verdadeiro              {   return True                     ; }                 
falso                   {   return False                    ; }                 

            /*Erros*/
[0-9]+[^ \n]+           {   erros++;   printf("\nError: lexical error");} /* line %d", lines*/

            /*Lexemas e Tokens*/

nao             {   return NAO                          ; }    
:=              {   return ATRIB                        ; }    
:               {   return DOISP                        ; }    
;               {   return PVIRG                        ; }    
,               {   return VIRG                         ; }    
"."             {   return PONTO                        ; }    
[+]             {   yylval.lex_value = strdup(yytext)   ;
                    return MORE                         ; }    
[-]             {   yylval.lex_value = strdup(yytext)   ;
                    return MINUS                        ; }    
ou              {   return OR                           ; }
e               {   return AND                          ; }    
[*]             {   yylval.lex_value = strdup(yytext)   ;
                    return TIMES                        ; }    
[/]             {   yylval.lex_value = strdup(yytext)   ;
                    return DIV                          ; }    
[=]             {   return EQUAL                        ; }    
[<]             {   return SMALL                        ; }    
[>]             {   return LARGE                        ; }    
"<="            {   return SMALLEQUAL                   ; }     
">="            {   return LARGEEQUAL                   ; }     
"<>"            {   return DIFFERENT                    ; }     
[(]             {   return OPEN                         ; }    
[)]             {   return CLOSE                        ; }    
se              {   return IF                           ; }    
inteiro         {   return INT                          ; }    
real            {   return FLOAT                        ; }    
boleano         {   return BOOL                         ; }    
inicio          {   return INIT                         ; }    
fim             {   return END                          ; }    
senao           {   return ELSE                         ; }    
entao           {   return THEN                         ; }    
programa        {   return PROG                         ; }    
enquanto        {   return FOR                          ; }    
leia            {   return READ                         ; }    
escreva         {   return WRITE                        ; }    
faca            {   return DO                           ; }    
var             {   return VAR                          ; }    





            /*comentarios (entre chaves {.....})*/
[{]([^}])*[}]     {   char *s = yytext;
                    for(int i = 0; i < strlen(s); i++)
                        if(s[i] == 10)
                            lines++; } //assim ta contando as linhas abaixo



            /*identificadores (letra seguido de letras ou numeros)*/
{id}    {   yylval.lex_value = strdup(yytext)   ;
            return id                           ;   }


            /*Espaços em branco*/
\n              {   lines++;    }

            /*outros termos*/
[^(\n\t[:space:])]+     {   erros++;   printf("\nError: lexical error");} /* line %d", lines*/
%%

/*int main(int argc, char **argv)
{

    char *fileName = argv[1];
    FILE *file = fopen(fileName, "r");


    if(!file){
        printf("Arquivo não encontrado");
        return -1;
    }

    yyin = file;

    yylex();
    
    printf("\n\nlinhas %d\terros %d\n", lines, erros);

    fclose(file);
    
}*/