#include "../sorts.h"
#include <stdlib.h>

#define newArray(type, length) (type *) malloc(sizeof(type) * length)

void mergeIntMergeSort(int values[], int start, int length, int pivot){

    int lBranchLen = pivot - start + 1,
        rBranchLen = length - pivot,
        *lBranch, *rBranch, i, j, cursor;

    lBranch = newArray(int, lBranchLen);
    for(i = 0; i < lBranchLen; i++) lBranch[i] = values[start + i];

    rBranch = newArray(int, rBranchLen);
    for(i = 0; i < rBranchLen; i++) rBranch[i] = values[pivot + i + 1];

    for(i = 0, j = 0, cursor = start; cursor <= length; cursor++){

        if(i == lBranchLen) values[cursor] = rBranch[j++];                      //Caso não tenha mais valores no branch da esquerda
        else if(j == rBranchLen) values[cursor] = lBranch[i++];                 //Caso não tenha mais valores no branch da direita
        else if(lBranch[i] < rBranch[j]) values[cursor] = lBranch[i++];         //Caso o valor da esquerda seja menor que o da direita
        else values[cursor] = rBranch[j++];                                     //Caso o valor da direita seja menor que o da esquerda
    }

    free(lBranch);
    free(rBranch);
}

void branchIntMergeSort(int values[], int start, int length){

    if(start == length) return;
    int pivot = (start + length)/2;

    branchIntMergeSort(values, start, pivot);
    branchIntMergeSort(values, pivot + 1, length);

    mergeIntMergeSort(values, start, length, pivot);
}

void _intMergeSort(int values[], int start, int length){
    branchIntMergeSort(values, start, length - 1);
}
