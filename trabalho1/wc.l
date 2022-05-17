/*  Trabalho de Compiladores                */
/*  Analizador lexico                       */
/*  Professor: Marco Antonio Barbosa        */
/*  Aluno: Patrick Catto                    */

/* just like Unix wc */
%option noyywrap

%{
#include <stdio.h>
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
{int}                   {   printf("<Num, %d>", lines);}
{float}                 {   printf("<NumF, %d>", lines);}
verdadeiro              {   printf("<Bool, %d>", lines);   }
falso                   {   printf("<Bool, %d>", lines);   }

            /*Erros*/
[0-9]+[^ \n]+           {   erros++;   printf("---Erro Lexico linha %d---", lines);}

            /*Lexemas e Tokens*/

:=              {   printf("<ATRIB, %d>", lines);   }
:               {   printf("<DOISP, %d>", lines);   }
;               {   printf("<PVIRG, %d>", lines);   }
,               {   printf("<VIRG, %d>", lines);   }
"."             {   printf("<PONTO, %d>", lines);   }
[+]             {   printf("<MORE, %d>", lines);   }
[-]             {   printf("<MINUS, %d>", lines);   }
[*]             {   printf("<TIMES, %d>", lines);   }
[/]             {   printf("<DIV, %d>", lines);   }
[=]             {   printf("<EQUAL, %d>", lines);   }
[<]             {   printf("<SMALL, %d>", lines);   }
[>]             {   printf("<LARGE, %d>", lines);   }
"<="            {   printf("<SMALLEQUAL, %d>", lines);   }
">="            {   printf("<LARGEEQUAL, %d>", lines);   }
"<>"            {   printf("<DIFFERENT, %d>", lines);   }
[(]             {   printf("<OPEN, %d>", lines);   }
[)]             {   printf("<CLOSE, %d>", lines);   }
Se              {   printf("<IF, %d>", lines);   }
inteiro         {   printf("<INT, %d>", lines);   }
real            {   printf("<FLOAT, %d>", lines);   }
boleano         {   printf("<BOOL, %d>", lines);   }
inicio          {   printf("<INIT, %d>", lines);   }
fim             {   printf("<END, %d>", lines);   }
Senao           {   printf("<ELSE, %d>", lines);   }
Entao           {   printf("<THEN, %d>", lines);   }
programa        {   printf("<PROG, %d>", lines);   }
enquanto        {   printf("<FOR, %d>", lines);   }
leia            {   printf("<READ, %d>", lines);   }
escreva         {   printf("<WHITE, %d>", lines);   }
faca            {   printf("<DO, %d>", lines);   }
var             {   printf("<VAR, %d>", lines);   }





            /*comentarios (entre chaves {.....})*/
[{]([^}])*[}]     {   char *s = yytext;
                    for(int i = 0; i < strlen(s); i++)
                        if(s[i] == 10)
                            lines++; } //assim nao ta contando as linhas abaixo



            /*identificadores (letra seguido de letras ou numeros)*/
{id}    {   printf("<id , %d >" , lines);   }


            /*Espaços em branco*/
\n              {   lines++; printf("\n");    }

            /*outros termos*/
[^(\n\t[:space:])]+     {   erros++;   printf("<ERRO, %d>", lines);}
%%

int main(int argc, char **argv)
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
    
}