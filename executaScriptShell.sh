#!/bin/bash
media=0
ajuda() {
    echo "Como usar: $0 -l linguagem -a algoritmo -n numero_de_execucoes -t tamanho_entrada"
    exit 1
}

if [ "$#" -eq 0 ] & [ "$1" = "help" >/dev/null ]; then
    ajuda
fi


while getopts "l:a:n:t:" opt; do
    case $opt in
        l)
            linguagem="$OPTARG"
            ;;
        a)
            algoritmo="$OPTARG"
            ;;
        n)
            numero_execucoes="$OPTARG"
            ;;
        t)
            tamanho_entrada="$OPTARG"
            ;;
        
    esac
done


if [ -z "$linguagem" ] || [ -z "$algoritmo" ] || [ -z "$numero_execucoes" ] || [ -z "$tamanho_entrada" ]; then
    echo "Todas as opções são obrigatórias."
    ajuda
fi


echo "______________________________________________________________________________"
echo ""
echo "Ordenando $tamanho_entrada valores $numero_execucoes vezes com o algoritmo $algoritmo sort na linguagem $linguagem."
echo ""
echo "______________________________________________________________________________"


case "$linguagem-$algoritmo" in
    python-bubble)
        for ((i=1; i<=$numero_execucoes; i++)); do
            tempo=$(python3 bubblesort.py $tamanho_entrada)
            echo $tamanho_entrada,$tempo >> python_bubble_$tamanho_entrada.csv
            media=$(echo "$media + $tempo" | bc -l)
            
        done
        ;;
    python-merge)
        for ((i=1; i<=$numero_execucoes; i++)); do
            tempo=$(python3 mergesort.py $tamanho_entrada)
            echo $tamanho_entrada,$tempo >> python_merge_$tamanho_entrada.csv
            media=$(echo "$media + $tempo" | bc -l)
        done
        ;;
    c-bubble)
        gcc bubblesort.c -o bubblec
        for ((i=1; i<=$numero_execucoes; i++)); do
            tempo=$(./bubblec $tamanho_entrada)
            echo $tamanho_entrada,$tempo >> c_bubble_$tamanho_entrada.csv
            media=$(echo "$media + $tempo" | bc -l)
        done
        ;;
    c-merge)
        gcc mergesort.c -o mergec
        for ((i=1; i<=$numero_execucoes; i++)); do
            tempo=$(./mergec $tamanho_entrada)
            echo $tamanho_entrada,$tempo >> c_merge_$tamanho_entrada.csv
            media=$(echo "$media + $tempo" | bc -l)
        done
        ;;
    *)
        echo "Combinação não reconhecida: $linguagem-$algoritmo"
        ;;
esac
media=$(echo "$media / $numero_execucoes" | bc -l) 
echo $tamanho_entrada,$media >> media_"$linguagem"_"$algoritmo".csv




