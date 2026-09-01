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
printf "${LIGHTCYAN}${BOLD}GrabMAIL SINGAPORE${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Singapore\n"
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

TMP_DIR="${TMPDIR:-/tmp}/singapore_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# SINGAPORE MAIL / ISP PROVIDERS
# ============================================================

singnet_family=(
    singnet.com.sg
)

singtel_family=(
    singtel.com
    singtel.com.sg
)

starhub_family=(
    starhub.com
    starhub.com.sg
)

m1_family=(
    m1.com.sg
)

myrepublic_family=(
    myrepublic.com.sg
)

viewqwest_family=(
    viewqwest.com
    viewqwest.com.sg
)

whizcomms_family=(
    whizcomms.com.sg
)

circles_life_family=(
    circles.life
    circles.life.sg
)

spintel_family=(
    spintel.net
    spintel.com.sg
)

pacnet_family=(
    pacnet.com
    pacnet.com.sg
)

fibrehome_family=(
    fibrehome.com.sg
)

giga_family=(
    giga.com.sg
)


# ============================================================
# SINGAPORE MAIL SERVICES
# ============================================================

mail_sg_family=(
    mail.com.sg
)

mailbox_sg_family=(
    mailbox.com.sg
)

email_sg_family=(
    email.sg
)


# ============================================================
# INTERNATIONAL PROVIDERS COMMONLY USED IN SINGAPORE
# ============================================================

microsoft_family=(
    hotmail.com
    outlook.com
    live.com
    msn.com
)

