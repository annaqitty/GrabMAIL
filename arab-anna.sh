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
  printf "    ${LIGHTGREEN}       ||| ${NC}\n  "
  printf "${LIGHTGREEN}    ___|||___${NC}\n"
}


# ============================================================
# START
# ============================================================

clear
header

echo ""
echo "__________________________________________________________________________________"
echo ""
printf "${LIGHTCYAN}${BOLD}GrabMAIL UAE / UNITED ARAB EMIRATES${NC}\n"
printf "Region   : United Arab Emirates\n"
printf "Purpose  : Authorized email-domain classification\n"
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

TMP_DIR="${TMPDIR:-/tmp}/uae_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# UAE TELECOM / ISP FAMILIES
# ============================================================

etisalat_family=(
    etisalat.ae
    etisalat.com
    etisalat.com.ae
)

du_family=(
    du.ae
    du.com
)

virgin_mobile_family=(
    virginmobile.ae
)

swyp_family=(
    swyp.ae
)

eand_family=(
    eand.com
    eand.ae
)


# ============================================================
# UAE MAIL / BUSINESS DOMAIN FAMILIES
# ============================================================

emirates_family=(
    emirates.com
    emirates.net
    emirates.ae
)

emirates_post_family=(
    emiratespost.ae
)

uae_exchange_family=(
    uaexchange.com
    uaeexchange.com
)

al_fardan_family=(
    alfardan.com
)

damac_family=(
    damacgroup.com
)

aldar_family=(
    aldar.com
)

emaar_family=(
    emaar.ae
    emaar.com
)


# ============================================================
# INTERNATIONAL WEBMAIL
# ============================================================

microsoft_family=(
    hotmail.com
    outlook.com
    live.com
    msn.com
)

