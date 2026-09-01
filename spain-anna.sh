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
    printf "    ${LIGHTGREEN}     o|* *|o  SPAIN EMAIL FILTER ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  =================== ${NC}\n"
    printf "    ${LIGHTGREEN}      \\===/ ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}    ___|||___ ${NC}\n"
}

clear
header

echo ""
echo "=========================================================================="
printf "${LIGHTCYAN}${BOLD}SPAIN EMAIL FAMILY FILTER${NC}\n"
echo "=========================================================================="
echo ""

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/spain_mail_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# SPANISH WEBMAIL / PROVIDER FAMILIES
# ============================================================

telefonica_family=(
    telefonica
)

movistar_family=(
    movistar
)

orange_family=(
    orange
)

vodafone_family=(
    vodafone
)

yahoo_es_family=(
    yahoo
)

terra_family=(
    terra
)

wanadoo_family=(
    wanadoo
)

eresmas_family=(
    eresmas
)

ono_family=(
    ono
)

ya_com_family=(
    ya
)

mixmail_family=(
    mixmail
)

infonegocio_family=(
    infonegocio
)

mail_es_family=(
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
# SPAIN DOMAIN CATEGORIES
# ============================================================

es_family=(
    es
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
    edu
    universidad
    univ
    uni
    upm
    upc
    ugr
    us
    uma
    uam
    ucm
)

government_family=(
    gob
    gobierno
    administracion
    administracionpublica
    ayuntamiento
    diputacion
)

business_family=(
    empresa
    empresas
    sociedad
    sa
    sl
    sll
    slu
    sc
)


# ============================================================
# SPAIN AUTONOMOUS COMMUNITIES
# ============================================================

andalucia_family=(
    andalucia
    andalucía
)

aragon_family=(
    aragon
    aragón
)

asturias_family=(
    asturias
)

illesbalears_family=(
    illes-balears
    illesbalears
    baleares
    mallorca
)

canarias_family=(
    canarias
    tenerife
    gran-canaria
    grancanaria
)

cantabria_family=(
    cantabria
)

castillalamancha_family=(
    castilla-la-mancha
    castillalamancha
)

castillayleon_family=(
    castilla-y-leon
    castillayleon
)

cataluna_family=(
    cataluna
    cataluña
    catalunya
)

comunitatvalenciana_family=(
    comunitat-valenciana
    comunitatvalenciana
    valencia
    valenciana
)

extremadura_family=(
    extremadura
)

galicia_family=(
    galicia
    galiza
)

madrid_family=(
    madrid
)

murcia_family=(
    murcia
)

navarra_family=(
    navarra
)

paisvasco_family=(
    pais-vasco
    paisvasco
    euskadi
)

larioja_family=(
    la-rioja
    larioja
    rioja
)


# ============================================================
# AUTONOMOUS CITIES
# ============================================================

ceuta_family=(
    ceuta
)

melilla_family=(
    melilla
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
# SPANISH PROVIDERS
# ============================================================

filter_family "Telefonica_Family_Spain" "${telefonica_family[@]}"
filter_family "Movistar_Family_Spain" "${movistar_family[@]}"
filter_family "Orange_Family_Spain" "${orange_family[@]}"
filter_family "Vodafone_Family_Spain" "${vodafone_family[@]}"
filter_family "Yahoo_Family_Spain" "${yahoo_es_family[@]}"
filter_family "Terra_Family_Spain" "${terra_family[@]}"
filter_family "Wanadoo_Family_Spain" "${wanadoo_family[@]}"
filter_family "Eresmas_Family_Spain" "${eresmas_family[@]}"
filter_family "ONO_Family_Spain" "${ono_family[@]}"
filter_family "YA_Family_Spain" "${ya_com_family[@]}"
filter_family "Mixmail_Family_Spain" "${mixmail_family[@]}"
filter_family "InfoNegocio_Family_Spain" "${infonegocio_family[@]}"


# ============================================================
# INTERNATIONAL PROVIDERS
# ============================================================

filter_family "Microsoft_Family_Spain" "${microsoft_family[@]}"
filter_family "Google_Family_Spain" "${google_family[@]}"
filter_family "Yahoo_Family_Spain" "${yahoo_family[@]}"
filter_family "Apple_Family_Spain" "${apple_family[@]}"
filter_family "AOL_Family_Spain" "${aol_family[@]}"
filter_family "Proton_Family_Spain" "${proton_family[@]}"
filter_family "Tuta_Family_Spain" "${tuta_family[@]}"


# ============================================================
# DOMAIN CATEGORIES
# ============================================================

filter_family "ES_Domain_Family_Spain" "${es_family[@]}"
filter_family "EU_Domain_Family_Spain" "${eu_family[@]}"
filter_family "ORG_Domain_Family_Spain" "${org_family[@]}"


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

filter_family "Education_Family_Spain" "${education_family[@]}"
filter_family "Government_Family_Spain" "${government_family[@]}"
filter_family "Business_Family_Spain" "${business_family[@]}"


# ============================================================
# AUTONOMOUS COMMUNITIES
# ============================================================

filter_family "Andalucia_Family_Spain" \
    "${andalucia_family[@]}"

filter_family "Aragon_Family_Spain" \
    "${aragon_family[@]}"

filter_family "Asturias_Family_Spain" \
    "${asturias_family[@]}"

filter_family "IllesBalears_Family_Spain" \
    "${illesbalears_family[@]}"

filter_family "Canarias_Family_Spain" \
    "${canarias_family[@]}"

filter_family "Cantabria_Family_Spain" \
    "${cantabria_family[@]}"

filter_family "CastillaLaMancha_Family_Spain" \
    "${castillalamancha_family[@]}"

filter_family "CastillaYLeon_Family_Spain" \
    "${castillayleon_family[@]}"

filter_family "Cataluna_Family_Spain" \
    "${cataluna_family[@]}"

filter_family "ComunitatValenciana_Family_Spain" \
    "${comunitatvalenciana_family[@]}"

filter_family "Extremadura_Family_Spain" \
    "${extremadura_family[@]}"

filter_family "Galicia_Family_Spain" \
    "${galicia_family[@]}"

filter_family "Madrid_Family_Spain" \
    "${madrid_family[@]}"

filter_family "Murcia_Family_Spain" \
    "${murcia_family[@]}"

filter_family "Navarra_Family_Spain" \
    "${navarra_family[@]}"

filter_family "PaisVasco_Family_Spain" \
    "${paisvasco_family[@]}"

filter_family "LaRioja_Family_Spain" \
    "${larioja_family[@]}"


# ============================================================
# AUTONOMOUS CITIES
# ============================================================

filter_family "Ceuta_Family_Spain" \
    "${ceuta_family[@]}"

filter_family "Melilla_Family_Spain" \
    "${melilla_family[@]}"


# ============================================================
# OTHER
# ============================================================

OTHER="$OUTPUT/Other_Mail_Spain[${TOTAL}].txt"

cp "$EMAILS" "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")

mv "$OTHER" \
    "$OUTPUT/Other_Mail_Spain[${OTHER_COUNT}].txt"


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
