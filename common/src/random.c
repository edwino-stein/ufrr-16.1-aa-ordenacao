#include "../common.h"
#include <time.h>

int randInt(int maxValue){

    static unsigned int currentSeed;
    unsigned int seed = (unsigned) time(NULL);

    //Assegura que a seed não sera igual a ultima seed utilizada
    if(currentSeed == seed){
        seed += (rand() % seed) * 2 ;
    }
    else{
        currentSeed = seed;
    }

    srand(seed);

    if(maxValue <= 0){
        return rand();
    }

    return rand() % (maxValue + 1);
}

double randDouble(){
    int i, j;

    do{
        i = randInt(100);
        j = randInt(200);
    }while( (i == j) || (j == 0) );

    return ((double) i)/((double) j);
}

char randChar(char maxChar, bool printableOnly){

    char c;
    char minChar = 0;

    if(printableOnly){
        minChar = 33;
    }

    if((maxChar <= minChar) || (maxChar >= 127)){
        maxChar = 126;
    }

    do{
        c = randInt(maxChar);
    }while(c < minChar || c > maxChar);

    return c;
}

bool randBool(){
  return (randInt(99) % 2 == 0);
}
