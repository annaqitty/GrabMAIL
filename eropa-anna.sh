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
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'
NC='\033[0m'


# ============================================================
# HEADER
# ============================================================

header() {
    printf "    ${LIGHTGREEN}       ___ ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  EUROPE EMAIL FILTER ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  EXCLUDING UK / FR / IT / DE ${NC}\n"
    printf "    ${LIGHTGREEN}      \\===/ ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}    ___|||___ ${NC}\n"
}

clear
header

echo ""
echo "=========================================================================="
printf "${LIGHTCYAN}${BOLD}EUROPE EMAIL FAMILY FILTER${NC}\n"
echo "=========================================================================="
echo ""

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/europe_mail_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# INTERNATIONAL WEBMAIL
# ============================================================

microsoft_family=(
    hotmail
    live
    outlook
    msn
    windowslive
)

google_family=(
    gmail
    googlemail
)

yahoo_family=(
    yahoo
    ymail
    rocketmail
)

apple_family=(
    icloud
    me
    mac
)

aol_family=(
    aol
)

proton_family=(
    proton
    protonmail
)

tuta_family=(
    tuta
    tutanota
)


# ============================================================
# EUROPEAN COUNTRY TLDs
# ============================================================

austria_family=( at )
belgium_family=( be )
bulgaria_family=( bg )
croatia_family=( hr )
cyprus_family=( cy )
czechia_family=( cz )
denmark_family=( dk )
estonia_family=( ee )
finland_family=( fi )
greece_family=( gr )
hungary_family=( hu )
iceland_family=( is )
ireland_family=( ie )
latvia_family=( lv )
lithuania_family=( lt )
luxembourg_family=( lu )
malta_family=( mt )
moldova_family=( md )
montenegro_family=( me )
netherlands_family=( nl )
northmacedonia_family=( mk )
norway_family=( no )
poland_family=( pl )
portugal_family=( pt )
romania_family=( ro )
serbia_family=( rs )
slovakia_family=( sk )
slovenia_family=( si )
spain_family=( es )
sweden_family=( se )
switzerland_family=( ch )
ukraine_family=( ua )
belarus_family=( by )
bosnia_family=( ba )
kosovo_family=( xk )
liechtenstein_family=( li )
monaco_family=( mc )
sanmarino_family=( sm )
andorra_family=( ad )
vatican_family=( va )


# ============================================================
# EUROPEAN SUPRANATIONAL / GENERIC DOMAINS
# ============================================================

eu_family=( eu )

org_family=( org )

net_family=( net )


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

education_family=(
    edu
    ac
    university
    uni
    college
)

government_family=(
    gov
    government
    minister
    ministry
)

business_family=(
    company
    business
    ltd
    limited
    plc
    sa
    srl
    ag
    gmbh
)


# ============================================================
# EXTRACT EMAILS
# ============================================================

EMAILS="$TMP_DIR/emails.txt"

printf "${BLUE}[+] Extracting email addresses...${NC}\n"

