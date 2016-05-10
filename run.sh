 #!/bin/sh

dependencies="sorts/src/sorts.c sorts/src/bubbleSort.c sorts/src/insertionSort.c sorts/src/selectionSort.c";
invocation="tools/compiler.sh main.c";
binaryInvocation="./build/main";

case $1 in

	"bubblesort")
 		echo "bubblesort";
 	;;

	"insertionsort")
 		echo "insertionsort";
 	;;

	"selectionsort")
 		echo "selectionsort";
 	;;

 	*)
 		echo "Opções: bubblesort | insertionsort | selectionsort."
 		exit 1;
 	;;
esac

echo
echo -e "\t   ######################################################"
echo -e "\t   ######## Compilando e Executando o Aplicativo ########"
echo -e "\t   ######################################################"
echo

bash -c "$invocation $dependencies";
echo;
bash -c "$binaryInvocation $1 $2";

exit 0;
