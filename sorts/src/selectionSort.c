#include "../sorts.h"

void intSelectionSort(int values[], unsigned int length){

    for(int i = 0; i < length; i++){

        for(int j = i + 1; j < length; j++)
            if(values[i] > values[j]) sortSwapInt(&values[i], &values[j]);
    }
}
