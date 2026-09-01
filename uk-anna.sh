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
    printf "    ${LIGHTGREEN}     o|* *|o  UNITED KINGDOM EMAIL FILTER ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  ============================= ${NC}\n"
    printf "    ${LIGHTGREEN}      \\===/ ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}       ||| ${NC}\n"
    printf "    ${LIGHTGREEN}    ___|||___ ${NC}\n"
}

clear
header

echo ""
echo "=========================================================================="
printf "${LIGHTCYAN}${BOLD}UNITED KINGDOM EMAIL FAMILY FILTER${NC}\n"
echo "=========================================================================="
echo ""

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/uk_mail_filter_$$"
mkdir -p "$TMP_DIR"

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# UK ISP / WEBMAIL FAMILIES
# ============================================================

btinternet_family=(
    btinternet
)

bt_family=(
    bt
)

sky_family=(
    sky
)

virginmedia_family=(
    virginmedia
    virgin
)

talktalk_family=(
    talktalk
)

plusnet_family=(
    plus
    plusnet
)

ee_family=(
    ee
)

three_family=(
    three
)

giffgaff_family=(
    giffgaff
)

zen_family=(
    zen
)

aol_uk_family=(
    aol
)

ntlworld_family=(
    ntlworld
)

blueyonder_family=(
    blueyonder
)

tiscali_uk_family=(
    tiscali
)

ukonline_family=(
    ukonline
)

pipex_family=(
    pipex
)

demon_family=(
    demon
)

lineone_family=(
    lineone
)

freeserve_family=(
    freeserve
)

fsmail_family=(
    fsmail
)

tesco_family=(
    tesco
)

