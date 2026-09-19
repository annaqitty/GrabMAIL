#!/bin/bash

GrabMAIL

Coded By AnnaQitty

Modified Sep 2026

text style

BOLD='\e[1m'

text color

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAENTA='\033[0;35m'
LIGHTRED='\033[0;91m'
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'

background color

BACKGREEN='\033[0;42m'
BACKBLUE='\033[0;44m'

no style

NC='\033[0m'

header(){
printf "    ${LIGHTGREEN}       ___${NC}\n"
printf "    ${LIGHTGREEN}     o\vert{}* \vert{}o  ╔╦═╦╗╔╦╗╔╦═╦╗ ${NC}\n"
printf "    ${LIGHTGREEN}     o\vert{} \vert{}o  ║║╔╣╚╝║║║║║║║ ${NC}\n"
printf "    ${LIGHTGREEN}     o\vert{} *\vert{}o  ║║╚╣╔╗║╚╝║╩║║ ${NC}\n"
printf "    ${LIGHTGREEN}      ===/   ║╚═╩╝╚╩══╩╩╝║ ${NC}\n"
printf "    ${LIGHTGREEN}       \vert{}\vert{}\vert{}    ╚═══════════╝ ${NC}\n"
printf "    ${LIGHTGREEN}       \vert{}\vert{}\vert{}${NC}\n"
printf "    ${LIGHTGREEN}       \vert{}\vert{}\vert{}    ╔═╦═╦╦═╦╦═╗╔═╦╦══╦══╦╦╗ ${NC}\n"
printf "    ${LIGHTGREEN}       \vert{}\vert{}\vert{}    ║╩║║║║║║╩║║╚║╠╗╔╩╗╔╩╗║ ${NC}\n"
printf "    ${LIGHTGREEN}    \vert{}\vert{}\vert{} ╚╩╩╩═╩╩═╩╩╝╚═╩╝╚╝ ╚╝ ╚╝ ${NC}\n"
}

clear
header
echo ""
echo ""
echo ""
echo "GrabMAIL (Extended Edition)"
echo "Coded By : AnnaQitty ( chua )"
echo ""
echo ""

echo "List of files on this directory : "
echo ""
ls
echo ""
echo "__________________________________________________________________________________"
echo ""

printf "[+] Email List : ${LIGHTCYAN}"
read emaillist
printf "${NC}"

printf "[+] Result will save in directory : ${LIGHTCYAN}"
read save
printf "${NC}"

printf "[+] Making directory : "
if [[ ! -d "$save" ]]; then
mkdir -p "$save"
echo -e "${GREEN}[OK]${NC}"
else
echo -e "${YELLOW}[WARN]${NC} \vert{}${YELLOW}Directory Already Exists. Files may be appended.${NC}"
fi
echo ""

counter=$(wc -l < "$emaillist")
echo -e "${NC}[+] Total lines : [${LIGHTGREEN}$counter${NC}]"
echo "[+] Cleaning your email list, lowering the text, and removing duplicates..."

Code for cleaning email list

grep -Eiorh '([[:alnum:].-]+@[[:alnum:].-]+?.[[:alpha:].]{2,6})' "$emaillist" | tr '[:upper:]' '[:lower:]' | sort | uniq > temp_list && mv temp_list "$emaillist"

counter=$(wc -l < "$emaillist")
echo ""
echo "[+] Done ~"
echo ""
echo -e "[+] You have [${LIGHTGREEN}$counter${NC}] valid, unique emails."
echo ""

=========================================================

EXPANDED GLOBAL EMAIL DOMAIN FAMILIES

=========================================================

