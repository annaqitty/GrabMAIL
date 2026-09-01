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
printf "${LIGHTCYAN}${BOLD}GrabMAIL BELGIUM${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Belgium / België / Belgique\n"
printf "Date     : 01 September 2026\n"
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

TMP_DIR="${TMPDIR:-/tmp}/belgium_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# BELGIUM MAIL / ISP PROVIDERS
# ============================================================

proximus_family=(
    proximus.be
    proximus.com
    belgacom.be
)

skynet_family=(
    skynet.be
)

telenet_family=(
    telenet.be
)

base_family=(
    base.be
)

scarlet_family=(
    scarlet.be
)

voo_family=(
    voo.be
)

edpnet_family=(
    edpnet.be
)

orange_be_family=(
    orange.be
    mobistar.be
)

telnet_family=(
    telnet.be
)

pandora_family=(
    pandora.be
)

belcenter_family=(
    belcenter.be
)

dommel_family=(
    dommel.be
)

numericable_family=(
    numericable.be
)

tele2_family=(
    tele2.be
)

versatel_family=(
    versatel.be
)


# ============================================================
# BELGIUM BUSINESS / MAIL HOST FAMILIES
# ============================================================

mail_be_family=(
    mail.be
)

email_be_family=(
    email.be
)

belgacom_family=(
    belgacom.be
)

scarlet_mail_family=(
    scarlet.be
)

telenet_mail_family=(
    telenet.be
)

skynet_mail_family=(
    skynet.be
)


# ============================================================
# INTERNATIONAL PROVIDERS COMMONLY USED IN BELGIUM
# ============================================================

microsoft_family=(
    hotmail.com
    hotmail.be
    live.com
    outlook.com
    msn.com
)

yahoo_family=(
    yahoo.com
    yahoo.be
    ymail.com
    rocketmail.com
)

