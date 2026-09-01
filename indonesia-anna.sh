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
MAENTA='\033[0;35m'

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
printf "${LIGHTCYAN}${BOLD}GrabDOMAIN Indonesia${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Country  : Indonesia\n"
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

TMP_DIR="${TMPDIR:-/tmp}/indonesia_domain_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# DOMAIN FAMILIES
# ============================================================

telkom_family=(
    telkom
)

indihome_family=(
    indihome
)

telkomsel_family=(
    telkomsel
)

xl_family=(
    xl
)

axis_family=(
    axis
)

indosat_family=(
    indosat
)

im3_family=(
    im3
)

tri_family=(
    tri
)

smartfren_family=(
    smartfren
)

biznet_family=(
    biznet
)

myrepublic_family=(
    myrepublic
)

firstmedia_family=(
    firstmedia
)

cbn_family=(
    cbn
)

mnc_family=(
    mnc
    mncgroup
)

moratel_family=(
    moratel
    moratelindo
)

iconplus_family=(
    iconplus
)

lintasarta_family=(
    lintasarta
)

indonet_family=(
    indonet
)

oxygen_family=(
    oxygen
)

globalxtreme_family=(
    globalxtreme
)

neuviz_family=(
    neuviz
)

melsa_family=(
    melsa
)

dnet_family=(
    dnet
)

radnet_family=(
    radnet
)

centrin_family=(
    centrin
)


# ============================================================
# EDUCATION / GOVERNMENT / ORGANIZATION
# ============================================================

school_family=(
    sch.id
)

highereducation_family=(
    ac.id
)

government_family=(
    go.id
)

organization_family=(
    or.id
)

military_family=(
    mil.id
)

business_family=(
    co.id
)

network_family=(
    net.id
)

web_family=(
    web.id
)

biz_family=(
    biz.id
)

personal_family=(
    my.id
)

village_family=(
    desa.id
)

foundation_family=(
    yayasan.id
)


# ============================================================
# BELAJAR.ID
# ============================================================

belajar_school_family=(
    sd.belajar.id
    smp.belajar.id
    sma.belajar.id
    smk.belajar.id
    slb.belajar.id
)

belajar_teacher_family=(
    guru.sd.belajar.id
    guru.smp.belajar.id
    guru.sma.belajar.id
    guru.smk.belajar.id
)

belajar_admin_family=(
    admin.belajar.id
)


# ============================================================
# INDONESIA TLD
# ============================================================

id_family=(
    .id
)


# ============================================================
# INTERNATIONAL PROVIDERS
# ============================================================

microsoft_family=(
    hotmail.com
    outlook.com
    live.com
    msn.com
)

google_family=(
    gmail.com
    googlemail.com
)

yahoo_family=(
    yahoo.com
    ymail.com
)

apple_family=(
    icloud.com
    me.com
)

proton_family=(
    proton.me
    protonmail.com
)


# ============================================================
# EXTRACT / NORMALIZE DOMAINS
# ============================================================

DOMAINS="$TMP_DIR/domains.txt"

printf "${BLUE}[+] Processing domains...${NC}\n"

