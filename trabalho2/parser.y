/*  Trabalho de Compiladores                */
/*  Analizador sintatico                    */
/*  Professor: Marco Antonio Barbosa        */
/*  Aluno: Patrick Catto                    */

%{
/* This is the prologue section. This code goes
on the top of the parser implementation file. */
#include <stdio.h>
extern int yyerror(char *message);
extern int yylex(void);
%}

%token  Num 
        True 
        False
        NAO       
        ATRIB     
        DOISP     
        PVIRG     
        VIRG      
        PONTO     
        MORE      
        MINUS     
        OR        
        AND       
        TIMES     
        DIV       
        EQUAL     
        SMALL     
        LARGE     
        SMALLEQUAL
        LARGEEQUAL
        DIFFERENT 
        OPEN      
        CLOSE     
        IF        
        INT       
        FLOAT     
        BOOL      
        INIT      
        END       
        ELSE      
        THEN      
        PROG      
        FOR       
        READ      
        WRITE     
        DO        
        VAR           
        id

%right  NAO

%left   TIMES
        DIV

%left   MORE
        MINUS

%left   SMALL     
        LARGE     
        SMALLEQUAL
        LARGEEQUAL

%left   EQUAL
        DIFFERENT

%right  ATRIB

%%

programa :              PROG identificador PVIRG bloco {printf("Sintaticamente Correto");}

bloco :                 VAR declaracao INIT comandos END 

declaracao :            nome_var DOISP tipo PVIRG | 
                        nome_var  DOISP tipo PVIRG declaracao

nome_var :              identificador | 
                        identificador VIRG nome_var

tipo :                  INT | 
                        FLOAT | 
                        BOOL

comandos :              comando | 
                        comando PVIRG comandos

comando :               comando_comb |
                        comando_aberto

comando_comb :          IF expressao THEN comando_comb ELSE comando_comb |
                        atribuicao |  
                        enquanto | 
                        leitura | 
                        escrita 

comando_aberto :        IF expressao THEN comando |
                        IF expressao THEN comando_comb ELSE comando_aberto

atribuicao :            identificador ATRIB expressao 

enquanto :              FOR expressao DO comando_comb

leitura :               READ OPEN  identificador CLOSE

escrita :               WRITE OPEN  identificador CLOSE 

expressao :             simples | 
                        simples op_relacional simples

op_relacional :         DIFFERENT | 
                        EQUAL | 
                        SMALL | 
                        LARGE | 
                        SMALLEQUAL | 
                        LARGEEQUAL

simples :               termo operador termo | 
                        termo

operador :              MORE | 
                        MINUS | 
                        OR

termo :                 fator | 
                        fator op fator

op :                    TIMES | 
                        DIV | 
                        AND

fator :                 identificador | 
                        numero | 
                        OPEN expressao CLOSE | 
                        True | 
                        False | 
                        NAO fator

identificador :         id 

numero :                Num

%%

//#include "lex.yy.c"
/*int main(){
    yyparse();
    return(0);
}
void yyerror(const char *s){ printf("\nERROR\n"); }
int yywrap(){ return 1; }*/
