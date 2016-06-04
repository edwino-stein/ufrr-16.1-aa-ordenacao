 #!/bin/sh

buildDir="./build/";
dependencies="sorts/src/bubbleSort.c sorts/src/insertionSort.c sorts/src/selectionSort.c";
invocation="tools/compiler.sh";
main="main";
generate="generate";

chmod +x $invocation;
case $1 in

	"bubblesort")
        invocation="$invocation $main.c $dependencies";
        binaryInvocation="$buildDir$main bubblesort $2";
 	;;

	"insertionsort")
        invocation="$invocation $main.c $dependencies";
        binaryInvocation="$buildDir$main insertionsort $2";
 	;;

	"selectionsort")
        invocation="$invocation $main.c $dependencies";
        binaryInvocation="$buildDir$main selectionsort $2";
 	;;

    "generate")
        invocation="$invocation $generate.c";
        binaryInvocation="$buildDir$generate $2 $3";
    ;;

 	*)
 		echo "Opções: bubblesort | insertionsort | selectionsort | generate."
 		exit 1;
 	;;
esac

echo
echo -e "\t   ######################################################"
echo -e "\t   ######## Compilando e Executando o Aplicativo ########"
echo -e "\t   ######################################################"
echo

bash -c "$invocation";
echo;
bash -c "$binaryInvocation";

exit 0;
