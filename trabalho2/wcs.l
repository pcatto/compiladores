/*  Trabalho de Compiladores                */
/*  Analizador lexico                       */
/*  Professor: Marco Antonio Barbosa        */
/*  Aluno: Patrick Catto                    */

/* just like Unix wc */
%option noyywrap

%{
#include <stdio.h>
#include "y.tab.h"
#include <stdlib.h>
extern int yylval;
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
{int}                   {   return Num      ; }                 
{float}                 {   return Num     ; }                 
verdadeiro              {   return True     ; }                 
falso                   {   return False     ; }                 

            /*Erros*/
[0-9]+[^ \n]+           {   erros++;   printf("---Erro Lexico linha %d---", lines);}

            /*Lexemas e Tokens*/

nao             {   return NAO              ; }    
:=              {   return ATRIB            ; }    
:               {   return DOISP            ; }    
;               {   return PVIRG            ; }    
,               {   return VIRG             ; }    
"."             {   return PONTO            ; }    
[+]             {   return MORE             ; }    
[-]             {   return MINUS            ; }    
ou              {   return OR               ; }
e               {   return AND              ; }    
[*]             {   return TIMES            ; }    
[/]             {   return DIV              ; }    
[=]             {   return EQUAL            ; }    
[<]             {   return SMALL            ; }    
[>]             {   return LARGE            ; }    
"<="            {   return SMALLEQUAL       ; }     
">="            {   return LARGEEQUAL       ; }     
"<>"            {   return DIFFERENT        ; }     
[(]             {   return OPEN             ; }    
[)]             {   return CLOSE            ; }    
Se              {   return IF               ; }    
inteiro         {   return INT              ; }    
real            {   return FLOAT            ; }    
boleano         {   return BOOL             ; }    
inicio          {   return INIT             ; }    
fim             {   return END              ; }    
Senao           {   return ELSE             ; }    
Entao           {   return THEN             ; }    
programa        {   return PROG             ; }    
enquanto        {   return FOR              ; }    
leia            {   return READ             ; }    
escreva         {   return WHITE            ; }    
faca            {   return DO               ; }    
var             {   return VAR              ; }    





            /*comentarios (entre chaves {.....})*/
[{]([^}])*[}]     {   char *s = yytext;
                    for(int i = 0; i < strlen(s); i++)
                        if(s[i] == 10)
                            lines++; } //assim ta contando as linhas abaixo



            /*identificadores (letra seguido de letras ou numeros)*/
{id}    {   return id       ;   }


            /*Espaços em branco*/
\n              {   lines++;    }

            /*outros termos*/
[^(\n\t[:space:])]+     {   erros++;   printf("<ERRO LEXICO, %d>", lines);}
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