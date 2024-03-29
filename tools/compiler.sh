 #!/bin/sh

#  compiler.sh
#
#  Shellscript para compilar pragramas didaticos em C/C++.
#
#  Versao 3.0
#
#  Created by Edwino Stein on 14/11/14.
#

# Modo de uso: $ ./compiler.sh <prog_Principal> [<dependencia_1> <dependencia_2> <dependencia_n>]

# ************************* Variaveis de Configuração **************************

common=("common/src/stdInput.c" "common/src/stdOutput.c" "common/src/string.c" "common/src/console.c" "common/src/random.c" "common/src/util.c");
forceCommonCompilation=0;

autoExec=0;
showSplash=0;

baseDir='./';
dirBuild="build/";

compilerCfg="tools/compiler.conf";
linkerCfg="tools/linker.conf";
compilerInvocation="gcc -std=c11 -Wall -o {output} -c {input}";
linkerInvocation="gcc -std=c11 -Wall -Werror -o {output} {input}";

tempLogFile="tools/compileTemp.log";
sourceFileExtension=".c";

# ***************************** Variaveis globais ******************************

os='';
distro='';
distroFN='';

ARGS=0;
returnedData='';
error='';
errorDesc='';
warnings=0;
dependencies='';

# ******************************** Sub-rotinas *********************************

function showError(){

    erroType=$1;

    if [ $erroType == "fatal" ]; then

        echo;
        echo "$error";
		echo "********************** DESCRIÇÃO DO ERRO **********************";
		echo -e "$errorDesc";
		echo "***************************************************************";
		echo;
		echo "O processo foi abortado!";
		exit 1;

    else

        echo;
		echo "$error";
		echo "********************** DESCRIÇÃO DO ALERTA **********************";
		echo "$errorDesc";
		echo "*****************************************************************";
		echo;
		warnings=$(($warnings + 1));

    fi
}

#Função verifica o nivel do erro e o exibe na tela
function checkError(){

    code=$1;

    case $code in

        0) # Nenhum erro ocorreu
            return;
        ;;

        1) # Erro durante a compilação ou linkedição
            showError "fatal";
        ;;

        2) # Alerta durante a compilação ou linkedição
            showError "warning";
        ;;

    	3) # O arquivo não foi encontrado para a compilação
            showError "fatal";
     	;;

    	100)
            error="Erro na leitura do arquivo de configuração.";
            errorDesc="$returnedData";
            showError "fatal";
     	;;

    	101)
            error="Erro no processo.";
            errorDesc="Nenhum arquivo foi definido para ser compilado.\nÉ necessário pelo menos o arquivo fonte principal do programa.";
            showError "fatal";
     	;;

        *)
            error="Erro desconhecido.";
            errorDesc="Algum erro desconhecido ocorreu.";
            showError "fatal";
        ;;
    esac
}

function getCfg(){

    key=$1;
    file=$2;

    if [ ! -f "$file" ] ; then
        echo "Não foi possível ler o arquivo \"$file\".";
        echo "O arquivo é inválido ou não existe.";
	    return 100;
	fi

    config=$(cat $file | grep -v "^\s*#" | grep -m 1 "^\s*$key\s*:");

    if [ -z "$config" ]; then
        echo "";
    else
        echo $config | grep -o ":\s*.*" | sed -n -e s/^:\s*//p | sed 's,^ *,,; s, *$,,';
    fi

    return 0;
}

# Função que remove apenas a extensão de um arquivo
function removeExtension(){
    echo ${1} | cut -f1 -d'.';
}

# Função que retorna apenas o nome do arquivo sem extensão
function getFileName(){
	fileName=`basename $1`;
	removeExtension $fileName;
}

# Função que subistitui uma substring por outra
function strReplace(){
    search="$1";
    replace="$2";
    subject="$3";
    echo "${subject/$search/$replace}";
}

