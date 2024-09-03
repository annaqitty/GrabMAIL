#!/bin/bash

# Define colors and styles
BOLD='\e[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAENTA='\033[0;35m'
LIGHTRED='\033[0;91m'
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'
NC='\033[0m'

header() {
  printf "    ${LIGHTGREEN}       ___ ${NC}\n"
  printf "    ${LIGHTGREEN}     o|* *|o  ╔╦═╦╗╔╦╗╔╦═╦╗ ${NC}\n"
  printf "    ${LIGHTGREEN}     o|* *|o  ║║╔╣╚╝║║║║║║║ ${NC}\n"
  printf "    ${LIGHTGREEN}     o|* *|o  ║║╚╣╔╗║╚╝║╩║║ ${NC}\n"
  printf "    ${LIGHTGREEN}      \===/   ║╚═╩╝╚╩══╩╩╝║ ${NC}\n"
  printf "    ${LIGHTGREEN}       |||    ╚═══════════╝ ${NC}\n"
  printf "    ${LIGHTGREEN}       ||| ${NC}\n"
  printf "    ${LIGHTGREEN}       |||    ╔═╦═╦╦═╦╦═╗╔═╦╦══╦══╦╦╗ ${NC}\n"
  printf "    ${LIGHTGREEN}       |||    ║╩║║║║║║║╩║║╚║╠╗╔╩╗╔╩╗║ ${NC}\n"
  printf "    ${LIGHTGREEN}    ___|||___ ╚╩╩╩═╩╩═╩╩╝╚═╩╝╚╝ ╚╝ ╚╝ ${NC}\n"
}

clear
header

echo ""
echo "__________________________________________________________________________________"
echo ""
echo "GrabMAIL"
echo "Coded By : AnnaQitty ( chua )"
echo "Date     : 28 July 2010"
echo "__________________________________________________________________________________"
echo ""

echo "List of files in this directory: "
echo ""
ls
echo ""
echo "__________________________________________________________________________________"

printf "[+] Email List : ${LIGHTCYAN}"
read emaillist
printf "${NC}"

printf "[+] Result will be saved in: ${LIGHTCYAN}"
read save
printf "${NC}"

printf "[+] Making directory: "
if [[ ! -d "$save" ]]; then
  mkdir -p "$save"
  echo -e "${GREEN}[OK]${NC}"
else
  echo -e "${RED}[ERR]${NC} | ${RED}Directory Already Exists${NC}"
fi
echo ""

# Clean the email list
counter=$(wc -l < "$emaillist")
echo -e "${NC}[+] Total lines: [${LIGHTGREEN}$counter${NC}]"
echo "[+] Cleaning your email list, lowering the word in your list, and removing duplicates email. Please wait ..."

grep -Eiorh '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' "$emaillist" | sort | uniq > temp_list && mv temp_list "$emaillist"
cat "$emaillist" | awk '{print tolower($0)}' | sort | uniq > temp_list && mv temp_list "$emaillist"
sort -u "$emaillist" | uniq > temp_list && mv temp_list "$emaillist"

counter=$(wc -l < "$emaillist")

echo ""
echo "[+] Done ~"
echo ""
echo -e "[+] You have [${LIGHTGREEN}$counter${NC}] email(s)"
echo ""

# Define email families
declare -A families
families=(
  ["Microsoft"]="hotmail live outlook msn windowslive"
  ["Yahoo"]="yahoo ymail btinternet bt rocketmail sky"
  ["Google"]="gmail google googlemail"
  ["Aol"]="aol"
  ["Mail"]="mail gmx"
  ["Sbcglobal"]="sbcglobal"
  ["Bellsouth"]="bellsouth"
  ["Comcast"]="comcast"
  ["Juno"]="juno"
  ["Apple"]="mac apple icloud"
  ["QQ"]="qq"
)

# Define other path and prepare for sorting
otherpath="$save/other_mail.txt"
other_split_path="Other_Split"
mkdir -p "$save/$other_split_path"
cp "$emaillist" "$otherpath"

filter_and_save() {
  local family_name=$1
  local family_list=(${2// / })
  local file_name="$family_name.txt"
  
  echo "[+] Catching $family_name family: "
  echo "[+] I have list: "
  for domain in "${family_list[@]}"; do
    echo "      [-] @$domain.*"
  done
  echo ""
  
  for domain in "${family_list[@]}"; do
    emailtogrep="@$domain."
    printf "      [+] Catching $emailtogrep* : "
    grep "$emailtogrep" "$emaillist" | sort | uniq >> "$save/$file_name"
    grep -v "$emailtogrep" "$otherpath" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$otherpath"
    counter=$(grep -c "$emailtogrep" "$save/$file_name")
    if [[ $counter -ne 0 ]]; then
      printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} caught\n"
    else
      printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
    fi
  done
  
  counter=$(wc -l < "$save/$file_name")
  echo ""
  echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] $family_name Family"
  echo ""
}

# Apply filtering to each family
for family_name in "${!families[@]}"; do
  filter_and_save "$family_name" "${families[$family_name]}"
done

# Handle other emails
echo "[+] Other Mail"
mkdir -p "$save/$other_split_path"

# Define country codes and corresponding file names
declare -A country_codes
country_codes=(
  ["jp"]="Filtered_OTHER-JP.txt"
  ["uk"]="Filtered_OTHER-UK.txt"
  ["de"]="Filtered_OTHER-DE.txt"
  ["fr"]="Filtered_OTHER-FR.txt"
  ["us"]="Filtered_OTHER-US.txt"
  ["ca"]="Filtered_OTHER-CA.txt"
  ["au"]="Filtered_OTHER-AU.txt"
  ["br"]="Filtered_OTHER-BR.txt"
  ["cn"]="Filtered_OTHER-CN.txt"
  ["in"]="Filtered_OTHER-IN.txt"
  ["it"]="Filtered_OTHER-IT.txt"
  ["es"]="Filtered_OTHER-ES.txt"
  ["nl"]="Filtered_OTHER-NL.txt"
  ["ru"]="Filtered_OTHER-RU.txt"
  ["za"]="Filtered_OTHER-ZA.txt"
  ["mx"]="Filtered_OTHER-MX.txt"
  ["kr"]="Filtered_OTHER-KR.txt"
  ["sg"]="Filtered_OTHER-SG.txt"
  ["my"]="Filtered_OTHER-MY.txt"
  ["hk"]="Filtered_OTHER-HK.txt"
  ["tw"]="Filtered_OTHER-TW.txt"
  ["se"]="Filtered_OTHER-SE.txt"
  ["no"]="Filtered_OTHER-NO.txt"
  ["dk"]="Filtered_OTHER-DK.txt"
  ["fi"]="Filtered_OTHER-FI.txt"
  ["pl"]="Filtered_OTHER-PL.txt"
  ["at"]="Filtered_OTHER-AT.txt"
  ["be"]="Filtered_OTHER-BE.txt"
  ["cz"]="Filtered_OTHER-CZ.txt"
  ["gr"]="Filtered_OTHER-GR.txt"
  ["hu"]="Filtered_OTHER-HU.txt"
  ["ie"]="Filtered_OTHER-IE.txt"
  ["lt"]="Filtered_OTHER-LT.txt"
  ["lv"]="Filtered_OTHER-LV.txt"
  ["sk"]="Filtered_OTHER-SK.txt"
  ["si"]="Filtered_OTHER-SI.txt"
  ["pt"]="Filtered_OTHER-PT.txt"
  ["bg"]="Filtered_OTHER-BG.txt"
  ["ro"]="Filtered_OTHER-RO.txt"
  ["hr"]="Filtered_OTHER-HR.txt"
  ["mt"]="Filtered_OTHER-MT.txt"
  ["lu"]="Filtered_OTHER-LU.txt"
  ["is"]="Filtered_OTHER-IS.txt"
  ["bg"]="Filtered_OTHER-BG.txt"
  ["ae"]="Filtered_OTHER-AE.txt"
  ["sa"]="Filtered_OTHER-SA.txt"
  ["kw"]="Filtered_OTHER-KW.txt"
  ["qa"]="Filtered_OTHER-QA.txt"
  ["bh"]="Filtered_OTHER-BH.txt"
  ["om"]="Filtered_OTHER-OM.txt"
  ["jo"]="Filtered_OTHER-JO.txt"
  ["il"]="Filtered_OTHER-IL.txt"
  ["ua"]="Filtered_OTHER-UA.txt"
  ["by"]="Filtered_OTHER-BY.txt"
  ["md"]="Filtered_OTHER-MD.txt"
  ["ge"]="Filtered_OTHER-GE.txt"
  ["kz"]="Filtered_OTHER-KZ.txt"
  ["uz"]="Filtered_OTHER-UZ.txt"
  ["np"]="Filtered_OTHER-NP.txt"
  ["bd"]="Filtered_OTHER-BD.txt"
  ["lk"]="Filtered_OTHER-LK.txt"
  ["pk"]="Filtered_OTHER-PK.txt"
  ["mn"]="Filtered_OTHER-MN.txt"
  ["kh"]="Filtered_OTHER-KH.txt"
  ["la"]="Filtered_OTHER-LA.txt"
  ["mm"]="Filtered_OTHER-MM.txt"
  ["ph"]="Filtered_OTHER-PH.txt"
  ["np"]="Filtered_OTHER-NP.txt"
  ["ws"]="Filtered_OTHER-WS.txt"
  ["fj"]="Filtered_OTHER-FJ.txt"
  ["pg"]="Filtered_OTHER-PG.txt"
  ["vu"]="Filtered_OTHER-VU.txt"
  ["tv"]="Filtered_OTHER-TV.txt"
  ["to"]="Filtered_OTHER-TO.txt"
  ["edu"]="Filtered_OTHER-SCHOOL.txt"
  ["school"]="Filtered_OTHER-SCHOOL.txt"
  ["education"]="Filtered_OTHER-SCHOOL.txt"
  ["com"]="Filtered_OTHER-com.txt"
  ["org"]="Filtered_OTHER-org.txt"
  ["net"]="Filtered_OTHER-net.txt"
  ["gov"]="Filtered_OTHER-gov.txt"
  ["pro"]="Filtered_OTHER-pro.txt"
  ["me"]="Filtered_OTHER-me.txt"
  ["info"]="Filtered_OTHER-info.txt"
  ["site"]="Filtered_OTHER-site.txt"
)

)

