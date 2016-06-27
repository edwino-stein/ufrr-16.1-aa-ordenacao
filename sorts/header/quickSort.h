#if !defined _QUICKSORT_
#define _QUICKSORT_
    void _intQuickSort(int values[], int start, int length);
    #define intQuickSort(v, l) _intQuickSort(v, 0, l - 1);
#endif
