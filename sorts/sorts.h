#if !defined _SORTS_
#define _SORTS_

    #include "header/bubbleSort.h"
    #include "header/selectionSort.h"
    #include "header/insertionSort.h"
    #include "header/quickSort.h"
    #include "header/mergeSort.h"

    #if !defined _SORT_SWAP
        #define _SORT_SWAP
        void sortSwapInt(int *a, int *b);
    #endif

#endif