# Process and save filtered emails
for code in "${!country_codes[@]}"; do
  output_file="$save/$other_split_path/${country_codes[$code]}"
  grep -E "@[[:alnum:]]+\.$code$" "$otherpath" > "$output_file"
  echo "[+] Filtered emails for country code .$code saved to $output_file"
done

# Define regions and their corresponding country codes
declare -A regions
regions=(
  ["BENUA_ASIA"]="my sg hk tw"
  ["EUROPE"]="uk de fr es it nl pl at be cz gr hu ie lt lv sk si pt bg ro hr mt lu is"
  ["AMERICAS"]="us ca br mx"
  ["AFRICA"]="za dz eg ke ma ng tz ug"
  ["MIDDLE_EAST"]="ae sa kw qa bh om jo il"
  ["SOUTH_ASIA"]="in bd np pk lk"
  ["EAST_ASIA"]="jp kr cn hk tw"
  ["OCEANIA"]="au nz fj pg ws to tv"
  ["SEKOLAH"]="edu school education"
  ["EMAIL_DOMAIN"]="com org net info pro gov site me"
)

# Combine files by regions
for region in "${!regions[@]}"; do
  combined_file="$save/$other_split_path/Combined_OTHER_${region}.txt"
  > "$combined_file"  # Create or empty the file

  for code in ${regions[$region]}; do
    file="$save/$other_split_path/Filtered_OTHER-$code.txt"
    if [[ -f "$file" ]]; then
      cat "$file" >> "$combined_file"
    fi
  done

  echo "[+] Combined emails for region ${region} saved to $combined_file"
done

# Report for combined files
echo "[+] Other Mail (Combined by region)"
for file in "$save/$other_split_path"/Combined_OTHER_*.txt; do
  counter=$(wc -l < "$file")
  echo -e "[+] ${file##*/} contains [${LIGHTGREEN}$counter${NC}] emails"
done

echo ""
echo "[+] Done - COMPLETE & CHECK YOUR EYES"