yahoo_family=(
    yahoo.com
    yahoo.com.sg
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
# SINGAPORE DOMAIN CATEGORIES
# ============================================================

sg_family=(
    sg
)

com_sg_family=(
    com.sg
)

net_sg_family=(
    net.sg
)

org_sg_family=(
    org.sg
)

edu_sg_family=(
    edu.sg
)

gov_sg_family=(
    gov.sg
)

per_sg_family=(
    per.sg
)

idn_sg_family=(
    xn--yfro4i
)


# ============================================================
# SINGAPORE ORGANIZATION CATEGORIES
# ============================================================

education_family=(
    edu.sg
    university
    nus
    ntu
    smu
    sit
    suss
    sutd
)

government_family=(
    gov.sg
    government
)

organization_family=(
    org.sg
)

military_family=(
    mindef
    military
)


# ============================================================
# SINGAPORE LOCATION KEYWORDS
#
# Domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

singapore_family=(
    singapore
    sg
)

central_family=(
    central
    cityhall
    orchard
)

east_family=(
    east
    tampines
    pasirris
    bedok
    geylang
    katong
)

west_family=(
    west
    jurong
    clementi
    bukitbatok
)

north_family=(
    north
    woodlands
    sembawang
    yishun
)

northeast_family=(
    northeast
    hougang
    punggol
    sengkang
)

bukittimah_family=(
    bukittimah
    bukit-timah
)

queenstown_family=(
    queenstown
)

toa_payoh_family=(
    toapayoh
    toa-payoh
)

ang_mo_kio_family=(
    angmokio
    ang-mo-kio
)

bishan_family=(
    bishan
)

serangoon_family=(
    serangoon
)

marine_parade_family=(
    marineparade
    marine-parade
)

pasir_panjang_family=(
    pasirpanjang
    pasir-panjang
)

choa_chu_kang_family=(
    choachukang
    choa-chu-kang
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
# REGISTER SINGAPORE ISP / MAIL FAMILIES
# ============================================================

add_family "SingNet_Family_SINGAPORE" "${singnet_family[@]}"
add_family "Singtel_Family_SINGAPORE" "${singtel_family[@]}"
add_family "StarHub_Family_SINGAPORE" "${starhub_family[@]}"
add_family "M1_Family_SINGAPORE" "${m1_family[@]}"
add_family "MyRepublic_Family_SINGAPORE" "${myrepublic_family[@]}"
add_family "ViewQwest_Family_SINGAPORE" "${viewqwest_family[@]}"
add_family "WhizComms_Family_SINGAPORE" "${whizcomms_family[@]}"
add_family "CirclesLife_Family_SINGAPORE" "${circles_life_family[@]}"
add_family "SPiTel_Family_SINGAPORE" "${spintel_family[@]}"
add_family "Pacnet_Family_SINGAPORE" "${pacnet_family[@]}"
add_family "FibreHome_Family_SINGAPORE" "${fibrehome_family[@]}"
add_family "Giga_Family_SINGAPORE" "${giga_family[@]}"

add_family "Mail_SG_Family_SINGAPORE" "${mail_sg_family[@]}"
add_family "Mailbox_SG_Family_SINGAPORE" "${mailbox_sg_family[@]}"
add_family "Email_SG_Family_SINGAPORE" "${email_sg_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_SINGAPORE" "${microsoft_family[@]}"
add_family "Yahoo_Family_SINGAPORE" "${yahoo_family[@]}"
add_family "Google_Family_SINGAPORE" "${google_family[@]}"
add_family "Apple_Family_SINGAPORE" "${apple_family[@]}"
add_family "AOL_Family_SINGAPORE" "${aol_family[@]}"
add_family "Proton_Family_SINGAPORE" "${proton_family[@]}"
add_family "Tuta_Family_SINGAPORE" "${tuta_family[@]}"


# ============================================================
# REGISTER SINGAPORE TLD FAMILIES
# ============================================================

add_family "SG_Domain_Family_SINGAPORE" "${sg_family[@]}"
add_family "COM_SG_Domain_Family_SINGAPORE" "${com_sg_family[@]}"
add_family "NET_SG_Domain_Family_SINGAPORE" "${net_sg_family[@]}"
add_family "ORG_SG_Domain_Family_SINGAPORE" "${org_sg_family[@]}"
add_family "EDU_SG_Domain_Family_SINGAPORE" "${edu_sg_family[@]}"
add_family "GOV_SG_Domain_Family_SINGAPORE" "${gov_sg_family[@]}"
add_family "PER_SG_Domain_Family_SINGAPORE" "${per_sg_family[@]}"
add_family "IDN_SG_Domain_Family_SINGAPORE" "${idn_sg_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Education_Family_SINGAPORE" "${education_family[@]}"
add_family "Government_Family_SINGAPORE" "${government_family[@]}"
add_family "Organization_Family_SINGAPORE" "${organization_family[@]}"
add_family "Military_Family_SINGAPORE" "${military_family[@]}"


# ============================================================
# REGISTER LOCATIONS
# ============================================================

add_family "Singapore_Family_SINGAPORE" "${singapore_family[@]}"
add_family "Central_Family_SINGAPORE" "${central_family[@]}"
add_family "East_Family_SINGAPORE" "${east_family[@]}"
add_family "West_Family_SINGAPORE" "${west_family[@]}"
add_family "North_Family_SINGAPORE" "${north_family[@]}"
add_family "NorthEast_Family_SINGAPORE" "${northeast_family[@]}"
add_family "BukitTimah_Family_SINGAPORE" "${bukittimah_family[@]}"
add_family "Queenstown_Family_SINGAPORE" "${queenstown_family[@]}"
add_family "ToaPayoh_Family_SINGAPORE" "${toa_payoh_family[@]}"
add_family "AngMoKio_Family_SINGAPORE" "${ang_mo_kio_family[@]}"
add_family "Bishan_Family_SINGAPORE" "${bishan_family[@]}"
add_family "Serangoon_Family_SINGAPORE" "${serangoon_family[@]}"
add_family "MarineParade_Family_SINGAPORE" "${marine_parade_family[@]}"
add_family "PasirPanjang_Family_SINGAPORE" "${pasir_panjang_family[@]}"
add_family "ChoaChuKang_Family_SINGAPORE" "${choa_chu_kang_family[@]}"


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
    "$OUTPUT/Other_Mail_SINGAPORE[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-40s %s${NC}\n" \
    "Other_Mail_SINGAPORE" "$OTHER_COUNT"


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
