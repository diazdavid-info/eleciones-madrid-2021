#!/bin/bash

#List Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c() {
  exit 0
}

function main() {
  provinces=("02" "03" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" "19" "20" "22" "24" "25" "27" "31" "32" "33" "34" "36" "37" "38" "39" "51" "52" "40" "41" "46" "47" "43" "44" "45" "49" "50" "53" "04" "16" "21" "23" "54" "168" "58" "59" "61" "63" "64" "65" "66" "67" "70" "71" "72" "73" "01" "69" "138" "127" "74" "75" "137" "76" "901" "78" "79" "80" "82" "83" "84" "85" "88" "90" "91" "92" "93" "96" "97" "99" "100" "101" "104" "106" "107" "108" "109" "112" "113" "114" "115" "117" "902" "119" "120" "121" "122" "123" "124" "126" "128" "129" "130" "131" "132" "133" "134" "135" "136" "140" "141" "143" "145" "146" "147" "148" "149" "150" "152" "154" "903" "155" "156" "159" "161" "162" "163" "164" "165" "166" "167" "169" "171" "172" "174" "175" "176" "177" "181" "182" "183")
  for i in "${provinces[@]}"; do
    result=$(curl -s https://rsl00.epimg.net/elecciones/2021/autonomicas/12/28/"$i".xml2)
    city=$(echo "$result" | xmllint --format --xpath '//escrutinio_sitio/nombre_sitio' - | sed -E 's/<nombre_sitio>([^<]*)<\/nombre_sitio>/\1/g')
    percentage=$(echo "$result" | xmllint --format --xpath '//escrutinio_sitio/votos/contabilizados/porcentaje' - | sed -E 's/<porcentaje>([^<]*)<\/porcentaje>/\1/g')
    players_count=$(echo "$result" | xmllint --xpath 'count(//escrutinio_sitio/resultados/partido)' -)

    printf "\nLocalidad: ${greenColour}%s${endColour}, porcentaje de votos: ${redColour}%s${endColour}\n" "${city}" "${percentage}"

    for ((j = 1; j <= $players_count; j++)); do
      player=$(echo "$result" | xmllint --xpath '//escrutinio_sitio/resultados/partido['$j']/nombre' - | sed -E 's/<nombre>([^<]*)<\/nombre>/\1/g')
      player_percentage=$(echo "$result" | xmllint --xpath '//escrutinio_sitio/resultados/partido['$j']/votos_porciento' - | sed -E 's/<votos_porciento>([^<]*)<\/votos_porciento>/\1/g')
      printf "\t${blueColour}%s${endColour} -> ${redColour}%s${endColour}\n" "${player}" "${player_percentage}"
    done

    printf '======%.0s' {1..10}
  done
}

main
