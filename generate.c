#include "common/common.h"

bool writeFile(String fileName, int data[], int size);

int main(int argc, char *argv[]){

    if(argc == 1){
        printLn("Quantidade inválida!");
        printLn("Informe a quandidade de números que serão gravados no arquivo.");
        return 1;
    }

    if(argc == 2){
        printLn("Arquivo inálido!");
        printLn("Informe o caminho de um arquivo válido.");
        return 1;
    }

    int size = atoi(argv[1]);
    if(size <= 0){
        printLn("Quantidade inválida!");
        printLn("Informe a quandidade de números que serão gravados no arquivo.");
        return 1;
    }

    int data[size];
    for(int i = 0; i < size; i++)
        data[i] = randInt(size);

    String fileName = newString(argv[2]);
    if(writeFile(fileName, data, size)){
        printf("O arquivo \"%s\" foi gerado contendo %d números aleatórios.\n", getCStr(fileName), size);
    }
    else{
        print("Erro ao gravar o arquivo com os resultados.");
    }

    deleteString(fileName);
    return 0;
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