waitrose_family=(
    waitrose
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

proton_family=(
    proton
    protonmail
)

tuta_family=(
    tuta
    tutanota
)


# ============================================================
# UK DOMAIN CATEGORIES
# ============================================================

uk_family=(
    uk
)

co_uk_family=(
    co.uk
)

org_uk_family=(
    org.uk
)

me_uk_family=(
    me.uk
)

ac_uk_family=(
    ac.uk
)

gov_uk_family=(
    gov.uk
)

net_uk_family=(
    net.uk
)

sch_uk_family=(
    sch.uk
)


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

education_family=(
    ac.uk
    sch.uk
    university
    college
    school
)

government_family=(
    gov.uk
    government
    parliament
    council
)

business_family=(
    co.uk
    ltd
    limited
    plc
    llp
)


# ============================================================
# COUNTRIES / CONSTITUENT NATIONS
# ============================================================

england_family=(
    england
)

scotland_family=(
    scotland
    scot
)

wales_family=(
    wales
    cymru
)

northernireland_family=(
    northernireland
    northern-ireland
    ni
)


# ============================================================
# ENGLAND REGIONS
# ============================================================

eastengland_family=(
    east-of-england
    eastofengland
    eastengland
)

eastmidlands_family=(
    east-midlands
    eastmidlands
)

london_family=(
    london
)

northeastengland_family=(
    north-east
    northeast
    north-east-england
    northeastengland
)

northwestengland_family=(
    north-west
    northwest
    north-west-england
    northwestengland
)

southeastengland_family=(
    south-east
    southeast
    south-east-england
    southeastengland
)

southwestengland_family=(
    south-west
    southwest
    south-west-england
    southwestengland
)

westmidlands_family=(
    west-midlands
    westmidlands
)

yorkshirehumber_family=(
    yorkshire
    humber
    yorkshire-humber
    yorkshirehumber
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

        printf "${GREEN}[OK] %-55s %s${NC}\n" \
            "$NAME" "$COUNT"

    else
        rm -f "$TMP"
    fi
}


# ============================================================
# UK ISP PROVIDERS
# ============================================================

filter_family "BTInternet_Family_UK" "${btinternet_family[@]}"
filter_family "BT_Family_UK" "${bt_family[@]}"
filter_family "Sky_Family_UK" "${sky_family[@]}"
filter_family "VirginMedia_Family_UK" "${virginmedia_family[@]}"
filter_family "TalkTalk_Family_UK" "${talktalk_family[@]}"
filter_family "Plusnet_Family_UK" "${plusnet_family[@]}"
filter_family "EE_Family_UK" "${ee_family[@]}"
filter_family "Three_Family_UK" "${three_family[@]}"
filter_family "GiffGaff_Family_UK" "${giffgaff_family[@]}"
filter_family "Zen_Family_UK" "${zen_family[@]}"
filter_family "AOL_Family_UK" "${aol_uk_family[@]}"
filter_family "NTLWorld_Family_UK" "${ntlworld_family[@]}"
filter_family "BlueYonder_Family_UK" "${blueyonder_family[@]}"
filter_family "Tiscali_Family_UK" "${tiscali_uk_family[@]}"
filter_family "UKOnline_Family_UK" "${ukonline_family[@]}"
filter_family "Pipex_Family_UK" "${pipex_family[@]}"
filter_family "Demon_Family_UK" "${demon_family[@]}"
filter_family "LineOne_Family_UK" "${lineone_family[@]}"
filter_family "FreeServe_Family_UK" "${freeserve_family[@]}"
filter_family "FSMail_Family_UK" "${fsmail_family[@]}"
filter_family "Tesco_Family_UK" "${tesco_family[@]}"
filter_family "Waitrose_Family_UK" "${waitrose_family[@]}"


# ============================================================
# INTERNATIONAL PROVIDERS
# ============================================================

filter_family "Microsoft_Family_UK" "${microsoft_family[@]}"
filter_family "Google_Family_UK" "${google_family[@]}"
filter_family "Yahoo_Family_UK" "${yahoo_family[@]}"
filter_family "Apple_Family_UK" "${apple_family[@]}"
filter_family "Proton_Family_UK" "${proton_family[@]}"
filter_family "Tuta_Family_UK" "${tuta_family[@]}"


# ============================================================
# UK DOMAIN CATEGORIES
# ============================================================

filter_family "UK_Domain_Family_UK" "${uk_family[@]}"
filter_family "COUK_Domain_Family_UK" "${co_uk_family[@]}"
filter_family "ORGUK_Domain_Family_UK" "${org_uk_family[@]}"
filter_family "MEUK_Domain_Family_UK" "${me_uk_family[@]}"
filter_family "ACUK_Domain_Family_UK" "${ac_uk_family[@]}"
filter_family "GOVUK_Domain_Family_UK" "${gov_uk_family[@]}"
filter_family "NETUK_Domain_Family_UK" "${net_uk_family[@]}"
filter_family "SCHUK_Domain_Family_UK" "${sch_uk_family[@]}"


# ============================================================
# ORGANIZATION CATEGORIES
# ============================================================

filter_family "Education_Family_UK" "${education_family[@]}"
filter_family "Government_Family_UK" "${government_family[@]}"
filter_family "Business_Family_UK" "${business_family[@]}"


# ============================================================
# CONSTITUENT NATIONS
# ============================================================

filter_family "England_Family_UK" \
    "${england_family[@]}"

filter_family "Scotland_Family_UK" \
    "${scotland_family[@]}"

filter_family "Wales_Family_UK" \
    "${wales_family[@]}"

filter_family "NorthernIreland_Family_UK" \
    "${northernireland_family[@]}"


# ============================================================
# ENGLAND REGIONS
# ============================================================

filter_family "EastEngland_Family_UK" \
    "${eastengland_family[@]}"

filter_family "EastMidlands_Family_UK" \
    "${eastmidlands_family[@]}"

filter_family "London_Family_UK" \
    "${london_family[@]}"

filter_family "NorthEastEngland_Family_UK" \
    "${northeastengland_family[@]}"

filter_family "NorthWestEngland_Family_UK" \
    "${northwestengland_family[@]}"

filter_family "SouthEastEngland_Family_UK" \
    "${southeastengland_family[@]}"

filter_family "SouthWestEngland_Family_UK" \
    "${southwestengland_family[@]}"

filter_family "WestMidlands_Family_UK" \
    "${westmidlands_family[@]}"

filter_family "YorkshireHumber_Family_UK" \
    "${yorkshirehumber_family[@]}"


# ============================================================
# OTHER
# ============================================================

OTHER="$OUTPUT/Other_Mail_UK[${TOTAL}].txt"

cp "$EMAILS" "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")

mv "$OTHER" \
    "$OUTPUT/Other_Mail_UK[${OTHER_COUNT}].txt"


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
