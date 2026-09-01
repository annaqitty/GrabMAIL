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
  printf "    ${LIGHTGREEN}      \\===/   ║╚═╩╝╚╩══╩╩╝║ ${NC}\n"
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
echo "Americas Mail Domain Family Filter"
echo "Coded By : AnnaQitty ( chua )"
echo "__________________________________________________________________________________"
echo ""

read -rp "[+] Input file  : " INPUT
read -rp "[+] Output dir  : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] Input file not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/americas_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# COUNTRY DATABASE
# USA EXCLUDED
# ============================================================

declare -A COUNTRY_TLDS

# ---------------- NORTH AMERICA ----------------

COUNTRY_TLDS[canada]="ca"
COUNTRY_TLDS[mexico]="mx"

# ---------------- CENTRAL AMERICA ----------------

COUNTRY_TLDS[belize]="bz"
COUNTRY_TLDS[costa_rica]="cr"
COUNTRY_TLDS[el_salvador]="sv"
COUNTRY_TLDS[guatemala]="gt"
COUNTRY_TLDS[honduras]="hn"
COUNTRY_TLDS[nicaragua]="ni"
COUNTRY_TLDS[panama]="pa"

# ---------------- CARIBBEAN ----------------

COUNTRY_TLDS[antigua_barbuda]="ag"
COUNTRY_TLDS[bahamas]="bs"
COUNTRY_TLDS[barbados]="bb"
COUNTRY_TLDS[cuba]="cu"
COUNTRY_TLDS[dominica]="dm"
COUNTRY_TLDS[dominican_republic]="do"
COUNTRY_TLDS[grenada]="gd"
COUNTRY_TLDS[haiti]="ht"
COUNTRY_TLDS[jamaica]="jm"
COUNTRY_TLDS[saint_kitts_nevis]="kn"
COUNTRY_TLDS[saint_lucia]="lc"
COUNTRY_TLDS[saint_vincent_grenadines]="vc"
COUNTRY_TLDS[trinidad_tobago]="tt"

# ---------------- SOUTH AMERICA ----------------

COUNTRY_TLDS[argentina]="ar"
COUNTRY_TLDS[bolivia]="bo"
COUNTRY_TLDS[brazil]="br"
COUNTRY_TLDS[chile]="cl"
COUNTRY_TLDS[colombia]="co"
COUNTRY_TLDS[ecuador]="ec"
COUNTRY_TLDS[guyana]="gy"
COUNTRY_TLDS[paraguay]="py"
COUNTRY_TLDS[peru]="pe"
COUNTRY_TLDS[suriname]="sr"
COUNTRY_TLDS[uruguay]="uy"
COUNTRY_TLDS[venezuela]="ve"


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
# MULTIPLE TLD FILTER
# ============================================================

filter_multiple_tlds(){

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

    sort -u "$TEMP" -o "$TEMP"

    if [[ -s "$TEMP" ]]; then

        COUNT=$(wc -l < "$TEMP")

        mv "$TEMP" \
           "$OUTPUT/${FAMILY}[${COUNT}].txt"

        printf "${GREEN}[OK] %-55s %s${NC}\n" \
            "$FAMILY" "$COUNT"

    else

        rm -f "$TEMP"

    fi
}


# ============================================================
# COUNTRY FILTER
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}COUNTRY FAMILIES${NC}\n"
echo "__________________________________________________________________________________"

for COUNTRY in "${!COUNTRY_TLDS[@]}"; do

    TLD="${COUNTRY_TLDS[$COUNTRY]}"

    filter_multiple_tlds \
        "${COUNTRY}_Family_Americas" \
        "$TLD"

done