awk '
{
    text = tolower($0)

    while (
        match(
            text,
            /[A-Za-z0-9_.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+/
        )
    ) {
        print substr(text, RSTART, RLENGTH)
        text = substr(text, RSTART + RLENGTH)
    }
}
' "$INPUT" |
awk '!seen[$0]++' > "$EMAILS"

TOTAL=$(wc -l < "$EMAILS")

printf "${GREEN}[+] Unique emails : %s${NC}\n\n" "$TOTAL"


# ============================================================
# EXACT DOMAIN FAMILY FILTER
# ============================================================

filter_family() {

    local NAME="$1"
    shift

    local TMP="$TMP_DIR/${NAME}.txt"
    local EMAIL
    local DOMAIN
    local ITEM
    local COUNT

    : > "$TMP"

    while IFS= read -r EMAIL; do

        [[ -z "$EMAIL" ]] && continue

        DOMAIN="${EMAIL#*@}"

        for ITEM in "$@"; do

            if [[ "$DOMAIN" == "$ITEM" ||
                  "$DOMAIN" == *".$ITEM" ]]; then

                printf '%s\n' "$EMAIL" >> "$TMP"
                break

            fi

        done

    done < "$EMAILS"

    if [[ -s "$TMP" ]]; then

        sort -u "$TMP" > "${TMP}.sorted"

        COUNT=$(wc -l < "${TMP}.sorted")

        mv "${TMP}.sorted" \
            "$OUTPUT/${NAME}[${COUNT}].txt"

        printf "${GREEN}[OK] %-52s %s${NC}\n" \
            "$NAME" "$COUNT"

    else
        rm -f "$TMP"
    fi
}


# ============================================================
# INTERNATIONAL PROVIDERS
# ============================================================

filter_family "Microsoft_Family_Europe" "${microsoft_family[@]}"
filter_family "Google_Family_Europe" "${google_family[@]}"
filter_family "Yahoo_Family_Europe" "${yahoo_family[@]}"
filter_family "Apple_Family_Europe" "${apple_family[@]}"
filter_family "AOL_Family_Europe" "${aol_family[@]}"
filter_family "Proton_Family_Europe" "${proton_family[@]}"
filter_family "Tuta_Family_Europe" "${tuta_family[@]}"


# ============================================================
# COUNTRY FILTERS
# ============================================================

filter_family "Austria_Family_Europe" "${austria_family[@]}"
filter_family "Belgium_Family_Europe" "${belgium_family[@]}"
filter_family "Bulgaria_Family_Europe" "${bulgaria_family[@]}"
filter_family "Croatia_Family_Europe" "${croatia_family[@]}"
filter_family "Cyprus_Family_Europe" "${cyprus_family[@]}"
filter_family "Czechia_Family_Europe" "${czechia_family[@]}"
filter_family "Denmark_Family_Europe" "${denmark_family[@]}"
filter_family "Estonia_Family_Europe" "${estonia_family[@]}"
filter_family "Finland_Family_Europe" "${finland_family[@]}"
filter_family "Greece_Family_Europe" "${greece_family[@]}"
filter_family "Hungary_Family_Europe" "${hungary_family[@]}"
filter_family "Iceland_Family_Europe" "${iceland_family[@]}"
filter_family "Ireland_Family_Europe" "${ireland_family[@]}"
filter_family "Latvia_Family_Europe" "${latvia_family[@]}"
filter_family "Lithuania_Family_Europe" "${lithuania_family[@]}"
filter_family "Luxembourg_Family_Europe" "${luxembourg_family[@]}"
filter_family "Malta_Family_Europe" "${malta_family[@]}"
filter_family "Moldova_Family_Europe" "${moldova_family[@]}"
filter_family "Montenegro_Family_Europe" "${montenegro_family[@]}"
filter_family "Netherlands_Family_Europe" "${netherlands_family[@]}"
filter_family "NorthMacedonia_Family_Europe" "${northmacedonia_family[@]}"
filter_family "Norway_Family_Europe" "${norway_family[@]}"
filter_family "Poland_Family_Europe" "${poland_family[@]}"
filter_family "Portugal_Family_Europe" "${portugal_family[@]}"
filter_family "Romania_Family_Europe" "${romania_family[@]}"
filter_family "Serbia_Family_Europe" "${serbia_family[@]}"
filter_family "Slovakia_Family_Europe" "${slovakia_family[@]}"
filter_family "Slovenia_Family_Europe" "${slovenia_family[@]}"
filter_family "Spain_Family_Europe" "${spain_family[@]}"
filter_family "Sweden_Family_Europe" "${sweden_family[@]}"
filter_family "Switzerland_Family_Europe" "${switzerland_family[@]}"
filter_family "Ukraine_Family_Europe" "${ukraine_family[@]}"
filter_family "Belarus_Family_Europe" "${belarus_family[@]}"
filter_family "Bosnia_Family_Europe" "${bosnia_family[@]}"
filter_family "Kosovo_Family_Europe" "${kosovo_family[@]}"
filter_family "Liechtenstein_Family_Europe" "${liechtenstein_family[@]}"
filter_family "Monaco_Family_Europe" "${monaco_family[@]}"
filter_family "SanMarino_Family_Europe" "${sanmarino_family[@]}"
filter_family "Andorra_Family_Europe" "${andorra_family[@]}"
filter_family "Vatican_Family_Europe" "${vatican_family[@]}"


# ============================================================
# EUROPEAN GENERIC DOMAINS
# ============================================================

filter_family "EU_Domain_Family_Europe" "${eu_family[@]}"
filter_family "ORG_Domain_Family_Europe" "${org_family[@]}"
filter_family "NET_Domain_Family_Europe" "${net_family[@]}"


# ============================================================
# ORGANIZATIONS
# ============================================================

filter_family "Education_Family_Europe" "${education_family[@]}"
filter_family "Government_Family_Europe" "${government_family[@]}"
filter_family "Business_Family_Europe" "${business_family[@]}"


# ============================================================
# OTHER
# ============================================================

OTHER="$OUTPUT/Other_Mail_Europe[${TOTAL}].txt"

cp "$EMAILS" "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")

mv "$OTHER" \
    "$OUTPUT/Other_Mail_Europe[${OTHER_COUNT}].txt"


# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "=========================================================================="
printf "${LIGHTGREEN}${BOLD}COMPLETE${NC}\n"
echo "=========================================================================="

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
echo "=========================================================================="
printf "${GREEN}${BOLD}Done.${NC}\n"
echo "=========================================================================="