yahoo_family=(
    yahoo.com
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

proton_family=(
    proton.me
    protonmail.com
)

tuta_family=(
    tuta.com
    tutanota.com
)

aol_family=(
    aol.com
)


# ============================================================
# UAE DOMAIN CATEGORIES
# ============================================================

ae_family=(
    ae
)

com_ae_family=(
    com.ae
)

net_ae_family=(
    net.ae
)

org_ae_family=(
    org.ae
)

gov_ae_family=(
    gov.ae
)

edu_ae_family=(
    edu.ae
)

mil_ae_family=(
    mil.ae
)

sch_ae_family=(
    sch.ae
)

ac_ae_family=(
    ac.ae
)


# ============================================================
# UAE ORGANIZATION CATEGORIES
# ============================================================

government_family=(
    gov.ae
    government
)

education_family=(
    edu.ae
    ac.ae
    university
    college
)

military_family=(
    mil.ae
)

organization_family=(
    org.ae
)


# ============================================================
# UAE EMIRATE KEYWORDS
#
# These are domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

abu_dhabi_family=(
    abudhabi
    abu-dhabi
)

dubai_family=(
    dubai
)

sharjah_family=(
    sharjah
)

ajman_family=(
    ajman
)

umm_al_quwain_family=(
    ummalquwain
    umm-al-quwain
)

ras_al_khaimah_family=(
    rasalkhaimah
    ras-al-khaimah
)

fujairah_family=(
    fujairah
)


# ============================================================
# UAE CITY / AREA KEYWORDS
# ============================================================

al_ain_family=(
    alain
    al-ain
)

jebel_ali_family=(
    jebelali
    jebel-ali
)

deira_family=(
    deira
)

bur_dubai_family=(
    burdubai
    bur-dubai
)

jumeirah_family=(
    jumeirah
)

downtown_dubai_family=(
    downtowndubai
    downtown-dubai
)

business_bay_family=(
    businessbay
    business-bay
)

masdar_family=(
    masdar
)

khalifa_city_family=(
    khalifacity
    khalifa-city
)


# ============================================================
# ARABIC IDN
#
# Common UAE-related IDN labels represented in punycode.
# ============================================================

arabic_idn_family=(
    xn--mgbaam7a8h
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
# REGISTER UAE TELECOM
# ============================================================

add_family "Etisalat_Family_UAE" "${etisalat_family[@]}"
add_family "Du_Family_UAE" "${du_family[@]}"
add_family "VirginMobile_Family_UAE" "${virgin_mobile_family[@]}"
add_family "Swyp_Family_UAE" "${swyp_family[@]}"
add_family "eAnd_Family_UAE" "${eand_family[@]}"


# ============================================================
# REGISTER UAE BUSINESS DOMAINS
# ============================================================

add_family "Emirates_Family_UAE" "${emirates_family[@]}"
add_family "EmiratesPost_Family_UAE" "${emirates_post_family[@]}"
add_family "UAEExchange_Family_UAE" "${uae_exchange_family[@]}"
add_family "AlFardan_Family_UAE" "${al_fardan_family[@]}"
add_family "DAMAC_Family_UAE" "${damac_family[@]}"
add_family "Aldar_Family_UAE" "${aldar_family[@]}"
add_family "Emaar_Family_UAE" "${emaar_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL WEBMAIL
# ============================================================

add_family "Microsoft_Family_UAE" "${microsoft_family[@]}"
add_family "Yahoo_Family_UAE" "${yahoo_family[@]}"
add_family "Google_Family_UAE" "${google_family[@]}"
add_family "Apple_Family_UAE" "${apple_family[@]}"
add_family "Proton_Family_UAE" "${proton_family[@]}"
add_family "Tuta_Family_UAE" "${tuta_family[@]}"
add_family "AOL_Family_UAE" "${aol_family[@]}"


# ============================================================
# REGISTER UAE TLD FAMILIES
# ============================================================

add_family "AE_Domain_Family_UAE" "${ae_family[@]}"
add_family "COM_AE_Domain_Family_UAE" "${com_ae_family[@]}"
add_family "NET_AE_Domain_Family_UAE" "${net_ae_family[@]}"
add_family "ORG_AE_Domain_Family_UAE" "${org_ae_family[@]}"
add_family "GOV_AE_Domain_Family_UAE" "${gov_ae_family[@]}"
add_family "EDU_AE_Domain_Family_UAE" "${edu_ae_family[@]}"
add_family "MIL_AE_Domain_Family_UAE" "${mil_ae_family[@]}"
add_family "SCH_AE_Domain_Family_UAE" "${sch_ae_family[@]}"
add_family "AC_AE_Domain_Family_UAE" "${ac_ae_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Government_Family_UAE" "${government_family[@]}"
add_family "Education_Family_UAE" "${education_family[@]}"
add_family "Military_Family_UAE" "${military_family[@]}"
add_family "Organization_Family_UAE" "${organization_family[@]}"


# ============================================================
# REGISTER EMIRATES
# ============================================================

add_family "AbuDhabi_Family_UAE" "${abu_dhabi_family[@]}"
add_family "Dubai_Family_UAE" "${dubai_family[@]}"
add_family "Sharjah_Family_UAE" "${sharjah_family[@]}"
add_family "Ajman_Family_UAE" "${ajman_family[@]}"
add_family "UmmAlQuwain_Family_UAE" "${umm_al_quwain_family[@]}"
add_family "RasAlKhaimah_Family_UAE" "${ras_al_khaimah_family[@]}"
add_family "Fujairah_Family_UAE" "${fujairah_family[@]}"


# ============================================================
# REGISTER CITY / AREA FAMILIES
# ============================================================

add_family "AlAin_Family_UAE" "${al_ain_family[@]}"
add_family "JebelAli_Family_UAE" "${jebel_ali_family[@]}"
add_family "Deira_Family_UAE" "${deira_family[@]}"
add_family "BurDubai_Family_UAE" "${bur_dubai_family[@]}"
add_family "Jumeirah_Family_UAE" "${jumeirah_family[@]}"
add_family "DowntownDubai_Family_UAE" "${downtown_dubai_family[@]}"
add_family "BusinessBay_Family_UAE" "${business_bay_family[@]}"
add_family "Masdar_Family_UAE" "${masdar_family[@]}"
add_family "KhalifaCity_Family_UAE" "${khalifa_city_family[@]}"


# ============================================================
# REGISTER ARABIC IDN
# ============================================================

add_family "Arabic_IDN_Family_UAE" "${arabic_idn_family[@]}"


# ============================================================
# OUTPUT
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


# ============================================================
# CLASSIFICATION
# ============================================================

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
    "$OUTPUT/Other_Mail_UAE[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-40s %s${NC}\n" \
    "Other_Mail_UAE" "$OTHER_COUNT"


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