# ============================================================
# NORTH AMERICA
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}NORTH AMERICA${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "NorthAmerica_Region_Americas" \
    ca mx


# ============================================================
# CENTRAL AMERICA
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}CENTRAL AMERICA${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "CentralAmerica_Region_Americas" \
    bz cr sv gt hn ni pa


# ============================================================
# CARIBBEAN
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}CARIBBEAN${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Caribbean_Region_Americas" \
    ag bs bb cu dm do gd ht jm kn lc vc tt


# ============================================================
# SOUTH AMERICA
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}SOUTH AMERICA${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "SouthAmerica_Region_Americas" \
    ar bo br cl co ec gy py pe sr uy ve


# ============================================================
# ALL AMERICAS EXCEPT USA
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}ALL AMERICAS EXCEPT USA${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Americas_Region_Except_USA" \
    ca mx \
    bz cr sv gt hn ni pa \
    ag bs bb cu dm do gd ht jm kn lc vc tt \
    ar bo br cl co ec gy py pe sr uy ve


# ============================================================
# EDUCATION
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}EDUCATION / ACADEMIC${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Education_Americas" \
    edu.ca

filter_multiple_tlds \
    "Mexico_Education_Americas" \
    edu.mx

filter_multiple_tlds \
    "Argentina_Education_Americas" \
    edu.ar

filter_multiple_tlds \
    "Brazil_Education_Americas" \
    edu.br

filter_multiple_tlds \
    "Chile_Education_Americas" \
    edu.cl

filter_multiple_tlds \
    "Colombia_Education_Americas" \
    edu.co

filter_multiple_tlds \
    "Ecuador_Education_Americas" \
    edu.ec

filter_multiple_tlds \
    "Peru_Education_Americas" \
    edu.pe

filter_multiple_tlds \
    "Uruguay_Education_Americas" \
    edu.uy

filter_multiple_tlds \
    "Bolivia_Education_Americas" \
    edu.bo

filter_multiple_tlds \
    "Paraguay_Education_Americas" \
    edu.py

filter_multiple_tlds \
    "CostaRica_Education_Americas" \
    ac.cr

filter_multiple_tlds \
    "Panama_Education_Americas" \
    ac.pa

filter_multiple_tlds \
    "DominicanRepublic_Education_Americas" \
    edu.do

filter_multiple_tlds \
    "Guatemala_Education_Americas" \
    edu.gt


# ============================================================
# ALL EDUCATION AMERICAS
# ============================================================

filter_multiple_tlds \
    "Education_Americas" \
    edu.ca \
    edu.mx \
    edu.ar \
    edu.br \
    edu.cl \
    edu.co \
    edu.ec \
    edu.pe \
    edu.uy \
    edu.bo \
    edu.py \
    ac.cr \
    ac.pa \
    edu.do \
    edu.gt


# ============================================================
# GOVERNMENT
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}GOVERNMENT${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Government_Americas" \
    gc.ca

filter_multiple_tlds \
    "Mexico_Government_Americas" \
    gob.mx

filter_multiple_tlds \
    "Argentina_Government_Americas" \
    gob.ar

filter_multiple_tlds \
    "Brazil_Government_Americas" \
    gov.br

filter_multiple_tlds \
    "Chile_Government_Americas" \
    gob.cl

filter_multiple_tlds \
    "Colombia_Government_Americas" \
    gov.co

filter_multiple_tlds \
    "Ecuador_Government_Americas" \
    gob.ec

filter_multiple_tlds \
    "Peru_Government_Americas" \
    gob.pe

filter_multiple_tlds \
    "Uruguay_Government_Americas" \
    gub.uy

filter_multiple_tlds \
    "Bolivia_Government_Americas" \
    gob.bo

filter_multiple_tlds \
    "Paraguay_Government_Americas" \
    gov.py

filter_multiple_tlds \
    "CostaRica_Government_Americas" \
    go.cr

filter_multiple_tlds \
    "Panama_Government_Americas" \
    gob.pa

filter_multiple_tlds \
    "DominicanRepublic_Government_Americas" \
    gob.do


# ============================================================
# ALL GOVERNMENT AMERICAS
# ============================================================

filter_multiple_tlds \
    "Government_Americas" \
    gc.ca \
    gob.mx \
    gob.ar \
    gov.br \
    gob.cl \
    gov.co \
    gob.ec \
    gob.pe \
    gub.uy \
    gob.bo \
    gov.py \
    go.cr \
    gob.pa \
    gob.do


# ============================================================
# BUSINESS DOMAINS
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}BUSINESS / ORGANIZATION / NETWORK${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Business_Americas" \
    com.ar \
    com.br \
    com.cl \
    com.co \
    com.mx \
    com.pe \
    com.uy

filter_multiple_tlds \
    "Organization_Americas" \
    org.ar \
    org.br \
    org.cl \
    org.co \
    org.mx \
    org.pe \
    org.uy

filter_multiple_tlds \
    "Network_Americas" \
    net.ar \
    net.br \
    net.cl \
    net.co \
    net.mx \
    net.pe


# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "__________________________________________________________________________________"
echo ""
printf "${LIGHTGREEN}${BOLD}COMPLETE${NC}\n"
echo "__________________________________________________________________________________"

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
echo "__________________________________________________________________________________"
printf "${GREEN}${BOLD}Done.${NC}\n"
echo "__________________________________________________________________________________"
