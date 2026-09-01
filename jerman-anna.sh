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
echo "=========================================================================="
printf "${LIGHTCYAN}${BOLD}GERMANY EMAIL FAMILY FILTER${NC}\n"
echo "=========================================================================="
echo ""

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/germany_mail_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# WEBMAIL FAMILIES
# ============================================================

gmx_family=( gmx )
webde_family=( web webde )
freenet_family=( freenet )
tonline_family=( t-online )
mailde_family=( mail mailde )
posteo_family=( posteo )
mailbox_family=( mailbox )
strato_family=( strato )
oneundone_family=( 1und1 oneundone )
telekom_family=( telekom )

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

aol_family=( aol )

proton_family=(
    proton
    protonmail
)

tuta_family=(
    tuta
    tutanota
)


# ============================================================
# GERMANY DOMAIN CATEGORIES
# ============================================================

de_family=( de )
eu_family=( eu )
org_family=( org )


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

education_family=(
    uni
    fh
    hochschule
    schule
    schul
)

government_family=(
    bund
    bundes
    land
    staat
    verwaltung
)

business_family=(
    gmbh
    ag
)


# ============================================================
# STATES
# ============================================================

badenwuerttemberg_family=(
    baden-wuerttemberg
    badenwuerttemberg
)

bayern_family=(
    bayern
    bavaria
)

berlin_family=(
    berlin
)

brandenburg_family=(
    brandenburg
)

bremen_family=(
    bremen
)

hamburg_family=(
    hamburg
)

hessen_family=(
    hessen
)

mecklenburgvorpommern_family=(
    mecklenburg-vorpommern
    mecklenburgvorpommern
)

niedersachsen_family=(
    niedersachsen
)

nordrheinwestfalen_family=(
    nordrhein-westfalen
    nordrheinwestfalen
    nrw
)

rheinlandpfalz_family=(
    rheinland-pfalz
    rheinlandpfalz
)

saarland_family=(
    saarland
)

sachsen_family=(
    sachsen
)

sachsenanhalt_family=(
    sachsen-anhalt
    sachsenanhalt
)

schleswigholstein_family=(
    schleswig-holstein
    schleswigholstein
)

thueringen_family=(
    thueringen
    thuringia
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
    local COUNT=0
    local DOMAIN
    local EMAIL
    local ITEM

    : > "$TMP"

    while IFS= read -r EMAIL; do

        [[ -z "$EMAIL" ]] && continue

        DOMAIN="${EMAIL#*@}"

        for ITEM in "$@"; do

            # Exact domain or subdomain:
            #
            # example.com
            # sub.example.com
            #
            if [[ "$DOMAIN" == "$ITEM" ||
                  "$DOMAIN" == *".$ITEM" ]]; then

                printf '%s\n' "$EMAIL" >> "$TMP"
                COUNT=$((COUNT + 1))
                break
            fi

        done

    done < "$EMAILS"

    if (( COUNT > 0 )); then

        sort -u "$TMP" > "${TMP}.sorted"

        COUNT=$(wc -l < "${TMP}.sorted")

        mv "${TMP}.sorted" \
            "$OUTPUT/${NAME}[${COUNT}].txt"

        printf "${GREEN}[OK] %-48s %s${NC}\n" \
            "$NAME" "$COUNT"

    else
        rm -f "$TMP"
    fi
}


# ============================================================
# GERMAN WEBMAIL
# ============================================================

filter_family "GMX_Family_Germany" \
    "${gmx_family[@]}"

filter_family "WEBDE_Family_Germany" \
    "${webde_family[@]}"

filter_family "Freenet_Family_Germany" \
    "${freenet_family[@]}"

filter_family "TOnline_Family_Germany" \
    "${tonline_family[@]}"

filter_family "MailDE_Family_Germany" \
    "${mailde_family[@]}"

filter_family "Posteo_Family_Germany" \
    "${posteo_family[@]}"

filter_family "Mailbox_Family_Germany" \
    "${mailbox_family[@]}"

filter_family "Strato_Family_Germany" \
    "${strato_family[@]}"

filter_family "1und1_Family_Germany" \
    "${oneundone_family[@]}"

filter_family "Telekom_Family_Germany" \
    "${telekom_family[@]}"


# ============================================================
# INTERNATIONAL WEBMAIL
# ============================================================

filter_family "Microsoft_Family_Germany" \
    "${microsoft_family[@]}"

filter_family "Google_Family_Germany" \
    "${google_family[@]}"

filter_family "Yahoo_Family_Germany" \
    "${yahoo_family[@]}"

filter_family "Apple_Family_Germany" \
    "${apple_family[@]}"

filter_family "AOL_Family_Germany" \
    "${aol_family[@]}"

filter_family "Proton_Family_Germany" \
    "${proton_family[@]}"

filter_family "Tuta_Family_Germany" \
    "${tuta_family[@]}"


# ============================================================
# DOMAIN CATEGORIES
# ============================================================

filter_family "DE_Domain_Family_Germany" \
    "${de_family[@]}"

filter_family "EU_Domain_Family_Germany" \
    "${eu_family[@]}"

filter_family "ORG_Domain_Family_Germany" \
    "${org_family[@]}"


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

filter_family "Education_Family_Germany" \
    "${education_family[@]}"

filter_family "Government_Family_Germany" \
    "${government_family[@]}"

filter_family "Business_Family_Germany" \
    "${business_family[@]}"


# ============================================================
# STATES
# ============================================================

filter_family "BadenWuerttemberg_Family_Germany" \
    "${badenwuerttemberg_family[@]}"

filter_family "Bayern_Family_Germany" \
    "${bayern_family[@]}"

filter_family "Berlin_Family_Germany" \
    "${berlin_family[@]}"

filter_family "Brandenburg_Family_Germany" \
    "${brandenburg_family[@]}"

filter_family "Bremen_Family_Germany" \
    "${bremen_family[@]}"

filter_family "Hamburg_Family_Germany" \
    "${hamburg_family[@]}"

filter_family "Hessen_Family_Germany" \
    "${hessen_family[@]}"

filter_family "MecklenburgVorpommern_Family_Germany" \
    "${mecklenburgvorpommern_family[@]}"

filter_family "Niedersachsen_Family_Germany" \
    "${niedersachsen_family[@]}"

filter_family "NordrheinWestfalen_Family_Germany" \
    "${nordrheinwestfalen_family[@]}"

filter_family "RheinlandPfalz_Family_Germany" \
    "${rheinlandpfalz_family[@]}"

filter_family "Saarland_Family_Germany" \
    "${saarland_family[@]}"

filter_family "Sachsen_Family_Germany" \
    "${sachsen_family[@]}"

filter_family "SachsenAnhalt_Family_Germany" \
    "${sachsenanhalt_family[@]}"

filter_family "SchleswigHolstein_Family_Germany" \
    "${schleswigholstein_family[@]}"

filter_family "Thueringen_Family_Germany" \
    "${thueringen_family[@]}"


# ============================================================
# OTHER
# ============================================================

OTHER="$OUTPUT/Other_Mail_Germany[${TOTAL}].txt"

cp "$EMAILS" "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")

mv "$OTHER" \
    "$OUTPUT/Other_Mail_Germany[${OTHER_COUNT}].txt"


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