# Função que realiza a compilação do codigo fonte em um codigo objeto
function compile(){

    error="";
	errorDesc="";
    local fileName="$(removeExtension $1)$sourceFileExtension";
    local fileTarget=$(getFileName $1);
    local invocation="$compilerInvocation";
    local gccCode;

    # Verifica se o arquivo fonte existe
	if [ ! -f "${baseDir}${fileName}" ] ; then
        error="Erro antes da compilação:";
	    errorDesc="O arquivo \"$baseDir$fileName\" é inválido ou não existe!";
	    return 3;
	fi

    # Remove arquivo objeto antigo, se existir
    if [ -e "${baseDir}${dirBuild}${fileTarget}.o" ] ; then
        rm "${baseDir}${dirBuild}${fileTarget}.o"
    fi

    # Prepara a linha de comando para a compilação
    invocation=$(strReplace "{output}" "${baseDir}${dirBuild}${fileTarget}.o" "$invocation");
    invocation=$(strReplace "{input}" "${baseDir}${fileName}" "$invocation");

    # Salva o log gerado em uma varaivel e remove arquivo temporário
    bash -c "$invocation > $tempLogFile 2>&1";
    gccCode=$?;

    # Salva o arquivo de log gerado em uma varaivel e o remove
    errorDesc=$(<$tempLogFile);
    rm "$tempLogFile";

    #Verifica se ocorreu algum erro
    if [ $gccCode -ne 0 ];  then
		error="Ocorreu algum(s) erro(s) durante a compilação do arquivo \"$fileName\":";
        return 1;

    # Verifica se ocorreu algum alerta
    elif [ -n "$errorDesc" ]; then
        error="Ocorreu algum(s) alerta(s) durante a compilação do arquivo \"$fileName\":";
        return 2;
	fi

    return 0;
}

# ***************************** Programa principal *****************************

if [ $showSplash -eq 1 ]; then
    echo;
    echo " ****** Processo de compilação ******";
fi


# ************* Detecta o sistema operacional *************
os=$(uname -s);
case $os in
	"Darwin")
        distro=$(sw_vers -productName);
        distroFN="$distro $(sw_vers -productVersion)";
 	;;
	"Linux")
        distro=$(lsb_release -si);
        distroFN=$(lsb_release -sd);
 	;;
    *)
        distro="unknown";
        distroFN="unknown";
    ;;
esac


# ************* Pega a configuração do compilador *************
# Verifica se o arquivo existe
if [ -f "$compilerCfg" ] ; then

    # Verifica se existe entrada para a versão espacifica do SO
    returnedData=$(getCfg "$distroFN" "$compilerCfg");
    checkError $?;

    if [ -z "$returnedData" ]; then

        # Verifica se existe entrada para a destribuição do SO
        returnedData=$(getCfg "$distro" "$compilerCfg");
        checkError $?;

        if [ -z "$returnedData" ]; then

            # Verifica se existe entrada para a familia do SO
            returnedData=$(getCfg "$os" "$compilerCfg");
            checkError $?;

            if [ ! -z "$returnedData" ]; then
                #Define a configuração do compilador com base na familia do SO
                compilerInvocation="$returnedData";
            fi

        else
            #Define a configuração do compilador com base na destribuição do SO
            compilerInvocation="$returnedData";
        fi

    else
        #Define a configuração do compilador com base na versão da destribuição do SO
        compilerInvocation="$returnedData";
    fi

fi


# ************* Pega a configuração do linker *************
# Verifica se o arquivo existe
if [ -f "$linkerCfg" ] ; then

    # Verifica se existe entrada para a versão espacifica do SO
    returnedData=$(getCfg "$distroFN" "$linkerCfg");
    checkError $?;

    if [ -z "$returnedData" ]; then

        # Verifica se existe entrada para a destribuição do SO
        returnedData=$(getCfg "$distro" "$linkerCfg");
        checkError $?;

        if [ -z "$returnedData" ]; then

            # Verifica se existe entrada para a familia do SO
            returnedData=$(getCfg "$os" "$linkerCfg");
            checkError $?;

            if [ ! -z "$returnedData" ]; then
                #Define a configuração do compilador com base na familia do SO
                linkerInvocation="$returnedData";
            fi

        else
            #Define a configuração do compilador com base na destribuição do SO
            linkerInvocation="$returnedData";
        fi

    else
        #Define a configuração do compilador com base na versão da destribuição do SO
        linkerInvocation="$returnedData";
    fi

fi


