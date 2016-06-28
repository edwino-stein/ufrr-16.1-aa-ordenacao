#include "../sorts.h"

void _intQuickSort(int values[], int start, int length){

    int pivot = values[(start + length)/2];

    int lBound = start;
    int rBound = length;

    while(lBound <= rBound){

        while(lBound < length && values[lBound] < pivot) lBound++;
        while(rBound > start && values[rBound] > pivot) rBound--;

        if(lBound <= rBound){
            sortSwapInt(&values[lBound], &values[rBound]);
            lBound++;
            rBound--;
        }
    }

    if(rBound > start) _intQuickSort(values, start, rBound);
    if(lBound < length) _intQuickSort(values, lBound, length);
}