google_family=(
    gmail.com
    googlemail.com
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
# BELGIUM DOMAIN CATEGORIES
# ============================================================

be_family=(
    be
)

com_be_family=(
    com.be
)

net_be_family=(
    net.be
)

org_be_family=(
    org.be
)

gov_be_family=(
    gov.be
)

edu_be_family=(
    edu.be
)

ac_be_family=(
    ac.be
)


# ============================================================
# BELGIUM ORGANIZATION CATEGORIES
# ============================================================

government_family=(
    gov.be
    government
)

education_family=(
    edu.be
    ac.be
    university
    universiteit
    universite
    hogeschool
)

organization_family=(
    org.be
)


# ============================================================
# BELGIUM LANGUAGE / NATIONAL KEYWORDS
# ============================================================

belgium_family=(
    belgium
    belgique
    belgie
    België
)

french_belgium_family=(
    belgique
    bruxelles
    wallonie
)

dutch_belgium_family=(
    belgie
    vlaanderen
    brussel
)

german_belgium_family=(
    ostbelgien
    deutschsprachig
)


# ============================================================
# BELGIUM REGIONS
#
# These are domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

brussels_family=(
    brussels
    bruxelles
    brussel
)

flanders_family=(
    flanders
    vlaanderen
    vlaams
)

wallonia_family=(
    wallonia
    wallonie
    waals
)

east_flanders_family=(
    eastflanders
    oostvlaanderen
    oost-vlaanderen
)

west_flanders_family=(
    westflanders
    westvlaanderen
    west-vlaanderen
)

antwerp_family=(
    antwerp
    antwerpen
    anvers
)

limburg_family=(
    limburg
)

flemish_brabant_family=(
    flemishbrabant
    vlaamsbrabant
    vlaams-brabant
)

walloon_brabant_family=(
    walloonbrabant
    brabantwallon
    brabant-wallon
)

hainaut_family=(
    hainaut
    henegouwen
)

liege_family=(
    liege
    liegeprovince
    luik
)

luxembourg_be_family=(
    luxembourg
    luxemburg
)

namur_family=(
    namur
    namen
)


# ============================================================
# MAJOR BELGIUM CITIES
# ============================================================

ghent_family=(
    ghent
    gent
)

bruges_family=(
    bruges
    brugge
)

leuven_family=(
    leuven
    louvain
)

mechelen_family=(
    mechelen
    malines
)

charleroi_family=(
    charleroi
)

mons_family=(
    mons
    bergen
)

hasselt_family=(
    hasselt
)

kortrijk_family=(
    kortrijk
    courtrai
)

ostend_family=(
    ostend
    oostende
)

tournai_family=(
    tournai
    doornik
)

arlon_family=(
    arlon
    aarlen
)

eupen_family=(
    eupen
)

genk_family=(
    genk
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
# REGISTER BELGIUM ISP / PROVIDERS
# ============================================================

add_family "Proximus_Family_BELGIUM" "${proximus_family[@]}"
add_family "Skynet_Family_BELGIUM" "${skynet_family[@]}"
add_family "Telenet_Family_BELGIUM" "${telenet_family[@]}"
add_family "BASE_Family_BELGIUM" "${base_family[@]}"
add_family "Scarlet_Family_BELGIUM" "${scarlet_family[@]}"
add_family "VOO_Family_BELGIUM" "${voo_family[@]}"
add_family "EDPnet_Family_BELGIUM" "${edpnet_family[@]}"
add_family "Orange_Family_BELGIUM" "${orange_be_family[@]}"
add_family "Telnet_Family_BELGIUM" "${telnet_family[@]}"
add_family "Pandora_Family_BELGIUM" "${pandora_family[@]}"
add_family "BelCenter_Family_BELGIUM" "${belcenter_family[@]}"
add_family "Dommel_Family_BELGIUM" "${dommel_family[@]}"
add_family "Numericable_Family_BELGIUM" "${numericable_family[@]}"
add_family "Tele2_Family_BELGIUM" "${tele2_family[@]}"
add_family "Versatel_Family_BELGIUM" "${versatel_family[@]}"


# ============================================================
# REGISTER BELGIUM MAIL FAMILIES
# ============================================================

add_family "Mail_BE_Family_BELGIUM" "${mail_be_family[@]}"
add_family "Email_BE_Family_BELGIUM" "${email_be_family[@]}"
add_family "Belgacom_Family_BELGIUM" "${belgacom_family[@]}"
add_family "ScarletMail_Family_BELGIUM" "${scarlet_mail_family[@]}"
add_family "TelenetMail_Family_BELGIUM" "${telenet_mail_family[@]}"
add_family "SkynetMail_Family_BELGIUM" "${skynet_mail_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL WEBMAIL
# ============================================================

add_family "Microsoft_Family_BELGIUM" "${microsoft_family[@]}"
add_family "Yahoo_Family_BELGIUM" "${yahoo_family[@]}"
add_family "Google_Family_BELGIUM" "${google_family[@]}"
add_family "Apple_Family_BELGIUM" "${apple_family[@]}"
add_family "AOL_Family_BELGIUM" "${aol_family[@]}"
add_family "Proton_Family_BELGIUM" "${proton_family[@]}"
add_family "Tuta_Family_BELGIUM" "${tuta_family[@]}"


# ============================================================
# REGISTER BELGIUM TLD FAMILIES
# ============================================================

add_family "BE_Domain_Family_BELGIUM" "${be_family[@]}"
add_family "COM_BE_Domain_Family_BELGIUM" "${com_be_family[@]}"
add_family "NET_BE_Domain_Family_BELGIUM" "${net_be_family[@]}"
add_family "ORG_BE_Domain_Family_BELGIUM" "${org_be_family[@]}"
add_family "GOV_BE_Domain_Family_BELGIUM" "${gov_be_family[@]}"
add_family "EDU_BE_Domain_Family_BELGIUM" "${edu_be_family[@]}"
add_family "AC_BE_Domain_Family_BELGIUM" "${ac_be_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Government_Family_BELGIUM" "${government_family[@]}"
add_family "Education_Family_BELGIUM" "${education_family[@]}"
add_family "Organization_Family_BELGIUM" "${organization_family[@]}"


# ============================================================
# REGISTER NATIONAL / LANGUAGE KEYWORDS
# ============================================================

add_family "Belgium_Family_BELGIUM" "${belgium_family[@]}"
add_family "FrenchBelgium_Family_BELGIUM" "${french_belgium_family[@]}"
add_family "DutchBelgium_Family_BELGIUM" "${dutch_belgium_family[@]}"
add_family "GermanBelgium_Family_BELGIUM" "${german_belgium_family[@]}"


# ============================================================
# REGISTER REGIONS
# ============================================================

add_family "Brussels_Family_BELGIUM" "${brussels_family[@]}"
add_family "Flanders_Family_BELGIUM" "${flanders_family[@]}"
add_family "Wallonia_Family_BELGIUM" "${wallonia_family[@]}"
add_family "EastFlanders_Family_BELGIUM" "${east_flanders_family[@]}"
add_family "WestFlanders_Family_BELGIUM" "${west_flanders_family[@]}"
add_family "Antwerp_Family_BELGIUM" "${antwerp_family[@]}"
add_family "Limburg_Family_BELGIUM" "${limburg_family[@]}"
add_family "FlemishBrabant_Family_BELGIUM" "${flemish_brabant_family[@]}"
add_family "WalloonBrabant_Family_BELGIUM" "${walloon_brabant_family[@]}"
add_family "Hainaut_Family_BELGIUM" "${hainaut_family[@]}"
add_family "Liege_Family_BELGIUM" "${liege_family[@]}"
add_family "Luxembourg_Family_BELGIUM" "${luxembourg_be_family[@]}"
add_family "Namur_Family_BELGIUM" "${namur_family[@]}"


# ============================================================
# REGISTER MAJOR CITIES
# ============================================================

add_family "Ghent_Family_BELGIUM" "${ghent_family[@]}"
add_family "Bruges_Family_BELGIUM" "${bruges_family[@]}"
add_family "Leuven_Family_BELGIUM" "${leuven_family[@]}"
add_family "Mechelen_Family_BELGIUM" "${mechelen_family[@]}"
add_family "Charleroi_Family_BELGIUM" "${charleroi_family[@]}"
add_family "Mons_Family_BELGIUM" "${mons_family[@]}"
add_family "Hasselt_Family_BELGIUM" "${hasselt_family[@]}"
add_family "Kortrijk_Family_BELGIUM" "${kortrijk_family[@]}"
add_family "Ostend_Family_BELGIUM" "${ostend_family[@]}"
add_family "Tournai_Family_BELGIUM" "${tournai_family[@]}"
add_family "Arlon_Family_BELGIUM" "${arlon_family[@]}"
add_family "Eupen_Family_BELGIUM" "${eupen_family[@]}"
add_family "Genk_Family_BELGIUM" "${genk_family[@]}"


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
    "$OUTPUT/Other_Mail_BELGIUM[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-40s %s${NC}\n" \
    "Other_Mail_BELGIUM" "$OTHER_COUNT"


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
