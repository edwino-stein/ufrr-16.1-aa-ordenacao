Algoritmos de ordenação

Para compilar e executar basta executar o shellscript run.sh:

    $ chmod +x run.sh
    $ ./run.sh (<algoritmo> | generate <quantidade>) <aquivo>

Onde:

    <algoritmo>: É o algoritmo de ordenação que será utilizado (bubblesort, insertionsort ou selectionsort);
    generate <quantidade>: Gera um arquivo contento <quantidade> de números gerados aleatóriamente;
    <aquivo>: caminho para o arquivo de entrada ou saida;

Exemplo para gerar um arquivo:

    $ ./run.sh generate 100 numeros.txt

Exemplo para ordenar um arquivo:

    $ ./run.sh bubblesort numeros.txt