awk '
{
    s = tolower($0)

    gsub(/\r/, "", s)
    gsub(/^[ \t]+/, "", s)
    gsub(/[ \t]+$/, "", s)

    # Remove protocol
    sub(/^https?:\/\//, "", s)

    # Remove path
    sub(/\/.*$/, "", s)

    # Remove port
    sub(/:[0-9]+$/, "", s)

    # Remove trailing dot
    sub(/\.$/, "", s)

    # Ignore empty lines
    if (s == "")
        next

    # Ignore obvious email-address input
    if (s ~ /@/)
        next

    # Keep domain-like values
    if (s ~ /^[a-z0-9.-]+$/)
        print s
}
' "$INPUT" |
awk '!seen[$0]++' > "$DOMAINS"

TOTAL=$(wc -l < "$DOMAINS")

printf "${GREEN}[+] Unique domains : %s${NC}\n" "$TOTAL"
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
# REGISTER ISP FAMILIES
# ============================================================

add_family "Telkom_Family_Indonesia" "${telkom_family[@]}"
add_family "IndiHome_Family_Indonesia" "${indihome_family[@]}"
add_family "Telkomsel_Family_Indonesia" "${telkomsel_family[@]}"
add_family "XL_Family_Indonesia" "${xl_family[@]}"
add_family "AXIS_Family_Indonesia" "${axis_family[@]}"
add_family "Indosat_Family_Indonesia" "${indosat_family[@]}"
add_family "IM3_Family_Indonesia" "${im3_family[@]}"
add_family "Tri_Family_Indonesia" "${tri_family[@]}"
add_family "Smartfren_Family_Indonesia" "${smartfren_family[@]}"
add_family "Biznet_Family_Indonesia" "${biznet_family[@]}"
add_family "MyRepublic_Family_Indonesia" "${myrepublic_family[@]}"
add_family "FirstMedia_Family_Indonesia" "${firstmedia_family[@]}"
add_family "CBN_Family_Indonesia" "${cbn_family[@]}"
add_family "MNC_Family_Indonesia" "${mnc_family[@]}"
add_family "Moratel_Family_Indonesia" "${moratel_family[@]}"
add_family "IconPlus_Family_Indonesia" "${iconplus_family[@]}"
add_family "Lintasarta_Family_Indonesia" "${lintasarta_family[@]}"
add_family "Indonet_Family_Indonesia" "${indonet_family[@]}"
add_family "Oxygen_Family_Indonesia" "${oxygen_family[@]}"
add_family "GlobalXtreme_Family_Indonesia" "${globalxtreme_family[@]}"
add_family "Neuviz_Family_Indonesia" "${neuviz_family[@]}"
add_family "Melsa_Family_Indonesia" "${melsa_family[@]}"
add_family "DNet_Family_Indonesia" "${dnet_family[@]}"
add_family "RadNet_Family_Indonesia" "${radnet_family[@]}"
add_family "Centrin_Family_Indonesia" "${centrin_family[@]}"


# ============================================================
# REGISTER EDUCATION / SCHOOL
# ============================================================

# SCHOOL MUST COME BEFORE GENERIC .ID
add_family "School_Family_Indonesia" "${school_family[@]}"

# HIGHER EDUCATION
add_family "HigherEducation_Family_Indonesia" "${highereducation_family[@]}"

# BELAJAR.ID
add_family "BelajarID_School_Family_Indonesia" \
    "${belajar_school_family[@]}"

add_family "BelajarID_Teacher_Family_Indonesia" \
    "${belajar_teacher_family[@]}"

add_family "BelajarID_Admin_Family_Indonesia" \
    "${belajar_admin_family[@]}"


# ============================================================
# REGISTER GOVERNMENT / ORGANIZATION
# ============================================================

add_family "Government_Family_Indonesia" "${government_family[@]}"
add_family "Organization_Family_Indonesia" "${organization_family[@]}"
add_family "Military_Family_Indonesia" "${military_family[@]}"
add_family "Business_Family_Indonesia" "${business_family[@]}"
add_family "Network_Family_Indonesia" "${network_family[@]}"
add_family "Web_Family_Indonesia" "${web_family[@]}"
add_family "Biz_Family_Indonesia" "${biz_family[@]}"
add_family "Personal_Family_Indonesia" "${personal_family[@]}"
add_family "Village_Family_Indonesia" "${village_family[@]}"
add_family "Foundation_Family_Indonesia" "${foundation_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL PROVIDERS
# ============================================================

add_family "Microsoft_Family_Indonesia" "${microsoft_family[@]}"
add_family "Google_Family_Indonesia" "${google_family[@]}"
add_family "Yahoo_Family_Indonesia" "${yahoo_family[@]}"
add_family "Apple_Family_Indonesia" "${apple_family[@]}"
add_family "Proton_Family_Indonesia" "${proton_family[@]}"


# ============================================================
# REGISTER GENERIC ID
# ============================================================

add_family "ID_Domain_Family_Indonesia" "${id_family[@]}"


# ============================================================
# OUTPUT
# ============================================================

printf "${BLUE}[+] Classifying domains...${NC}\n"

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

while IFS= read -r domain; do

    [[ -z "$domain" ]] && continue

    matched=0

    for family in "${!FAMILY_REGEX[@]}"; do

        regex="${FAMILY_REGEX[$family]}"

        if [[ "$domain" =~ $regex ]]; then

            printf '%s\n' "$domain" >> "${FILES[$family]}"

            COUNTS["$family"]=$(( COUNTS["$family"] + 1 ))

            matched=1
            break
        fi

    done

    if (( matched == 0 )); then

        printf '%s\n' "$domain" >> "$OTHER_TMP"

    fi

done < "$DOMAINS"


# ============================================================
# RENAME OUTPUT FILES
# ============================================================

for family in "${!FILES[@]}"; do

    file="${FILES[$family]}"
    count="${COUNTS[$family]}"

    if (( count > 0 )); then

        mv "$file" \
            "$OUTPUT/${family}[${count}].txt"

        printf "${GREEN}[OK] %-48s %s${NC}\n" \
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
    "$OUTPUT/Other_Domain_Indonesia[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-44s %s${NC}\n" \
    "Other_Domain_Indonesia" "$OTHER_COUNT"


# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "__________________________________________________________________________________"

printf "${LIGHTGREEN}${BOLD}COMPLETE${NC}\n"
echo ""

printf "Input file    : %s\n" "$INPUT"
printf "Total domains : %s\n" "$TOTAL"
printf "Other domains : %s\n" "$OTHER_COUNT"
printf "Output dir    : %s\n" "$OUTPUT"

echo ""
printf "${LIGHTCYAN}Generated files:${NC}\n"

find "$OUTPUT" \
    -maxdepth 1 \
    -type f \
    -name "*.txt" \
    -printf "  %f\n" |
sort

echo ""
echo "__________________________________________________________________________________"

printf "${GREEN}${BOLD}Done.${NC}\n"
