#include "../sorts.h"

void intInsertionSort(int values[], unsigned int length){

    int temp, i, j;

    for(i = 0; i < length; i++){

        temp = values[i];
        j = i - 1;

        while(j >= 0 && temp < values[j]){
            values[j + 1] = values[j];
            j--;
        }

        values[j + 1] = temp;
    }
}
