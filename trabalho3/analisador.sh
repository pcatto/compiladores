flex scanner.l
bison -d parser.y
gcc -c -o storage.o storage.c
gcc -c -o scanner.o lex.yy.c
gcc -c -o parser.o parser.tab.c
gcc -c -o main.o main.c
gcc -o main storage.o parser.o scanner.o main.o
./main $1