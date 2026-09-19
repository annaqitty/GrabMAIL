#!/bin/bash

# ============================================================
# GrabMAIL - Extended Edition
# Fast Single-Pass Version
# Coded By : AnnaQitty (chua)
# Modified : Sep 2026
# ============================================================

BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'
NC='\033[0m'

# ============================================================
# Header
# ============================================================

header() {
    printf "${LIGHTGREEN}"
    cat <<'EOF'
       ___
     o     o   ╔╦═╦╗╔╦╗╔╦═╦╗
     o     o   ║║╔╣╚╝║║║║║║║
     o     o   ║║╚╣╔╗║╚╝║╩║║
      ===/     ║╚═╩╝╚╩══╩╩╝║
       |||     ╚═══════════╝
       |||
       |||     ╔═╦═╦╦═╦╦═╗╔═╦╦══╦══╦╦╗
       |||     ║╩║║║║║║╩║║╚║╠╗╔╩╗╔╩╗║
    |||        ╚╩╩╩═╩╩═╩╩╝╚═╩╝╚╝ ╚╝ ╚╝
EOF
    printf "${NC}\n"
}

clear
header

printf "\n"
printf "${BOLD}${LIGHTGREEN}GrabMAIL (Extended Edition)${NC}\n"
printf "${LIGHTCYAN}Coded By : AnnaQitty ( chua )${NC}\n\n"

printf "${BLUE}List of files on this directory:${NC}\n\n"
ls
printf "\n"

printf '%*s\n' 82 '' | tr ' ' '_'
printf "\n"

# ============================================================
# Input
# ============================================================

printf "[+] Email List : ${LIGHTCYAN}"
read -r emaillist
printf "${NC}"

if [[ ! -f "$emaillist" ]]; then
    printf "${RED}[ERROR] File not found: %s${NC}\n" "$emaillist"
    exit 1
fi

printf "[+] Result will save in directory : ${LIGHTCYAN}"
read -r save
printf "${NC}"

if [[ -z "$save" ]]; then
    printf "${RED}[ERROR] Output directory cannot be empty.${NC}\n"
    exit 1
fi

printf "[+] Making directory : "

if [[ ! -d "$save" ]]; then
    mkdir -p "$save"
    printf "${GREEN}[OK]${NC}\n"
else
    printf "${YELLOW}[WARN] Directory Already Exists. Replacing result files.${NC}\n"
fi

printf "\n"

# ============================================================
# Clean input
# ============================================================

counter=$(wc -l < "$emaillist")

printf "[+] Total lines : [${LIGHTGREEN}%s${NC}]\n" "$counter"
printf "[+] Cleaning email list...\n"

tmp_file=$(mktemp)

LC_ALL=C grep -Eioh \
    '([[:alnum:]_.-]+@[[:alnum:]-]+(\.[[:alnum:]-]+)+)' \
    "$emaillist" |
    LC_ALL=C tr '[:upper:]' '[:lower:]' |
    LC_ALL=C sort -u > "$tmp_file"

mv "$tmp_file" "$emaillist"

counter=$(wc -l < "$emaillist")

printf "[+] Done ~\n"
printf "[+] Valid unique emails : [${LIGHTGREEN}%s${NC}]\n\n" "$counter"

# ============================================================
# Domain -> Family map
# ============================================================

declare -A DOMAIN_FAMILY

add_family() {
    local family="$1"
    shift

    local domain

    for domain in "$@"; do
        DOMAIN_FAMILY["$domain"]="$family"
    done
}

microsoft_family=(
    hotmail.com hotmail.co.uk hotmail.fr hotmail.it hotmail.es
    hotmail.de hotmail.ca hotmail.com.au hotmail.co.jp
    hotmail.com.br hotmail.com.mx hotmail.com.ar hotmail.se
    outlook.com outlook.co.uk outlook.fr outlook.es outlook.de
    outlook.it outlook.ca outlook.com.au outlook.com.br outlook.jp
    outlook.in outlook.kr outlook.za outlook.mx
    live.com live.co.uk live.fr live.it live.de live.ca
    live.com.au live.com.mx live.in live.cn live.jp live.nl
    live.se live.be msn.com windowslive.com passport.com
    office365.com skype.com
)

yahoo_family=(
    yahoo.com yahoo.co.uk yahoo.fr yahoo.de yahoo.it yahoo.es
    yahoo.ca yahoo.com.au yahoo.co.jp yahoo.co.in yahoo.in
    yahoo.com.sg yahoo.com.ph yahoo.com.my yahoo.com.tw
    yahoo.com.hk yahoo.com.br yahoo.com.ar yahoo.com.mx
    yahoo.com.vn yahoo.co.id ymail.com rocketmail.com
    sbcglobal.net att.net bellsouth.net btinternet.com sky.com
    rogers.com pacbell.net flash.net nvbell.net
)

