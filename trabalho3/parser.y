/*  Trabalho de Compiladores                */
/*  Analizador sintatico                    */
/*  Professor: Marco Antonio Barbosa        */
/*  Aluno: Patrick Catto                    */




%{
/* This is the prologue section. This code goes
on the top of the parser implementation file. */
#include <stdio.h>
#include <string.h>
#include "storage.h"
extern int yyerror(char *message);
extern int yylex(void);
Storage *storage;
%}



%union{
        int value;
        char* lex_value;
}

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



%type <value> numero fator termo simples expressao identificador

%start programa


%%

programa :              PROG identificador PVIRG bloco                          {       clearStorage(storage);}

bloco :                 VAR declaracao INIT comandos END 

declaracao :            nome_var DOISP tipo PVIRG 
                        | 
                        nome_var  DOISP tipo PVIRG declaracao

nome_var :              identificador                                           {}
                        | 
                        identificador VIRG nome_var

tipo :                  INT 
                        | 
                        FLOAT 
                        | 
                        BOOL

comandos :              comando 
                        | 
                        comando PVIRG comandos

comando :               comando_comb 
                        |
                        comando_aberto

comando_comb :          IF expressao THEN comando_comb ELSE comando_comb 
                        |
                        atribuicao 
                        |  
                        enquanto 
                        | 
                        leitura 
                        | 
                        escrita 

comando_aberto :        IF expressao THEN comando 
                        |
                        IF expressao THEN comando_comb ELSE comando_aberto

atribuicao :            identificador ATRIB expressao                           {       
                                                                                        if(isEmpty(storage)){
                                                                                                storage = createStorage();
                                                                                        }
                                                                                        insertBox(storage, $<lex_value>1, $<value>3);
                                                                                }

enquanto :              FOR expressao DO comando_comb

leitura :               READ OPEN  identificador CLOSE

escrita :               WRITE OPEN  identificador CLOSE                         {       printf("\n%d\n", getValue(storage, $<lex_value>3));}

expressao :             simples                                                 {       $<value>$ = $<value>1;}
                        | 
                        simples op_relacional simples                           {}

op_relacional :         DIFFERENT 
                        | 
                        EQUAL 
                        | 
                        SMALL 
                        | 
                        LARGE 
                        | 
                        SMALLEQUAL 
                        | 
                        LARGEEQUAL

simples :               termo operador termo                                    {       if(strcmp($<lex_value>2, "+") == 0){
                                                                                                $<value>$ = $<value>1 + $<value>3;
                                                                                                //printf("%d = %d + %d\n", $<value>$, $<value>1, $<value>3);
                                                                                        }else if(strcmp($<lex_value>2, "-") == 0){
                                                                                                $<value>$ = $<value>1 - $<value>3;
                                                                                                //printf("%d = %d - %d\n", $<value>$, $<value>1, $<value>3);
                                                                                        }
                                                                                }
                        | 
                        termo                                                   {       $<value>$ = $<value>1;}

operador :              MORE                                                    {}
                        | 
                        MINUS                                                   {}
                        | 
                        OR

termo :                 fator                                                   {       $<value>$ = $<value>1;}
                        | 
                        fator op fator                                          {       if(strcmp($<lex_value>2, "*") == 0){
                                                                                                $<value>$ = $<value>1 * $<value>3;
                                                                                                //printf("%d = %d * %d\n", $<value>$, $<value>1, $<value>3);
                                                                                        }else if(strcmp($<lex_value>2 , "/") == 0){
                                                                                                $<value>$ = $<value>1 / $<value>3;
                                                                                                //printf("%d = %d / %d\n", $<value>$, $<value>1, $<value>3);
                                                                                        }
                                                                                }

op :                    TIMES                                                   {}
                        | 
                        DIV                                                     {}
                        | 
                        AND

fator :                 identificador                                           {       $<value>$ = getValue(storage, $<lex_value>1);}
                        | 
                        numero                                                  {       $<value>$ = $<value>1;}
                        | 
                        OPEN expressao CLOSE                                    {       $<value>$ = $<value>2;}
                        | 
                        True                                                    {}
                        | 
                        False                                                   {}
                        | 
                        NAO fator                                               {}

identificador :         id                                                      {}


numero :                Num                                                     {       $<value>$ = $<value>1;}

%%

//#include "lex.yy.c"
/*int main(){
    yyparse();
    return(0);
}
void yyerror(const char *s){ printf("\nERROR\n"); }
int yywrap(){ return 1; }*/
