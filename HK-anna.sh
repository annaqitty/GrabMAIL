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
printf "${LIGHTCYAN}${BOLD}GrabMAIL HONG KONG${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Hong Kong\n"
printf "Date     : 28 July 2010\n"
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

TMP_DIR="${TMPDIR:-/tmp}/hongkong_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# HONG KONG MAIL PROVIDERS
# ============================================================

netvigator_family=(
    netvigator.com
)

hkcable_family=(
    hkcable.com.hk
    hkcable.net
)

hkbn_family=(
    hkbn.com.hk
    hkbn.net
)

hkt_family=(
    hkt.com
    hkt.com.hk
)

pccw_family=(
    pccw.com
    pccw.com.hk
)

i-cable_family=(
    i-cable.com
    i-cable.com.hk
)

y5zone_family=(
    y5zone.net
)

biznetvigator_family=(
    biznetvigator.com
)

sunday_family=(
    sunday.com
    sunday.com.hk
)

now_family=(
    now.com.hk
)


# ============================================================
# HONG KONG INTERNET / ISP FAMILIES
# ============================================================

hutchison_family=(
    hutchison
    hutchcity
)

smartone_family=(
    smartone
    smartone.com.hk
)

csl_family=(
    csl.com.hk
)

one2free_family=(
    one2free
)

newworld_family=(
    newworldtel
    newworld
)

broadband_family=(
    broadband
)


# ============================================================
# INTERNATIONAL PROVIDERS COMMONLY USED IN HONG KONG
# ============================================================

microsoft_family=(
    hotmail.com
    hotmail.com.hk
    live.com
    live.com.hk
    outlook.com
    outlook.com.hk
    msn.com
)

