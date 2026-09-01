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

header() {
    printf "    ${LIGHTGREEN}       ___ ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  ╔╦═╦╗╔╦╗╔╦═╦╗ ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  ║║╔╣╚╝║║║║║║║ ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  ║║╚╣╔╗║╚╝║╩║║ ${NC}\n"
    printf "    ${LIGHTGREEN}      \\===/   ║╚═╩╝╚╩══╩╩╝║ ${NC}\n"
    printf "    ${LIGHTGREEN}       |||    ╚═══════════╝ ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}       |||    ASIA DOMAIN FILTER ${NC}\n"
    printf "    ${LIGHTGREEN}    ___|||___ ${NC}\n"
}


# ============================================================
# START
# ============================================================

clear
header

echo ""
echo "=========================================================================="
printf "${LIGHTGREEN}${BOLD}ASIA EMAIL DOMAIN FAMILY FILTER${NC}\n"
echo "=========================================================================="
echo ""

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/asia_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# ASIA COUNTRY TLD DATABASE
# ============================================================

declare -A COUNTRY_TLDS

COUNTRY_TLDS[Afghanistan]="af"
COUNTRY_TLDS[Armenia]="am"
COUNTRY_TLDS[Azerbaijan]="az"
COUNTRY_TLDS[Bahrain]="bh"
COUNTRY_TLDS[Bangladesh]="bd"
COUNTRY_TLDS[Bhutan]="bt"
COUNTRY_TLDS[Brunei]="bn"
COUNTRY_TLDS[Cambodia]="kh"
COUNTRY_TLDS[China]="cn"
COUNTRY_TLDS[Cyprus]="cy"
COUNTRY_TLDS[Georgia]="ge"
COUNTRY_TLDS[India]="in"
COUNTRY_TLDS[Indonesia]="id"
COUNTRY_TLDS[Iran]="ir"
COUNTRY_TLDS[Iraq]="iq"
COUNTRY_TLDS[Israel]="il"
COUNTRY_TLDS[Japan]="jp"
COUNTRY_TLDS[Jordan]="jo"
COUNTRY_TLDS[Kazakhstan]="kz"
COUNTRY_TLDS[Kuwait]="kw"
COUNTRY_TLDS[Kyrgyzstan]="kg"
COUNTRY_TLDS[Laos]="la"
COUNTRY_TLDS[Lebanon]="lb"
COUNTRY_TLDS[Malaysia]="my"
COUNTRY_TLDS[Maldives]="mv"
COUNTRY_TLDS[Mongolia]="mn"
COUNTRY_TLDS[Myanmar]="mm"
COUNTRY_TLDS[Nepal]="np"
COUNTRY_TLDS[NorthKorea]="kp"
COUNTRY_TLDS[Oman]="om"
COUNTRY_TLDS[Pakistan]="pk"
COUNTRY_TLDS[Palestine]="ps"
COUNTRY_TLDS[Philippines]="ph"
COUNTRY_TLDS[Qatar]="qa"
COUNTRY_TLDS[SaudiArabia]="sa"
COUNTRY_TLDS[Singapore]="sg"
COUNTRY_TLDS[SouthKorea]="kr"
COUNTRY_TLDS[SriLanka]="lk"
COUNTRY_TLDS[Syria]="sy"
COUNTRY_TLDS[Taiwan]="tw"
COUNTRY_TLDS[Tajikistan]="tj"
COUNTRY_TLDS[Thailand]="th"
COUNTRY_TLDS[TimorLeste]="tl"
COUNTRY_TLDS[Turkey]="tr"
COUNTRY_TLDS[Turkmenistan]="tm"
COUNTRY_TLDS[UAE]="ae"
COUNTRY_TLDS[Uzbekistan]="uz"
COUNTRY_TLDS[Vietnam]="vn"


# ============================================================
# EXTRACT EMAILS
# ============================================================

EMAILS="$TMP_DIR/emails.txt"

printf "${BLUE}[+] Extracting valid email addresses...${NC}\n"

awk '
{
    line=tolower($0)

    while (
        match(
            line,
            /[[:alnum:]_.%+-]+@[[:alnum:].-]+\.[[:alpha:]][[:alpha:]]+/
        )
    ) {

        email=substr(line,RSTART,RLENGTH)

        if (
            email !~ /\.\./ &&
            email !~ /^[-_.%+]/ &&
            email !~ /[-_.%+]@/
        ) {
            print email
        }

        line=substr(line,RSTART+RLENGTH)
    }
}
' "$INPUT" |
awk '!seen[$0]++' > "$EMAILS"

TOTAL=$(wc -l < "$EMAILS")

printf "${GREEN}[+] Unique emails : %s${NC}\n" "$TOTAL"


# ============================================================
# FILTER ONE TLD
# ============================================================

filter_tld() {

    local FAMILY="$1"
    local TLD="$2"

    filter_multiple_tlds "$FAMILY" "$TLD"
}


# ============================================================
# FILTER MULTIPLE TLDs
# ONE FAMILY = ONE FILE
# NO OVERWRITE
# ============================================================

filter_multiple_tlds() {

    local FAMILY="$1"
    shift

    local TEMP="$TMP_DIR/${FAMILY}.tmp"
    local TLD
    local COUNT

    : > "$TEMP"

    for TLD in "$@"; do

        awk -v tld="$TLD" '
        {
            email=$0
            at=index(email,"@")

            if (at == 0)
                next

            domain=substr(email,at+1)

            if (
                domain == tld ||
                domain ~ ("\\." tld "$")
            ) {
                print email
            }
        }
        ' "$EMAILS" >> "$TEMP"

    done

    # Remove duplicates after combining all TLDs
    sort -u "$TEMP" -o "$TEMP"

    if [[ -s "$TEMP" ]]; then

        COUNT=$(wc -l < "$TEMP")

        mv "$TEMP" \
            "$OUTPUT/${FAMILY}[${COUNT}].txt"

        printf "${GREEN}[OK] %-48s %s${NC}\n" \
            "$FAMILY" "$COUNT"

    else

        rm -f "$TEMP"

    fi
}


