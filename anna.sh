#!/bin/bash
 
# GrabMAIL
# Coded By AnnaQitty
 
# text style
 
BOLD='\e[1m'
 
# text color
 
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAENTA='\033[0;35m'
 
LIGHTRED='\033[0;91m'
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'
 
# background color
 
BACKGREEN='\033[0;42m'
BACKBLUE='\033[0;44m'
 
# no style
 
NC='\033[0m'
 
 
header(){
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
 
#-----
clear
header
#-----
 
echo ""
echo "__________________________________________________________________________________"
echo ""
echo "GrabMAIL"
echo "Coded By : AnnaQitty ( chua )"
echo "Date     : 28 July 2010"
echo "__________________________________________________________________________________"
echo ""
 
# end of banyol
 
echo "List of file on this directory : "
echo ""
 
ls
 
echo ""
echo "__________________________________________________________________________________"
 
# ---
 
echo ""
printf "[+] Email List : ${LIGHTCYAN}"
read emaillist
printf "${NC}"
# ---
 
printf "[+] Result will save in : ${LIGHTCYAN}"
read save
printf "${NC}"
 
# ---
 
printf "[+] Making directory : "
 
if [[ ! -d "$save" ]]; then
  mkdir $save
  echo -e "${GREEN}[OK]${NC}"
else
  echo -e "${RED}[ERR]${NC} | ${RED}File Already Exists${NC}"
fi
 
echo ""
 
# ---
 
counter=$(wc -l < $emaillist)
echo -e "${NC}[+] Total lines : [${LIGHTGREEN}$counter${NC}]"
echo "[+] Cleaning your email list , lowering the word in your list , and removing duplicates email , Please wait ..."
 
# Code for cleaning email list
grep -Eiorh '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' $emaillist | sort | uniq > temp_list && mv temp_list $emaillist
# Lowering the word
cat $emaillist | awk '{print tolower($0)}' | sort | uniq > temp_list && mv temp_list $emaillist
# Removing duplicates line
sort -u $emaillist | uniq > temp_list && mv temp_list $emaillist
 
counter=$(wc -l < $emaillist)
 
echo ""
echo "[+] Done ~"
echo ""
echo -e "[+] You have [${LIGHTGREEN}$counter${NC}] email"
echo ""
 
# Array list here
 
microsoft_family=( hotmail live outlook msn windowslive )
yahoo_family=( yahoo ymail btinternet bt rocketmail sky )
google_family=( gmail google googlemail )
aol_family=( aol )
mail_family=( mail gmx )
sbcglobal_family=( sbcglobal )
bellsouth_family=( bellsouth )
comcast_family=( comcast )
juno_family=( juno )
apple_family=( mac apple icloud ) 
qq_family=( qq ) 

# Array list here
 
otherpath="other_mail.txt"
cp $emaillist "$save/$otherpath"
 
# ---- GREPING MICROSOFT FAMILY ---- #
 
# ---
 
thispath="microsoft_family.txt"
 
# ---
 
echo "[+] Catch microsoft family : "
echo "[+] I have list : "
for (( i = 0; i < ${#microsoft_family[@]}; i++ )); do
  echo "      [-] @${microsoft_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#microsoft_family[@]}; i++ )); do
  emailtogrep="@${microsoft_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] Microsoft Family"
echo ""
 
# ---- END OF GREPING HOTMAIL FAMILY ---- #
 
#############################
 
# ---- GREPING YAHOO FAMILY ---- #
 
# ---
 
thispath="yahoo_family.txt"
 
# ---
 
echo "[+] Catch yahoo family : "
echo "[+] I have list : "
for (( i = 0; i < ${#yahoo_family[@]}; i++ )); do
  echo "      [-] @${yahoo_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#yahoo_family[@]}; i++ )); do
  emailtogrep="@${yahoo_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] Yahoo Family"
echo ""
 
# ---- END OF GREPING YAHOO FAMILY ---- #
 
#############################
 
# ---- GREPING GOOGLE FAMILY ---- #
 
# ---
 
thispath="google_family.txt"
 
# ---
 
echo "[+] Catch google family : "
echo "[+] I have list : "
for (( i = 0; i < ${#google_family[@]}; i++ )); do
  echo "      [-] @${google_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#google_family[@]}; i++ )); do
  emailtogrep="@${google_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] Google Family"
echo ""
 
# ---- END OF GREPING GOOGLE FAMILY ---- #
 
# ---- GREPING AOL FAMILY ---- #
 
# ---
 
thispath="aol_family.txt"
 
# ---
 
echo "[+] Catch aol family : "
echo "[+] I have list : "
for (( i = 0; i < ${#aol_family[@]}; i++ )); do
  echo "      [-] @${aol_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#aol_family[@]}; i++ )); do
  emailtogrep="@${aol_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] Aol Family"
echo ""
 
# ---- END OF GREPING AOL FAMILY ---- #
 
#############################
 

# ---- GREPING MAIL FAMILY ---- #
 
# ---
 
thispath="mail_family.txt"
 
# ---
 
echo "[+] Catch mail family : "
echo "[+] I have list : "
for (( i = 0; i < ${#mail_family[@]}; i++ )); do
  echo "      [-] @${mail_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#mail_family[@]}; i++ )); do
  emailtogrep="@${mail_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] Mail Family"
echo ""
 
# ---- END OF GREPING MAIL FAMILY ---- #
 
#############################

#############################
 

# ---- GREPING SBCGLOBAL FAMILY ---- #
 
# ---
 
thispath="sbcglobal_family.txt"
 
# ---
 
echo "[+] Catch sbcglobal family : "
echo "[+] I have list : "
for (( i = 0; i < ${#sbcglobal_family[@]}; i++ )); do
  echo "      [-] @${sbcglobal_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#sbcglobal_family[@]}; i++ )); do
  emailtogrep="@${sbcglobal_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] sbcglobal Family"
echo ""
 
# ---- END OF GREPING SBCGLOBAL FAMILY ---- #
 
#############################

#############################
 

# ---- GREPING BELLSOUTH FAMILY ---- #
 
# ---
 
thispath="bellsouth_family.txt"
 
# ---
 
echo "[+] Catch bellsouth family : "
echo "[+] I have list : "
for (( i = 0; i < ${#bellsouth_family[@]}; i++ )); do
  echo "      [-] @${bellsouth_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#bellsouth_family[@]}; i++ )); do
  emailtogrep="@${bellsouth_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] bellsouth Family"
echo ""
 
# ---- END OF GREPING BELLSOUTH FAMILY ---- #
 
#############################

#############################
 

# ---- GREPING COMCAST FAMILY ---- #
 
# ---
 
thispath="comcast_family.txt"
 
# ---
 
echo "[+] Catch comcast family : "
echo "[+] I have list : "
for (( i = 0; i < ${#comcast_family[@]}; i++ )); do
  echo "      [-] @${comcast_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#comcast_family[@]}; i++ )); do
  emailtogrep="@${comcast_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] comcast Family"
echo ""
 
# ---- END OF GREPING COMCAST FAMILY ---- #
 
#############################

#############################
 

# ---- GREPING JUNO FAMILY  ---- #
 
# ---
 
thispath="juno_family.txt"
 
# ---
 
echo "[+] Catch juno family : "
echo "[+] I have list : "
for (( i = 0; i < ${#juno_family[@]}; i++ )); do
  echo "      [-] @${juno_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#juno_family[@]}; i++ )); do
  emailtogrep="@${juno_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] juno Family"
echo ""
 
# ---- END OF GREPING JUNO FAMILY ---- #
 
#############################

#############################
 

# ---- GREPING APPLE FAMILY  ---- #
 
# ---
 
thispath="apple_family.txt"
 
# ---
 
echo "[+] Catch apple family : "
echo "[+] I have list : "
for (( i = 0; i < ${#apple_family[@]}; i++ )); do
  echo "      [-] @${apple_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#apple_family[@]}; i++ )); do
  emailtogrep="@${apple_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] apple Family"
echo ""
 
# ---- END OF GREPING APPLE FAMILY ---- #
 
#############################

#############################
 

# ---- GREPING QQ FAMILY  ---- #
 
# ---
 
thispath="qq_family.txt"
 
# ---
 
echo "[+] Catch qq family : "
echo "[+] I have list : "
for (( i = 0; i < ${#qq_family[@]}; i++ )); do
  echo "      [-] @${qq_family[$i]}.*"
done
echo ""
 
# --- Looping ---- #
 
for (( i = 0; i < ${#qq_family[@]}; i++ )); do
  emailtogrep="@${qq_family[$i]}."
  printf "      [+] Catch $emailtogrep* : "
  cat $emaillist | grep "$emailtogrep" | sort | uniq >> "$save/$thispath"
  cat "$save/$otherpath" | grep -v "$emailtogrep" | sort | uniq > "$save/tmp_other" && mv "$save/tmp_other" "$save/$otherpath"
  counter=$(cat "$save/$thispath" | grep -c "$emailtogrep")
  if [[ $counter != 0 ]]; then
    printf "${GREEN}[OK]${NC} | ${BLUE}$counter${NC} catched\n"
  else
    printf "${RED}[NO]${NC} | There is no ${BLUE}${emailtogrep}*${NC} email\n"
  fi
done
 
# --- Looping ---- #
 
counter=$(wc -l < "$save/$thispath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] qq Family"
echo ""
 
# ---- END OF GREPING QQ FAMILY ---- #
 
#############################

# ---- OTHER MAIL ---- #
 
echo "[+] Other Mail"
 
counter=$(wc -l < "$save/$otherpath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] Other Mail"
echo ""
echo "[+] Done -"
echo ""
 
# ---- OTHER MAIL ----#
