#include "common/common.h"
#include "sorts/sorts.h"

#define MAX_BUFFER 10000

int readFile(String fileName, int data[], int bufferMax);
bool writeFile(String fileName, int data[], int size);

int main(int argc, char *argv[]){

    if(argc == 1){
        printLn("Algoritmo inálido!");
        printLn("Algoritmos: bubblesort, insertionsort ou selectionsort.");
        return 1;
    }

    if(argc == 2){
        printLn("Arquivo inálido!");
        printLn("Informe o caminho de um arquivo válido.");
        return 1;
    }

    String algorithm = newString(argv[1]);
    String fileName = newString(argv[2]);
    int data[MAX_BUFFER];
    int size = readFile(fileName, data, MAX_BUFFER);

    if(size <= 0){
        printLn("Arquivo inálido!");
        printLn("Informe o caminho de um arquivo válido.");
        deleteString(algorithm);
        deleteString(fileName);
        return 1;
    }

    if(cStrIsEqual(algorithm, "bubblesort")){
        intBubbleSort(data, size);
    }
    else if(cStrIsEqual(algorithm, "insertionsort")){
        intInsertionSort(data, size);
    }
    else if(cStrIsEqual(algorithm, "selectionsort")){
        intSelectionSort(data, size);
    }
    else{
        printLn("Algoritmo inálido!");
        printLn("Algoritmos: bubblesort, insertionsort ou selectionsort.");
        deleteString(algorithm);
        deleteString(fileName);
        return 1;
    }

    concatenateCString(algorithm, ".txt");
    if(writeFile(algorithm, data, size)){
        printf("O resultado foi gravado no arquivo \"%s\".\n", getCStr(algorithm));
    }
    else{
        print("Erro ao gravar o arquivo com os resultados.");
    }

    deleteString(algorithm);
    deleteString(fileName);
    return 0;
}

int readFile(String fileName, int data[], int bufferMax){

    int i, count = 0;
    FILE * file;
    file = fopen (getCStr(fileName) , "r");

    if (file == NULL){
        return -1;
    }

    do{
        fscanf(file, "%d", &i);
        data[count++] = i;
        if(count > bufferMax) break;

    }while (!feof(file));

    fclose(file);
    return count - 1;
}

bool writeFile(String fileName, int data[], int size){

    FILE * file;
    int countLine = 0;

    file = fopen (getCStr(fileName) , "w+");

    if (file == NULL){
        return false;
    }

    for(int i = 0; i < size; i++){

        countLine++;
        fprintf(file, "%d ", data[i]);

        if(countLine >= 30){
            fprintf(file, "\n");
            countLine = 0;
        }
    }

    fclose(file);
    return true;
}