microsoft_family=( hotmail.com hotmail.co.uk hotmail.fr hotmail.it hotmail.es hotmail.de hotmail.ca hotmail.com.au hotmail.co.jp hotmail.com.br hotmail.com.mx hotmail.com.ar hotmail.se outlook.com outlook.co.uk outlook.fr outlook.es outlook.de outlook.it outlook.ca outlook.com.au outlook.com.br outlook.jp outlook.in outlook.kr outlook.za outlook.mx live.com live.co.uk live.fr live.it live.de live.ca live.com.au live.com.mx live.in live.cn live.jp live.nl live.se live.be msn.com windowslive.com passport.com office365.com skype.com )
yahoo_family=( yahoo.com yahoo.co.uk yahoo.fr yahoo.de yahoo.it yahoo.es yahoo.ca yahoo.com.au yahoo.co.jp yahoo.co.in yahoo.in yahoo.com.sg yahoo.com.ph yahoo.com.my yahoo.com.tw yahoo.com.hk yahoo.com.br yahoo.com.ar yahoo.com.mx yahoo.com.vn yahoo.co.id ymail.com rocketmail.com sbcglobal.net att.net bellsouth.net btinternet.com sky.com rogers.com pacbell.net flash.net nvbell.net )
google_family=( gmail.com googlemail.com google.com gmail.co.uk gmail.fr gmail.de gmail.it gmail.es gmail.ca )
aol_family=( aol.com aol.co.uk aol.de aol.fr aol.jp aol.it aol.es aol.ca aol.com.au aim.com netscape.net cs.com compuserve.com wmconnect.com )
apple_family=( icloud.com mac.com me.com apple.com )
qq_china_family=( qq.com foxmail.com 163.com 126.com yeah.net sina.com sina.com.cn vip.sina.com sohu.com aliyun.com 139.com 189.cn 21cn.com 188.com )
korea_japan_family=( naver.com daum.net hanmail.net kakao.com nate.com docomo.ne.jp ezweb.ne.jp softbank.ne.jp i.softbank.jp )
cis_russian_family=( mail.ru bk.ru inbox.ru list.ru yandex.ru yandex.com yandex.by yandex.kz yandex.ua ya.ru rambler.ru ukr.net )
european_family=( gmx.de gmx.net gmx.com gmx.at gmx.ch web.de t-online.de freenet.de orange.fr wanadoo.fr sfr.fr neuf.fr free.fr laposte.net aliceadsl.fr bbox.fr libero.it virgilio.it alice.it tin.it tiscali.it wp.pl onet.pl o2.pl interia.pl seznam.cz centrum.cz )
privacy_family=( proton.me protonmail.com protonmail.ch pm.me tutanota.com tutanota.de tutamail.com skiff.com ctemplar.com mailbox.org posteo.de posteo.net )

Function to process a family

process_family() {
local family_name=$1
shift
local arr=("$@")
local thispath="${family_name}.txt"

echo "[+] Catching ${family_name} :"

for domain in "${arr[@]}"; do
    # Extract full emails that match the exact domain
    grep -i "@${domain}$" "$emaillist" >> "$save/$thispath"
    
    local match_count=$(grep -c -i "@${domain}$" "$emaillist")
    if [[ $match_count != 0 ]]; then
        printf "      ${GREEN}[OK]${NC} | ${BLUE}\%-6s${NC} caught for @%s\n" "$match_count" "$domain"
    fi
done

if [[ -f "$save/$thispath" ]]; then
    # Remove duplicates just in case
    sort -u "$save/$thispath" -o "$save/$thispath"
    local final_count=$(wc -l < "$save/$thispath")
    echo -e "\n[+] Finally you have [${LIGHTGREEN}$final_count${NC}] emails in${family_name}"
else
    echo -e "\n[+] Finally you have [${LIGHTGREEN}0${NC}] emails in${family_name}"
    touch "$save/$thispath" # Create empty file to prevent errors later
fi
echo "---------------------------------------------------"


}

Process all families

process_family "microsoft_family" "${microsoft_family[@]}"
process_family "yahoo_family" "${yahoo_family[@]}"
process_family "google_family" "${google_family[@]}"
process_family "aol_family" "${aol_family[@]}"
process_family "apple_family" "${apple_family[@]}"
process_family "qq_china_family" "${qq_china_family[@]}"
process_family "korea_japan_family" "${korea_japan_family[@]}"
process_family "cis_russian_family" "${cis_russian_family[@]}"
process_family "european_family" "${european_family[@]}"
process_family "privacy_family" "${privacy_family[@]}"

---- OTHER MAIL ----

echo "[+] Processing Other Mail (Uncategorized)..."

otherpath="other_mail.txt"

Combine all sorted emails into a temporary file

cat "$save"/*_family.txt \vert{} sort \vert{} uniq > "$save/all_sorted_temp.txt" 2>/dev/null

Extract emails from the main list that are NOT in the sorted temporary file

grep -vxFf "$save/all_sorted_temp.txt" "$emaillist" > "$save/$otherpath"

Clean up the temporary file

rm -f "$save/all_sorted_temp.txt"

counter=$(wc -l < "$save/$otherpath")
echo ""
echo -e "[+] Finally you have [${LIGHTGREEN}$counter${NC}] Uncategorized / Other Mails"
echo ""
echo "[+] Process Completed Successfully!"
echo ""
