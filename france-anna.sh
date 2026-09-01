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
    printf "    ${LIGHTGREEN}     o|* *|o  FRANCE EMAIL FILTER ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  ==================== ${NC}\n"
    printf "    ${LIGHTGREEN}      \\===/ ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}    ___|||___ ${NC}\n"
}

clear
header

echo ""
echo "=========================================================================="
printf "${LIGHTCYAN}${BOLD}FRANCE EMAIL FAMILY FILTER${NC}\n"
echo "=========================================================================="
echo ""

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/france_mail_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# FRENCH WEBMAIL / PROVIDER FAMILIES
# ============================================================

orange_family=(
    orange
)

wanadoo_family=(
    wanadoo
)

sfr_family=(
    sfr
)

free_family=(
    free
)

laposte_family=(
    laposte
)

numericable_family=(
    numericable
)

bouyguestelecom_family=(
    bouyguestelecom
    bouygues
)

neuf_family=(
    neuf
)

alice_family=(
    alice
)

bbox_family=(
    bbox
)

voila_family=(
    voila
)

clubinternet_family=(
    club-internet
    clubinternet
)


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
# FRENCH DOMAIN CATEGORIES
# ============================================================

fr_family=(
    fr
)

eu_family=(
    eu
)

org_family=(
    org
)


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

education_family=(
    education
    educ
    universite
    université
    univ
    ac
)

government_family=(
    gouv
    gouvernement
    ministere
    ministère
    mairie
    prefecture
    préfecture
)

business_family=(
    entreprise
    entreprises
    societe
    société
    sas
    sarl
    sa
    eurl
)


# ============================================================
# FRANCE REGIONS
# ============================================================

auvergnerhonealpes_family=(
    auvergne-rhone-alpes
    auvergnerhonealpes
)

bourgognefranchecomte_family=(
    bourgogne-franche-comte
    bourgognefranchecomte
)

bretagne_family=(
    bretagne
)

centrevaldeloire_family=(
    centre-val-de-loire
    centrevaldeloire
)

corse_family=(
    corse
)

grandest_family=(
    grand-est
    grandest
)

hautsdefrance_family=(
    hauts-de-france
    hautsdefrance
)

iledefrance_family=(
    ile-de-france
    iledefrance
)

normandie_family=(
    normandie
)

nouvelleaquitaine_family=(
    nouvelle-aquitaine
    nouvelleaquitaine
)

occitanie_family=(
    occitanie
)

paysdelaloire_family=(
    pays-de-la-loire
    paysdelaloire
)

provencealpescotedazur_family=(
    provence-alpes-cote-d-azur
    provencealpescotedazur
    paca
)


# ============================================================
# OVERSEAS REGIONS
# ============================================================

guadeloupe_family=(
    guadeloupe
)

martinique_family=(
    martinique
)

guyane_family=(
    guyane
    guyana
)

la_reunion_family=(
    reunion
    la-reunion
)

mayotte_family=(
    mayotte
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

        printf "${GREEN}[OK] %-50s %s${NC}\n" \
            "$NAME" "$COUNT"

    else

        rm -f "$TMP"

    fi
}


# ============================================================
# FRENCH PROVIDERS
# ============================================================

filter_family "Orange_Family_France" "${orange_family[@]}"
filter_family "Wanadoo_Family_France" "${wanadoo_family[@]}"
filter_family "SFR_Family_France" "${sfr_family[@]}"
filter_family "Free_Family_France" "${free_family[@]}"
filter_family "LaPoste_Family_France" "${laposte_family[@]}"
filter_family "Numericable_Family_France" "${numericable_family[@]}"
filter_family "BouyguesTelecom_Family_France" "${bouyguestelecom_family[@]}"
filter_family "Neuf_Family_France" "${neuf_family[@]}"
filter_family "Alice_Family_France" "${alice_family[@]}"
filter_family "BBox_Family_France" "${bbox_family[@]}"
filter_family "Voila_Family_France" "${voila_family[@]}"
filter_family "ClubInternet_Family_France" "${clubinternet_family[@]}"


# ============================================================
# INTERNATIONAL PROVIDERS
# ============================================================

filter_family "Microsoft_Family_France" "${microsoft_family[@]}"
filter_family "Google_Family_France" "${google_family[@]}"
filter_family "Yahoo_Family_France" "${yahoo_family[@]}"
filter_family "Apple_Family_France" "${apple_family[@]}"
filter_family "AOL_Family_France" "${aol_family[@]}"
filter_family "Proton_Family_France" "${proton_family[@]}"
filter_family "Tuta_Family_France" "${tuta_family[@]}"


# ============================================================
# DOMAIN CATEGORIES
# ============================================================

filter_family "FR_Domain_Family_France" "${fr_family[@]}"
filter_family "EU_Domain_Family_France" "${eu_family[@]}"
filter_family "ORG_Domain_Family_France" "${org_family[@]}"


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

filter_family "Education_Family_France" "${education_family[@]}"
filter_family "Government_Family_France" "${government_family[@]}"
filter_family "Business_Family_France" "${business_family[@]}"


# ============================================================
# REGIONS
# ============================================================

filter_family "AuvergneRhoneAlpes_Family_France" \
    "${auvergnerhonealpes_family[@]}"

filter_family "BourgogneFrancheComte_Family_France" \
    "${bourgognefranchecomte_family[@]}"

filter_family "Bretagne_Family_France" \
    "${bretagne_family[@]}"

filter_family "CentreValDeLoire_Family_France" \
    "${centrevaldeloire_family[@]}"

filter_family "Corse_Family_France" \
    "${corse_family[@]}"

filter_family "GrandEst_Family_France" \
    "${grandest_family[@]}"

filter_family "HautsDeFrance_Family_France" \
    "${hautsdefrance_family[@]}"

filter_family "IleDeFrance_Family_France" \
    "${iledefrance_family[@]}"

filter_family "Normandie_Family_France" \
    "${normandie_family[@]}"

filter_family "NouvelleAquitaine_Family_France" \
    "${nouvelleaquitaine_family[@]}"

filter_family "Occitanie_Family_France" \
    "${occitanie_family[@]}"

filter_family "PaysDeLaLoire_Family_France" \
    "${paysdelaloire_family[@]}"

filter_family "ProvenceAlpesCoteDAzur_Family_France" \
    "${provencealpescotedazur_family[@]}"


# ============================================================
# OVERSEAS REGIONS
# ============================================================

filter_family "Guadeloupe_Family_France" \
    "${guadeloupe_family[@]}"

filter_family "Martinique_Family_France" \
    "${martinique_family[@]}"

filter_family "Guyane_Family_France" \
    "${guyane_family[@]}"

filter_family "LaReunion_Family_France" \
    "${la_reunion_family[@]}"

filter_family "Mayotte_Family_France" \
    "${mayotte_family[@]}"


# ============================================================
# OTHER
# ============================================================

OTHER="$OUTPUT/Other_Mail_France[${TOTAL}].txt"

cp "$EMAILS" "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")

mv "$OTHER" \
    "$OUTPUT/Other_Mail_France[${OTHER_COUNT}].txt"


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