yahoo_family=(
    yahoo.com
    yahoo.com.hk
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
# HONG KONG DOMAIN CATEGORIES
# ============================================================

hk_family=(
    hk
)

com_hk_family=(
    com.hk
)

net_hk_family=(
    net.hk
)

org_hk_family=(
    org.hk
)

edu_hk_family=(
    edu.hk
)

gov_hk_family=(
    gov.hk
)

idv_hk_family=(
    idv.hk
)

inc_hk_family=(
    inc.hk
)

ltd_hk_family=(
    ltd.hk
)

group_hk_family=(
    group.hk
)


# ============================================================
# HONG KONG ORGANIZATION CATEGORIES
# ============================================================

education_family=(
    edu.hk
    university
    college
)

government_family=(
    gov.hk
    government
)

organization_family=(
    org.hk
)


# ============================================================
# HONG KONG LOCATION KEYWORDS
#
# These are domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

hongkong_family=(
    hongkong
    hong-kong
    hk
)

kowloon_family=(
    kowloon
)

central_family=(
    central
)

wanchai_family=(
    wanchai
    wan-chai
)

causewaybay_family=(
    causewaybay
    causeway-bay
)

tsimshatsui_family=(
    tsimshatsui
    tsim-sha-tsui
    tst
)

mongkok_family=(
    mongkok
    mong-kok
)

shatin_family=(
    shatin
    sha-tin
)

taipo_family=(
    taipo
    tai-po
)

tuenmun_family=(
    tuenmun
    tuen-mun
)

yuenlong_family=(
    yuenlong
    yuen-long
)

kwaitsing_family=(
    kwaitsing
    kwai-tsing
)

kwuntong_family=(
    kwuntong
    kwun-tong
)

northdistrict_family=(
    northdistrict
    north-district
)

islands_family=(
    islands
    islandsdistrict
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
# REGISTER HONG KONG MAIL FAMILIES
# ============================================================

add_family "Netvigator_Family_HK" "${netvigator_family[@]}"
add_family "HKCable_Family_HK" "${hkcable_family[@]}"
add_family "HKBN_Family_HK" "${hkbn_family[@]}"
add_family "HKT_Family_HK" "${hkt_family[@]}"
add_family "PCCW_Family_HK" "${pccw_family[@]}"
add_family "iCable_Family_HK" "${i-cable_family[@]}"
add_family "Y5Zone_Family_HK" "${y5zone_family[@]}"
add_family "BizNetvigator_Family_HK" "${biznetvigator_family[@]}"
add_family "Sunday_Family_HK" "${sunday_family[@]}"
add_family "NOW_Family_HK" "${now_family[@]}"


# ============================================================
# REGISTER HONG KONG ISP FAMILIES
# ============================================================

add_family "Hutchison_Family_HK" "${hutchison_family[@]}"
add_family "SmarTone_Family_HK" "${smartone_family[@]}"
add_family "CSL_Family_HK" "${csl_family[@]}"
add_family "One2Free_Family_HK" "${one2free_family[@]}"
add_family "NewWorld_Family_HK" "${newworld_family[@]}"
add_family "Broadband_Family_HK" "${broadband_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_HK" "${microsoft_family[@]}"
add_family "Yahoo_Family_HK" "${yahoo_family[@]}"
add_family "Google_Family_HK" "${google_family[@]}"
add_family "Apple_Family_HK" "${apple_family[@]}"
add_family "AOL_Family_HK" "${aol_family[@]}"
add_family "Proton_Family_HK" "${proton_family[@]}"
add_family "Tuta_Family_HK" "${tuta_family[@]}"


# ============================================================
# REGISTER HONG KONG TLD FAMILIES
# ============================================================

add_family "HK_Domain_Family_HK" "${hk_family[@]}"
add_family "COM_HK_Domain_Family_HK" "${com_hk_family[@]}"
add_family "NET_HK_Domain_Family_HK" "${net_hk_family[@]}"
add_family "ORG_HK_Domain_Family_HK" "${org_hk_family[@]}"
add_family "EDU_HK_Domain_Family_HK" "${edu_hk_family[@]}"
add_family "GOV_HK_Domain_Family_HK" "${gov_hk_family[@]}"
add_family "IDV_HK_Domain_Family_HK" "${idv_hk_family[@]}"
add_family "INC_HK_Domain_Family_HK" "${inc_hk_family[@]}"
add_family "LTD_HK_Domain_Family_HK" "${ltd_hk_family[@]}"
add_family "GROUP_HK_Domain_Family_HK" "${group_hk_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Education_Family_HK" "${education_family[@]}"
add_family "Government_Family_HK" "${government_family[@]}"
add_family "Organization_Family_HK" "${organization_family[@]}"


# ============================================================
# REGISTER HONG KONG LOCATIONS
# ============================================================

add_family "HongKong_Family_HK" "${hongkong_family[@]}"
add_family "Kowloon_Family_HK" "${kowloon_family[@]}"
add_family "Central_Family_HK" "${central_family[@]}"
add_family "WanChai_Family_HK" "${wanchai_family[@]}"
add_family "CausewayBay_Family_HK" "${causewaybay_family[@]}"
add_family "TsimShaTsui_Family_HK" "${tsimshatsui_family[@]}"
add_family "MongKok_Family_HK" "${mongkok_family[@]}"
add_family "ShaTin_Family_HK" "${shatin_family[@]}"
add_family "TaiPo_Family_HK" "${taipo_family[@]}"
add_family "TuenMun_Family_HK" "${tuenmun_family[@]}"
add_family "YuenLong_Family_HK" "${yuenlong_family[@]}"
add_family "KwaiTsing_Family_HK" "${kwaitsing_family[@]}"
add_family "KwunTong_Family_HK" "${kwuntong_family[@]}"
add_family "NorthDistrict_Family_HK" "${northdistrict_family[@]}"
add_family "Islands_Family_HK" "${islands_family[@]}"


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

        printf "${GREEN}[OK] %-40s %s${NC}\n" \
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
    "$OUTPUT/Other_Mail_HK[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-35s %s${NC}\n" \
    "Other_Mail_HK" "$OTHER_COUNT"


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
