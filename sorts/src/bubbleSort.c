#include "../sorts.h"
#include <stdbool.h>

void intBubbleSort(int values[], unsigned int length){

    bool swapped = true;
    int cursor = 0;
    unsigned int bigger = length - 1;

    while(swapped){

        swapped = false;
        cursor = 0;

        while(cursor != bigger){

            if(values[cursor] > values[cursor + 1]){
                sortSwapInt(&values[cursor], &values[cursor + 1]);
                swapped = true;
            }
            cursor++;
        }

        bigger--;
    }
}