# ************* Verifica se existe pelo menos um argumento *************
if [ $# -le 0 ]; then
    checkError 101;
fi


# ************* Trata os argumentos *************
for i in `seq 1 $#`
do
    eval "ARGS[$i]=\$$i";
done;


# ************* Cria o diretório onde ficarão os binarios, caso nao exista *************
if [ ! -d "$baseDir$dirBuild" ]; then
  echo -n "# Criando diretório para binários em \"$dirBuild\"...";
  mkdir "$baseDir$dirBuild";
  echo " OK"
fi


# ************* Compila as dependencias comum *************
if [ ${#common[@]} -gt 0 ]; then

    if [ $forceCommonCompilation -ne 0 ]; then
        echo "# Forçando a compilação de todas dependências comum!";
    fi

    for i in `seq 0 $((${#common[@]} - 1))`
    do
        # Verifica se existe a necessidade de compilar o arquivo
        returnedData=$(getFileName ${common[$i]});
    	if [ ! -f "${baseDir}${dirBuild}${returnedData}.o" ] || [ $forceCommonCompilation -ne 0 ] ; then

            echo -n "# Compilando a dependência comum \"$(removeExtension ${common[$i]})$sourceFileExtension\"... ";

            compile ${common[$i]};
            returnedData=$?;

            if [ $returnedData -eq 0 ]; then
                echo "OK!";
            elif [ $returnedData -eq 1 ]; then
                echo "Falhou!";
            elif [ $returnedData -eq 3 ]; then
                echo "Falhou!";
            elif [ $returnedData -eq 2 ]; then
                echo "Alerta!";
            fi

            checkError $returnedData;
    	fi

        # Guarda o arquivo objeto
        returnedData=$(getFileName ${common[$i]});
        dependencies="$dependencies ${baseDir}${dirBuild}${returnedData}.o";

    done;
fi


# ************* Percorre os argumentos e compila os arquivos fontes *************
if [ $# -gt 1 ]; then
	for i in `seq 2 $#`
	do
        echo -n "# Compilando o arquivo \"$(removeExtension ${ARGS[$i]})$sourceFileExtension\"... ";

		compile ${ARGS[$i]};
        returnedData=$?;

        if [ $returnedData -eq 0 ]; then
            echo "OK!";
        elif [ $returnedData -eq 1 ]; then
            echo "Falhou!";
        elif [ $returnedData -eq 3 ]; then
            echo "Falhou!";
        elif [ $returnedData -eq 2 ]; then
            echo "Alerta!";
        fi

		checkError $returnedData;

        # Guarda o arquivo objeto
		returnedData=$(getFileName ${ARGS[$i]});
		dependencies="${baseDir}${dirBuild}${returnedData}.o $dependencies";
	done;
fi


# ************* Compila o arquivo fonte do programa principal *************
echo -n "# Compilando o programa principal \"$(removeExtension ${ARGS[1]})$sourceFileExtension\"... ";

compile ${ARGS[1]};
returnedData=$?

if [ $returnedData -eq 0 ]; then
    echo "OK!";
elif [ $returnedData -eq 1 ]; then
    echo "Falhou!";
elif [ $returnedData -eq 3 ]; then
    echo "Falhou!";
elif [ $returnedData -eq 2 ]; then
    echo "Alerta!";
fi

checkError $returnedData;

# Guarda o arquivo objeto
main=$(getFileName ${ARGS[1]});
dependencies="${baseDir}${dirBuild}${main}.o $dependencies";


# ************* Linkedição do programa *************
echo -n "# Montando binário \"${dirBuild}${main}\"... ";

# Remove arquivo binário antigo, se existir
if [ -e "${baseDir}${dirBuild}${main}" ] ; then
    rm "${baseDir}${dirBuild}${main}"
fi

# Prepara a linha de comando para a linkedição
linkerInvocation=$(strReplace "{output}" "${baseDir}${dirBuild}${main}" "$linkerInvocation");
linkerInvocation=$(strReplace "{input}" "$dependencies" "$linkerInvocation");

# Executa a linkedição
bash -c "$linkerInvocation > $tempLogFile 2>&1";
returnedData=$?

# Salva o log gerado em uma varaivel e remove arquivo temporário
errorDesc='';
errorDesc=$(<$tempLogFile);
rm "$tempLogFile";

#Verifica se ocorreu algum erro
if [ $returnedData -ne 0 ];  then
    returnedData=1;
    error="Ocorreu algum(s) erro(s) durante a linkedição do programa \"${dirBuild}${main}\":";
# Verifica se ocorreu algum alerta
elif [ -n "$errorDesc" ]; then
    returnedData=2;
    error="Ocorreu algum(s) alerta(s) durante a linkedição do programa \"${dirBuild}${main}\":";
fi

if [ $returnedData -eq 0 ]; then
    echo "OK!";
elif [ $returnedData -eq 1 ]; then
    echo "Falhou!";
elif [ $returnedData -eq 2 ]; then
    echo "Alerta!";
fi

checkError $returnedData;


# ************* Analiza se ocorreu aletas *************
if [ $warnings -ne 0 ];  then
	echo -n "# Ocorreu(ram) $warnings alerta(s) no processo! ";
else
	echo "# Não houve erros durante durante o processo!";
fi


# ************* Executa o programa se possivel *************
if [ $autoExec -ne 0 ] ; then

	if [ $warnings -ne 0 ];  then
		echo -n "Precione enter para continuar...";
		read KEY;
	fi

	echo "# Executando \"${dirBuild}${main}\"...";
	sleep 1s;
    echo;

    # Executa o programa
    chmod +x "${baseDir}${dirBuild}${main}"
	bash -c "${baseDir}${dirBuild}${main}";
fi

exit 0;
