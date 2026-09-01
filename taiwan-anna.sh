#!/usr/bin/env bash

set -u
export LC_ALL=C

# ============================================================
# COLORS
# ============================================================

BOLD='\e[1m'

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'

LIGHTRED='\033[0;91m'
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'

BACKGREEN='\033[0;42m'
BACKBLUE='\033[0;44m'

NC='\033[0m'


# ============================================================
# HEADER
# ============================================================

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


# ============================================================
# START
# ============================================================

clear
header

echo ""
echo "__________________________________________________________________________________"
echo ""
printf "${LIGHTCYAN}${BOLD}GrabMAIL TAIWAN${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Taiwan\n"
printf "Date     : 28 July 2010\n"
echo "__________________________________________________________________________________"
echo ""


# ============================================================
# INPUT
# ============================================================

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"


# ============================================================
# TEMP
# ============================================================

TMP_DIR="${TMPDIR:-/tmp}/taiwan_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# TAIWAN MAIL PROVIDERS
# ============================================================

yahoo_family=(
    yahoo.com.tw
    yahoo.com
    ymail.com
)

pchome_family=(
    pchome.com.tw
)

gmail_family=(
    gmail.com
    googlemail.com
)

hinet_family=(
    hinet.net
    hinet.net.tw
)

seednet_family=(
    seed.net.tw
)

so_net_family=(
    so-net.net.tw
)

kimo_family=(
    kimo.com.tw
)

mail2000_family=(
    mail2000.com.tw
)

msa_family=(
    msa.hinet.net
)

xuite_family=(
    xuite.net
)

url_family=(
    url.com.tw
)

et_home_family=(
    ethome.net
)

tfamily_family=(
    tfamily.com.tw
)

aptg_family=(
    aptg.com.tw
)

sonet_family=(
    sonet.com.tw
)


# ============================================================
# TAIWAN ISP / TELECOM FAMILIES
# ============================================================

cht_family=(
    cht.com.tw
    chunghwa-telecom.com
    chunghwa.com.tw
)

taiwan_mobile_family=(
    taiwanmobile.com
    taiwanmobile.com.tw
)

fareastone_family=(
    fetnet.net
    fetnet.net.tw
    fareastone.com.tw
)

tstar_family=(
    tstartel.com
    tstartel.com.tw
)

aptg_telecom_family=(
    aptg.com.tw
)

kbro_family=(
    kbro.com.tw
)

taiwan_fixed_network_family=(
    twn.com.tw
)

sparq_family=(
    sparq.com.tw
)


# ============================================================
# INTERNATIONAL PROVIDERS
# ============================================================

microsoft_family=(
    hotmail.com
    hotmail.com.tw
    live.com
    live.com.tw
    outlook.com
    outlook.com.tw
    msn.com
)

apple_family=(
    icloud.com
    me.com
    mac.com
)

aol_family=(
    aol.com
)

proton_family=(
    proton.me
    protonmail.com
)

tuta_family=(
    tuta.com
    tutanota.com
)


# ============================================================
# TAIWAN DOMAIN CATEGORIES
# ============================================================

tw_family=(
    tw
)

com_tw_family=(
    com.tw
)

net_tw_family=(
    net.tw
)

org_tw_family=(
    org.tw
)

edu_tw_family=(
    edu.tw
)

gov_tw_family=(
    gov.tw
)

mil_tw_family=(
    mil.tw
)

idv_tw_family=(
    idv.tw
)

game_tw_family=(
    game.tw
)

ebiz_tw_family=(
    ebiz.tw
)

club_tw_family=(
    club.tw
)

social_tw_family=(
    social.tw
)


# ============================================================
# INTERNATIONAL / IDN TAIWAN DOMAINS
# ============================================================

taiwan_idn_family=(
    xn--kpry57d
)

taipei_idn_family=(
    xn--1lqs71d
)


# ============================================================
# EDUCATION / GOVERNMENT
# ============================================================

education_family=(
    edu.tw
    university
    college
)

government_family=(
    gov.tw
    government
)

military_family=(
    mil.tw
    military
)

organization_family=(
    org.tw
)


# ============================================================
# TAIWAN LOCATION KEYWORDS
#
# These are domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

taiwan_family=(
    taiwan
    taipei
)

taipei_family=(
    taipei
    tp
)

newtaipei_family=(
    newtaipei
    new-taipei
)

taoyuan_family=(
    taoyuan
)

taichung_family=(
    taichung
)

tainan_family=(
    tainan
)

kaohsiung_family=(
    kaohsiung
)

keelung_family=(
    keelung
)

hsinchu_family=(
    hsinchu
)

chiayi_family=(
    chiayi
    chiayi-city
)

changhua_family=(
    changhua
)

nantou_family=(
    nantou
)

yunlin_family=(
    yunlin
)

chiayi_county_family=(
    chiayicounty
)

pingtung_family=(
    pingtung
)

yilan_family=(
    yilan
)

hualien_family=(
    hualien
)

taitung_family=(
    taitung
)

penghu_family=(
    penghu
)

kinmen_family=(
    kinmen
)