# ============================================================
# COUNTRY FAMILIES
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}COUNTRY FAMILIES${NC}\n"
echo "--------------------------------------------------------------------------"

for COUNTRY in "${!COUNTRY_TLDS[@]}"; do

    TLD="${COUNTRY_TLDS[$COUNTRY]}"

    filter_tld \
        "${COUNTRY}_Family_Asia" \
        "$TLD"

done


# ============================================================
# REGIONAL GROUPS
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}REGIONAL FAMILIES${NC}\n"
echo "--------------------------------------------------------------------------"

filter_multiple_tlds \
    "EastAsia_Region_Asia" \
    cn jp kr kp mn tw

filter_multiple_tlds \
    "SoutheastAsia_Region_Asia" \
    bn kh id la my mm ph sg th tl vn

filter_multiple_tlds \
    "SouthAsia_Region_Asia" \
    af bd bt in mv np pk lk

filter_multiple_tlds \
    "CentralAsia_Region_Asia" \
    kz kg tj tm uz

filter_multiple_tlds \
    "WestAsia_Region_Asia" \
    am az bh cy ge iq il jo kw lb om ps qa sa sy tr ae ye


# ============================================================
# REGIONAL TLD
# ============================================================

filter_tld \
    "Asia_Regional_Domain" \
    "asia"


# ============================================================
# EDUCATION
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}EDUCATION FAMILIES${NC}\n"
echo "--------------------------------------------------------------------------"

filter_multiple_tlds \
    "Japan_Education_Asia" \
    ac.jp

filter_multiple_tlds \
    "SouthKorea_Education_Asia" \
    ac.kr

filter_multiple_tlds \
    "China_Education_Asia" \
    edu.cn

filter_multiple_tlds \
    "India_Education_Asia" \
    ac.in edu.in

filter_multiple_tlds \
    "Indonesia_Education_Asia" \
    ac.id sch.id

filter_multiple_tlds \
    "Malaysia_Education_Asia" \
    edu.my

filter_multiple_tlds \
    "Singapore_Education_Asia" \
    edu.sg

filter_multiple_tlds \
    "Thailand_Education_Asia" \
    ac.th edu.th

filter_multiple_tlds \
    "Philippines_Education_Asia" \
    edu.ph

filter_multiple_tlds \
    "Taiwan_Education_Asia" \
    edu.tw

filter_multiple_tlds \
    "Vietnam_Education_Asia" \
    edu.vn

filter_multiple_tlds \
    "Bangladesh_Education_Asia" \
    edu.bd

filter_multiple_tlds \
    "Pakistan_Education_Asia" \
    edu.pk

filter_multiple_tlds \
    "Nepal_Education_Asia" \
    edu.np

filter_multiple_tlds \
    "SriLanka_Education_Asia" \
    ac.lk edu.lk

filter_multiple_tlds \
    "Brunei_Education_Asia" \
    edu.bn

filter_multiple_tlds \
    "Cambodia_Education_Asia" \
    edu.kh

filter_multiple_tlds \
    "Mongolia_Education_Asia" \
    edu.mn

filter_multiple_tlds \
    "Kazakhstan_Education_Asia" \
    edu.kz

filter_multiple_tlds \
    "Uzbekistan_Education_Asia" \
    edu.uz

filter_multiple_tlds \
    "Turkey_Education_Asia" \
    edu.tr


# ============================================================
# GOVERNMENT
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}GOVERNMENT FAMILIES${NC}\n"
echo "--------------------------------------------------------------------------"

filter_multiple_tlds \
    "Japan_Government_Asia" \
    go.jp

filter_multiple_tlds \
    "SouthKorea_Government_Asia" \
    go.kr

filter_multiple_tlds \
    "China_Government_Asia" \
    gov.cn

filter_multiple_tlds \
    "India_Government_Asia" \
    gov.in

filter_multiple_tlds \
    "Indonesia_Government_Asia" \
    go.id

filter_multiple_tlds \
    "Malaysia_Government_Asia" \
    gov.my

filter_multiple_tlds \
    "Singapore_Government_Asia" \
    gov.sg

filter_multiple_tlds \
    "Thailand_Government_Asia" \
    go.th

filter_multiple_tlds \
    "Philippines_Government_Asia" \
    gov.ph

filter_multiple_tlds \
    "Taiwan_Government_Asia" \
    gov.tw

filter_multiple_tlds \
    "Vietnam_Government_Asia" \
    gov.vn

filter_multiple_tlds \
    "Bangladesh_Government_Asia" \
    gov.bd

filter_multiple_tlds \
    "Pakistan_Government_Asia" \
    gov.pk

filter_multiple_tlds \
    "Nepal_Government_Asia" \
    gov.np


# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "=========================================================================="
printf "${LIGHTGREEN}${BOLD}COMPLETE${NC}\n"
echo "=========================================================================="

printf "Input file   : %s\n" "$INPUT"
printf "Total emails : %s\n" "$TOTAL"
printf "Output dir   : %s\n" "$OUTPUT"

echo ""
printf "${LIGHTCYAN}Generated files:${NC}\n"

find "$OUTPUT" \
    -maxdepth 1 \
    -type f \
    -printf "  %f\n" |
sort

echo ""
echo "=========================================================================="
printf "${GREEN}${BOLD}Done.${NC}\n"
echo "=========================================================================="