google_family=(
    gmail.com googlemail.com google.com gmail.co.uk
    gmail.fr gmail.de gmail.it gmail.es gmail.ca
)

aol_family=(
    aol.com aol.co.uk aol.de aol.fr aol.jp aol.it aol.es
    aol.ca aol.com.au aim.com netscape.net cs.com
    compuserve.com wmconnect.com
)

apple_family=(
    icloud.com mac.com me.com apple.com
)

qq_china_family=(
    qq.com foxmail.com 163.com 126.com yeah.net sina.com
    sina.com.cn vip.sina.com sohu.com aliyun.com 139.com
    189.cn 21cn.com 188.com
)

korea_japan_family=(
    naver.com daum.net hanmail.net kakao.com nate.com
    docomo.ne.jp ezweb.ne.jp softbank.ne.jp i.softbank.jp
)

cis_russian_family=(
    mail.ru bk.ru inbox.ru list.ru yandex.ru yandex.com
    yandex.by yandex.kz yandex.ua ya.ru rambler.ru ukr.net
)

european_family=(
    gmx.de gmx.net gmx.com gmx.at gmx.ch web.de t-online.de
    freenet.de orange.fr wanadoo.fr sfr.fr neuf.fr free.fr
    laposte.net aliceadsl.fr bbox.fr libero.it virgilio.it
    alice.it tin.it tiscali.it wp.pl onet.pl o2.pl interia.pl
    seznam.cz centrum.cz
)

privacy_family=(
    proton.me protonmail.com protonmail.ch pm.me
    tutanota.com tutanota.de tutamail.com skiff.com
    ctemplar.com mailbox.org posteo.de posteo.net
)

add_family microsoft_family "${microsoft_family[@]}"
add_family yahoo_family "${yahoo_family[@]}"
add_family google_family "${google_family[@]}"
add_family aol_family "${aol_family[@]}"
add_family apple_family "${apple_family[@]}"
add_family qq_china_family "${qq_china_family[@]}"
add_family korea_japan_family "${korea_japan_family[@]}"
add_family cis_russian_family "${cis_russian_family[@]}"
add_family european_family "${european_family[@]}"
add_family privacy_family "${privacy_family[@]}"

# ============================================================
# Prepare output files
# ============================================================

families=(
    microsoft_family
    yahoo_family
    google_family
    aol_family
    apple_family
    qq_china_family
    korea_japan_family
    cis_russian_family
    european_family
    privacy_family
)

for family in "${families[@]}"; do
    : > "$save/${family}.txt"
done

: > "$save/other_mail.txt"

# ============================================================
# Create AWK domain map
# ============================================================

map_file=$(mktemp)

for domain in "${!DOMAIN_FAMILY[@]}"; do
    printf '%s\t%s\n' "$domain" "${DOMAIN_FAMILY[$domain]}"
done > "$map_file"

# ============================================================
# ONE-PASS CLASSIFICATION
# ============================================================

printf "${BLUE}[+] Processing %s emails in one pass...${NC}\n" "$counter"

awk -F'@' -v map="$map_file" -v out="$save/" '
BEGIN {
    while ((getline line < map) > 0) {
        split(line, a, "\t")
        family[a[1]] = a[2]
    }
    close(map)
}
{
    email = $0
    domain = tolower($NF)

    if (domain in family) {
        file = out family[domain] ".txt"
        print email >> file
        count[family[domain]]++
    }
    else {
        print email >> out "other_mail.txt"
        other++
    }
}
END {
    for (f in count)
        print f "\t" count[f] > out ".family_counts"

    print "OTHER\t" other > out ".family_counts"
}
' "$emaillist"

rm -f "$map_file"

# ============================================================
# Remove duplicates from family files
# ============================================================

printf "[+] Finalizing result files...\n"

for family in "${families[@]}"; do
    file="$save/${family}.txt"

    if [[ -s "$file" ]]; then
        LC_ALL=C sort -u "$file" -o "$file"
        count=$(wc -l < "$file")
    else
        count=0
    fi

    printf "    ${GREEN}[OK]${NC} %-22s %s\n" \
        "$family" "$count"
done

# Other mail is already unique because the input was cleaned.
other_count=$(wc -l < "$save/other_mail.txt")

printf "    ${GREEN}[OK]${NC} %-22s %s\n" \
    "other_mail" "$other_count"

rm -f "$save/.family_counts"

# ============================================================
# Summary
# ============================================================

printf "\n"
printf '%*s\n' 60 '' | tr ' ' '-'
printf "${GREEN}[+] Process Completed Successfully!${NC}\n"
printf "[+] Input        : %s emails\n" "$counter"
printf "[+] Output       : %s\n" "$save"
printf '%*s\n' 60 '' | tr ' ' '-'
printf "\n"