lienchiang_family=(
    lienchiang
)


# ============================================================
# EXTRACT EMAILS
# ============================================================

EMAILS="$TMP_DIR/emails.txt"

printf "${BLUE}[+] Extracting email addresses...${NC}\n"

awk '
{
    s = tolower($0)

    while (
        match(
            s,
            /[A-Za-z0-9_.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+/
        )
    ) {

        email = substr(s, RSTART, RLENGTH)

        print email

        s = substr(
            s,
            RSTART + RLENGTH
        )
    }
}
' "$INPUT" |
awk '!seen[$0]++' > "$EMAILS"

TOTAL=$(wc -l < "$EMAILS")

printf "${GREEN}[+] Unique emails : %s${NC}\n" "$TOTAL"
echo ""


# ============================================================
# FAMILY MAP
# ============================================================

declare -A FAMILY_REGEX


add_family(){

    local name="$1"
    shift

    local regex=""
    local item
    local escaped

    for item in "$@"; do

        [[ -z "$item" ]] && continue

        escaped=$(printf '%s' "$item" |
            sed 's/[][\\.^$*+?(){}|]/\\&/g')

        if [[ -n "$regex" ]]; then
            regex="${regex}|"
        fi

        regex="${regex}${escaped}"
    done

    FAMILY_REGEX["$name"]="$regex"
}


# ============================================================
# REGISTER TAIWAN MAIL FAMILIES
# ============================================================

add_family "Yahoo_Family_TAIWAN" "${yahoo_family[@]}"
add_family "PChome_Family_TAIWAN" "${pchome_family[@]}"
add_family "Google_Family_TAIWAN" "${gmail_family[@]}"
add_family "HiNet_Family_TAIWAN" "${hinet_family[@]}"
add_family "Seednet_Family_TAIWAN" "${seednet_family[@]}"
add_family "SoNet_Family_TAIWAN" "${so_net_family[@]}"
add_family "Kimo_Family_TAIWAN" "${kimo_family[@]}"
add_family "Mail2000_Family_TAIWAN" "${mail2000_family[@]}"
add_family "MSA_HiNet_Family_TAIWAN" "${msa_family[@]}"
add_family "Xuite_Family_TAIWAN" "${xuite_family[@]}"
add_family "URL_Family_TAIWAN" "${url_family[@]}"
add_family "eTHome_Family_TAIWAN" "${et_home_family[@]}"
add_family "TFamily_Family_TAIWAN" "${tfamily_family[@]}"
add_family "APTG_Family_TAIWAN" "${aptg_family[@]}"
add_family "SoNet_Com_Family_TAIWAN" "${sonet_family[@]}"


# ============================================================
# REGISTER ISP / TELECOM
# ============================================================

add_family "ChunghwaTelecom_Family_TAIWAN" "${cht_family[@]}"
add_family "TaiwanMobile_Family_TAIWAN" "${taiwan_mobile_family[@]}"
add_family "FarEasTone_Family_TAIWAN" "${fareastone_family[@]}"
add_family "TStar_Family_TAIWAN" "${tstar_family[@]}"
add_family "APTG_Telecom_Family_TAIWAN" "${aptg_telecom_family[@]}"
add_family "KBro_Family_TAIWAN" "${kbro_family[@]}"
add_family "TaiwanFixedNetwork_Family_TAIWAN" "${taiwan_fixed_network_family[@]}"
add_family "Sparq_Family_TAIWAN" "${sparq_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_TAIWAN" "${microsoft_family[@]}"
add_family "Apple_Family_TAIWAN" "${apple_family[@]}"
add_family "AOL_Family_TAIWAN" "${aol_family[@]}"
add_family "Proton_Family_TAIWAN" "${proton_family[@]}"
add_family "Tuta_Family_TAIWAN" "${tuta_family[@]}"


# ============================================================
# REGISTER TAIWAN TLD FAMILIES
# ============================================================

add_family "TW_Domain_Family_TAIWAN" "${tw_family[@]}"
add_family "COM_TW_Domain_Family_TAIWAN" "${com_tw_family[@]}"
add_family "NET_TW_Domain_Family_TAIWAN" "${net_tw_family[@]}"
add_family "ORG_TW_Domain_Family_TAIWAN" "${org_tw_family[@]}"
add_family "EDU_TW_Domain_Family_TAIWAN" "${edu_tw_family[@]}"
add_family "GOV_TW_Domain_Family_TAIWAN" "${gov_tw_family[@]}"
add_family "MIL_TW_Domain_Family_TAIWAN" "${mil_tw_family[@]}"
add_family "IDV_TW_Domain_Family_TAIWAN" "${idv_tw_family[@]}"
add_family "GAME_TW_Domain_Family_TAIWAN" "${game_tw_family[@]}"
add_family "EBIZ_TW_Domain_Family_TAIWAN" "${ebiz_tw_family[@]}"
add_family "CLUB_TW_Domain_Family_TAIWAN" "${club_tw_family[@]}"
add_family "SOCIAL_TW_Domain_Family_TAIWAN" "${social_tw_family[@]}"


# ============================================================
# REGISTER IDN FAMILIES
# ============================================================

add_family "Taiwan_IDN_Family_TAIWAN" "${taiwan_idn_family[@]}"
add_family "Taipei_IDN_Family_TAIWAN" "${taipei_idn_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Education_Family_TAIWAN" "${education_family[@]}"
add_family "Government_Family_TAIWAN" "${government_family[@]}"
add_family "Military_Family_TAIWAN" "${military_family[@]}"
add_family "Organization_Family_TAIWAN" "${organization_family[@]}"


# ============================================================
# REGISTER LOCATIONS
# ============================================================

add_family "Taiwan_Family_TAIWAN" "${taiwan_family[@]}"
add_family "Taipei_Family_TAIWAN" "${taipei_family[@]}"
add_family "NewTaipei_Family_TAIWAN" "${newtaipei_family[@]}"
add_family "Taoyuan_Family_TAIWAN" "${taoyuan_family[@]}"
add_family "Taichung_Family_TAIWAN" "${taichung_family[@]}"
add_family "Tainan_Family_TAIWAN" "${tainan_family[@]}"
add_family "Kaohsiung_Family_TAIWAN" "${kaohsiung_family[@]}"
add_family "Keelung_Family_TAIWAN" "${keelung_family[@]}"
add_family "Hsinchu_Family_TAIWAN" "${hsinchu_family[@]}"
add_family "Chiayi_Family_TAIWAN" "${chiayi_family[@]}"
add_family "Changhua_Family_TAIWAN" "${changhua_family[@]}"
add_family "Nantou_Family_TAIWAN" "${nantou_family[@]}"
add_family "Yunlin_Family_TAIWAN" "${yunlin_family[@]}"
add_family "ChiayiCounty_Family_TAIWAN" "${chiayi_county_family[@]}"
add_family "Pingtung_Family_TAIWAN" "${pingtung_family[@]}"
add_family "Yilan_Family_TAIWAN" "${yilan_family[@]}"
add_family "Hualien_Family_TAIWAN" "${hualien_family[@]}"
add_family "Taitung_Family_TAIWAN" "${taitung_family[@]}"
add_family "Penghu_Family_TAIWAN" "${penghu_family[@]}"
add_family "Kinmen_Family_TAIWAN" "${kinmen_family[@]}"
add_family "Lienchiang_Family_TAIWAN" "${lienchiang_family[@]}"


# ============================================================
# OUTPUT DIRECTORIES
# ============================================================

mkdir -p "$OUTPUT"


# ============================================================
# CLASSIFICATION
# ============================================================

printf "${BLUE}[+] Classifying emails...${NC}\n"

declare -A FILES
declare -A COUNTS

for family in "${!FAMILY_REGEX[@]}"; do

    file="$OUTPUT/${family}.tmp"

    : > "$file"

    FILES["$family"]="$file"
    COUNTS["$family"]=0

done

OTHER_TMP="$TMP_DIR/other.tmp"
: > "$OTHER_TMP"


while IFS= read -r email; do

    [[ -z "$email" ]] && continue

    domain="${email#*@}"

    matched=0

    for family in "${!FAMILY_REGEX[@]}"; do

        regex="${FAMILY_REGEX[$family]}"

        if [[ "$domain" =~ $regex ]]; then

            printf '%s\n' "$email" >> "${FILES[$family]}"

            COUNTS["$family"]=$(( COUNTS["$family"] + 1 ))

            matched=1
            break

        fi

    done

    if (( matched == 0 )); then
        printf '%s\n' "$email" >> "$OTHER_TMP"
    fi

done < "$EMAILS"


# ============================================================
# RENAME OUTPUT FILES
# ============================================================

for family in "${!FILES[@]}"; do

    file="${FILES[$family]}"
    count="${COUNTS[$family]}"

    if (( count > 0 )); then

        mv "$file" \
            "$OUTPUT/${family}[${count}].txt"

        printf "${GREEN}[OK] %-45s %s${NC}\n" \
            "$family" "$count"

    else

        rm -f "$file"

    fi

done


# ============================================================
# OTHER
# ============================================================

OTHER_COUNT=$(wc -l < "$OTHER_TMP")

mv "$OTHER_TMP" \
    "$OUTPUT/Other_Mail_TAIWAN[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-40s %s${NC}\n" \
    "Other_Mail_TAIWAN" "$OTHER_COUNT"


# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "__________________________________________________________________________________"

printf "${LIGHTGREEN}${BOLD}COMPLETE${NC}\n"
echo ""

printf "Input file   : %s\n" "$INPUT"
printf "Total emails : %s\n" "$TOTAL"
printf "Other emails : %s\n" "$OTHER_COUNT"
printf "Output dir   : %s\n" "$OUTPUT"

echo ""
printf "${LIGHTCYAN}Generated files:${NC}\n"

find "$OUTPUT" \
    -maxdepth 1 \
    -type f \
    -printf "  %f\n" |
sort

echo ""
echo "__________________________________________________________________________________"

printf "${GREEN}${BOLD}Done.${NC}\n"
