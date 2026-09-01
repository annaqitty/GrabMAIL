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
echo "Canada Domain Family Filter"
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

TMP_DIR="${TMPDIR:-/tmp}/canada_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# PROVIDER REFERENCE DATABASE
# ============================================================

microsoft_family=(
    hotmail
    outlook
    live
    msn
)

yahoo_family=(
    yahoo
    ymail
)

google_family=(
    gmail
    googlemail
)

apple_family=(
    icloud
    me
    mac
)

bell_family=(
    bell
    bellnet
    bellaliant
    sympatico
)

rogers_family=(
    rogers
)

shaw_family=(
    shaw
    shawmail
)

telus_family=(
    telus
)

videotron_family=(
    videotron
)

cogeco_family=(
    cogeco
)

eastlink_family=(
    eastlink
)

sasktel_family=(
    sasktel
)

mts_family=(
    mts
    mymts
)

primus_family=(
    primus
)

aliant_family=(
    aliant
)

virgin_family=(
    virgin
)

fido_family=(
    fido
)

koodo_family=(
    koodo
)

northwestel_family=(
    northwestel
)


# ============================================================
# CANADA DOMAIN FAMILIES
# ============================================================

canada_family=(
    ca
)

canada_education_family=(
    edu.ca
)

canada_government_family=(
    gc.ca
)

canada_organization_family=(
    org.ca
)

canada_network_family=(
    net.ca
)

canada_business_family=(
    com.ca
)

canada_specialized_family=(
    biz.ca
    info.ca
    name.ca
)

canada_regional_family=(
    on.ca
    qc.ca
    bc.ca
    ab.ca
    mb.ca
    sk.ca
    ns.ca
    nb.ca
    nl.ca
    pe.ca
    nt.ca
    nu.ca
    yt.ca
)


# ============================================================
# ALL CANADA DOMAINS
# ============================================================

canada_all_family=(
    ca
    edu.ca
    gc.ca
    org.ca
    net.ca
    com.ca
    biz.ca
    info.ca
    name.ca
    on.ca
    qc.ca
    bc.ca
    ab.ca
    mb.ca
    sk.ca
    ns.ca
    nb.ca
    nl.ca
    pe.ca
    nt.ca
    nu.ca
    yt.ca
)


# ============================================================
# EXTRACT EMAIL ADDRESSES
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
# MULTIPLE-TLD FILTER
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
# CANADA COUNTRY
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}CANADA COUNTRY${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Family" \
    "${canada_family[@]}"


# ============================================================
# EDUCATION
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}EDUCATION${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Education" \
    "${canada_education_family[@]}"


# ============================================================
# GOVERNMENT
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}GOVERNMENT${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Government" \
    "${canada_government_family[@]}"


# ============================================================
# ORGANIZATION
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}ORGANIZATION${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Organization" \
    "${canada_organization_family[@]}"


# ============================================================
# NETWORK
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}NETWORK${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Network" \
    "${canada_network_family[@]}"


# ============================================================
# BUSINESS
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}BUSINESS${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Business" \
    "${canada_business_family[@]}"


# ============================================================
# SPECIALIZED
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}SPECIALIZED${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Specialized" \
    "${canada_specialized_family[@]}"


# ============================================================
# PROVINCES / TERRITORIES
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}PROVINCES / TERRITORIES${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_Regional" \
    "${canada_regional_family[@]}"


# ============================================================
# ALL CANADA DOMAINS
# ============================================================

echo ""
printf "${LIGHTCYAN}${BOLD}ALL CANADA DOMAINS${NC}\n"
echo "__________________________________________________________________________________"

filter_multiple_tlds \
    "Canada_All_Domains" \
    "${canada_all_family[@]}"


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
