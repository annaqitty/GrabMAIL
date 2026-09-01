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
    printf "    ${LIGHTGREEN}     o|* *|o  ITALIA EMAIL FILTER ${NC}\n"
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
printf "${LIGHTCYAN}${BOLD}ITALY EMAIL FAMILY FILTER${NC}\n"
echo "=========================================================================="
echo ""

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/italy_mail_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# ITALIAN WEBMAIL / PROVIDER FAMILIES
# ============================================================

libero_family=(
    libero
)

virgilio_family=(
    virgilio
)

alice_family=(
    alice
)

tim_family=(
    tim
)

tin_family=(
    tin
)

tiscali_family=(
    tiscali
)

aruba_family=(
    aruba
)

fastweb_family=(
    fastweb
)

poste_family=(
    poste
)

email_it_family=(
    email
)

mail_it_family=(
    mail
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
# ITALIAN DOMAIN CATEGORIES
# ============================================================

it_family=(
    it
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
    uni
    unibo
    unimi
    unipd
    unito
    unipi
    unina
    unige
    unipmn
    unisalento
)

government_family=(
    gov
    comune
    regione
    provincia
    ministero
    interno
)

business_family=(
    spa
    srl
    srls
    snc
    sas
)


# ============================================================
# ITALY REGIONS
# ============================================================

abruzzo_family=(
    abruzzo
)

basilicata_family=(
    basilicata
)

calabria_family=(
    calabria
)

campania_family=(
    campania
)

emiliaromagna_family=(
    emilia-romagna
    emiliaromagna
)

friuliveneziagiulia_family=(
    friuli-venezia-giulia
    friuliveneziagiulia
)

lazio_family=(
    lazio
)

liguria_family=(
    liguria
)

lombardia_family=(
    lombardia
    lombardy
)

marche_family=(
    marche
)

molise_family=(
    molise
)

piemonte_family=(
    piemonte
    piedmont
)

puglia_family=(
    puglia
)

sardegna_family=(
    sardegna
    sardinia
)

sicilia_family=(
    sicilia
    sicily
)

toscana_family=(
    toscana
    tuscany
)

trentinoaltoadige_family=(
    trentino-alto-adige
    trentinoaltoadige
    alto-adige
)

umbria_family=(
    umbria
)

valledaosta_family=(
    valle-daosta
    valledaosta
    aosta
)

veneto_family=(
    veneto
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
# ITALIAN WEBMAIL
# ============================================================

filter_family "Libero_Family_Italy" "${libero_family[@]}"
filter_family "Virgilio_Family_Italy" "${virgilio_family[@]}"
filter_family "Alice_Family_Italy" "${alice_family[@]}"
filter_family "TIM_Family_Italy" "${tim_family[@]}"
filter_family "TIN_Family_Italy" "${tin_family[@]}"
filter_family "Tiscali_Family_Italy" "${tiscali_family[@]}"
filter_family "Aruba_Family_Italy" "${aruba_family[@]}"
filter_family "Fastweb_Family_Italy" "${fastweb_family[@]}"
filter_family "Poste_Family_Italy" "${poste_family[@]}"


# ============================================================
# INTERNATIONAL WEBMAIL
# ============================================================

filter_family "Microsoft_Family_Italy" "${microsoft_family[@]}"
filter_family "Google_Family_Italy" "${google_family[@]}"
filter_family "Yahoo_Family_Italy" "${yahoo_family[@]}"
filter_family "Apple_Family_Italy" "${apple_family[@]}"
filter_family "AOL_Family_Italy" "${aol_family[@]}"
filter_family "Proton_Family_Italy" "${proton_family[@]}"
filter_family "Tuta_Family_Italy" "${tuta_family[@]}"


# ============================================================
# DOMAIN CATEGORIES
# ============================================================

filter_family "IT_Domain_Family_Italy" "${it_family[@]}"
filter_family "EU_Domain_Family_Italy" "${eu_family[@]}"
filter_family "ORG_Domain_Family_Italy" "${org_family[@]}"


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

filter_family "Education_Family_Italy" "${education_family[@]}"
filter_family "Government_Family_Italy" "${government_family[@]}"
filter_family "Business_Family_Italy" "${business_family[@]}"


# ============================================================
# REGIONS
# ============================================================

filter_family "Abruzzo_Family_Italy" \
    "${abruzzo_family[@]}"

filter_family "Basilicata_Family_Italy" \
    "${basilicata_family[@]}"

filter_family "Calabria_Family_Italy" \
    "${calabria_family[@]}"

filter_family "Campania_Family_Italy" \
    "${campania_family[@]}"

filter_family "EmiliaRomagna_Family_Italy" \
    "${emiliaromagna_family[@]}"

filter_family "FriuliVeneziaGiulia_Family_Italy" \
    "${friuliveneziagiulia_family[@]}"

filter_family "Lazio_Family_Italy" \
    "${lazio_family[@]}"

filter_family "Liguria_Family_Italy" \
    "${liguria_family[@]}"

filter_family "Lombardia_Family_Italy" \
    "${lombardia_family[@]}"

filter_family "Marche_Family_Italy" \
    "${marche_family[@]}"

filter_family "Molise_Family_Italy" \
    "${molise_family[@]}"

filter_family "Piemonte_Family_Italy" \
    "${piemonte_family[@]}"

filter_family "Puglia_Family_Italy" \
    "${puglia_family[@]}"

filter_family "Sardegna_Family_Italy" \
    "${sardegna_family[@]}"

filter_family "Sicilia_Family_Italy" \
    "${sicilia_family[@]}"

filter_family "Toscana_Family_Italy" \
    "${toscana_family[@]}"

filter_family "TrentinoAltoAdige_Family_Italy" \
    "${trentinoaltoadige_family[@]}"

filter_family "Umbria_Family_Italy" \
    "${umbria_family[@]}"

filter_family "ValleDAosta_Family_Italy" \
    "${valledaosta_family[@]}"

filter_family "Veneto_Family_Italy" \
    "${veneto_family[@]}"


# ============================================================
# OTHER
# ============================================================

OTHER="$OUTPUT/Other_Mail_Italy[${TOTAL}].txt"

cp "$EMAILS" "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")

mv "$OTHER" \
    "$OUTPUT/Other_Mail_Italy[${OTHER_COUNT}].txt"


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
