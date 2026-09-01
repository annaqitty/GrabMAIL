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
printf "${LIGHTCYAN}${BOLD}GrabMAIL USA${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
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

TMP_DIR="${TMPDIR:-/tmp}/usa_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# FAMILY DATABASE
#
# Add only domains/providers that you are authorized to process.
# ============================================================

microsoft_family=(
    hotmail
    live
    outlook
    msn
    windowslive
)

yahoo_family=(
    yahoo
    ymail
    rocketmail
)

google_family=(
    gmail
    google
    googlemail
)

aol_family=(
    aol
)

apple_family=(
    icloud
    mac
    apple
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
# ISP FAMILIES
# ============================================================

comcast_family=(
    comcast
    xfinity
)

verizon_family=(
    verizon
)

att_family=(
    att
    sbcglobal
    bellsouth
)

spectrum_family=(
    spectrum
    charter
)

cox_family=(
    cox
)

frontier_family=(
    frontier
)

centurylink_family=(
    centurylink
)

earthlink_family=(
    earthlink
)

juno_family=(
    juno
)

netzero_family=(
    netzero
)

windstream_family=(
    windstream
)

mediacom_family=(
    mediacom
)

optimum_family=(
    optimum
)

rcn_family=(
    rcn
)

wowway_family=(
    wowway
)

suddenlink_family=(
    suddenlink
)

hughesnet_family=(
    hughesnet
)


# ============================================================
# DOMAIN CATEGORIES
# ============================================================

edu_family=( edu )

gov_family=( gov )

mil_family=( mil )

us_family=( us )

org_family=( org )


# ============================================================
# STATE LABELS
#
# These are optional domain-name keywords, not geographic proof.
# ============================================================

alabama_family=( alabama )
alaska_family=( alaska )
arizona_family=( arizona )
arkansas_family=( arkansas )
california_family=( california )
colorado_family=( colorado )
connecticut_family=( connecticut )
delaware_family=( delaware )
florida_family=( florida )
georgia_family=( georgia )
hawaii_family=( hawaii )
idaho_family=( idaho )
illinois_family=( illinois )
indiana_family=( indiana )
iowa_family=( iowa )
kansas_family=( kansas )
kentucky_family=( kentucky )
louisiana_family=( louisiana )
maine_family=( maine )
maryland_family=( maryland )
massachusetts_family=( massachusetts )
michigan_family=( michigan )
minnesota_family=( minnesota )
mississippi_family=( mississippi )
missouri_family=( missouri )
montana_family=( montana )
nebraska_family=( nebraska )
nevada_family=( nevada )
newhampshire_family=( newhampshire )
newjersey_family=( newjersey )
newmexico_family=( newmexico )
newyork_family=( newyork )
northcarolina_family=( northcarolina )
northdakota_family=( northdakota )
ohio_family=( ohio )
oklahoma_family=( oklahoma )
oregon_family=( oregon )
pennsylvania_family=( pennsylvania )
rhodeisland_family=( rhodeisland )
southcarolina_family=( southcarolina )
southdakota_family=( southdakota )
tennessee_family=( tennessee )
texas_family=( texas )
utah_family=( utah )
vermont_family=( vermont )
virginia_family=( virginia )
washington_family=( washington )
westvirginia_family=( westvirginia )
wisconsin_family=( wisconsin )
wyoming_family=( wyoming )


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
# REGISTER MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_USA" "${microsoft_family[@]}"
add_family "Yahoo_Family_USA" "${yahoo_family[@]}"
add_family "Google_Family_USA" "${google_family[@]}"
add_family "AOL_Family_USA" "${aol_family[@]}"
add_family "Apple_Family_USA" "${apple_family[@]}"
add_family "Proton_Family_USA" "${proton_family[@]}"
add_family "Tuta_Family_USA" "${tuta_family[@]}"


# ============================================================
# REGISTER ISP FAMILIES
# ============================================================

add_family "Comcast_Family_USA" "${comcast_family[@]}"
add_family "Verizon_Family_USA" "${verizon_family[@]}"
add_family "ATT_Family_USA" "${att_family[@]}"
add_family "Spectrum_Family_USA" "${spectrum_family[@]}"
add_family "Cox_Family_USA" "${cox_family[@]}"
add_family "Frontier_Family_USA" "${frontier_family[@]}"
add_family "CenturyLink_Family_USA" "${centurylink_family[@]}"
add_family "EarthLink_Family_USA" "${earthlink_family[@]}"
add_family "Juno_Family_USA" "${juno_family[@]}"
add_family "NetZero_Family_USA" "${netzero_family[@]}"
add_family "Windstream_Family_USA" "${windstream_family[@]}"
add_family "Mediacom_Family_USA" "${mediacom_family[@]}"
add_family "Optimum_Family_USA" "${optimum_family[@]}"
add_family "RCN_Family_USA" "${rcn_family[@]}"
add_family "WOWWay_Family_USA" "${wowway_family[@]}"
add_family "Suddenlink_Family_USA" "${suddenlink_family[@]}"
add_family "HughesNet_Family_USA" "${hughesnet_family[@]}"


# ============================================================
# REGISTER TLD CATEGORIES
# ============================================================

add_family "Education_Family_USA" "${edu_family[@]}"
add_family "Government_Family_USA" "${gov_family[@]}"
add_family "Military_Family_USA" "${mil_family[@]}"
add_family "US_Domain_Family_USA" "${us_family[@]}"
add_family "Organization_Family_USA" "${org_family[@]}"


# ============================================================
# REGISTER STATES
# ============================================================

add_family "Alabama_Family_USA" "${alabama_family[@]}"
add_family "Alaska_Family_USA" "${alaska_family[@]}"
add_family "Arizona_Family_USA" "${arizona_family[@]}"
add_family "Arkansas_Family_USA" "${arkansas_family[@]}"
add_family "California_Family_USA" "${california_family[@]}"
add_family "Colorado_Family_USA" "${colorado_family[@]}"
add_family "Connecticut_Family_USA" "${connecticut_family[@]}"
add_family "Delaware_Family_USA" "${delaware_family[@]}"
add_family "Florida_Family_USA" "${florida_family[@]}"
add_family "Georgia_Family_USA" "${georgia_family[@]}"
add_family "Hawaii_Family_USA" "${hawaii_family[@]}"
add_family "Idaho_Family_USA" "${idaho_family[@]}"
add_family "Illinois_Family_USA" "${illinois_family[@]}"
add_family "Indiana_Family_USA" "${indiana_family[@]}"
add_family "Iowa_Family_USA" "${iowa_family[@]}"
add_family "Kansas_Family_USA" "${kansas_family[@]}"
add_family "Kentucky_Family_USA" "${kentucky_family[@]}"
add_family "Louisiana_Family_USA" "${louisiana_family[@]}"
add_family "Maine_Family_USA" "${maine_family[@]}"
add_family "Maryland_Family_USA" "${maryland_family[@]}"
add_family "Massachusetts_Family_USA" "${massachusetts_family[@]}"
add_family "Michigan_Family_USA" "${michigan_family[@]}"
add_family "Minnesota_Family_USA" "${minnesota_family[@]}"
add_family "Mississippi_Family_USA" "${mississippi_family[@]}"
add_family "Missouri_Family_USA" "${missouri_family[@]}"
add_family "Montana_Family_USA" "${montana_family[@]}"
add_family "Nebraska_Family_USA" "${nebraska_family[@]}"
add_family "Nevada_Family_USA" "${nevada_family[@]}"
add_family "NewHampshire_Family_USA" "${newhampshire_family[@]}"
add_family "NewJersey_Family_USA" "${newjersey_family[@]}"
add_family "NewMexico_Family_USA" "${newmexico_family[@]}"
add_family "NewYork_Family_USA" "${newyork_family[@]}"
add_family "NorthCarolina_Family_USA" "${northcarolina_family[@]}"
add_family "NorthDakota_Family_USA" "${northdakota_family[@]}"
add_family "Ohio_Family_USA" "${ohio_family[@]}"
add_family "Oklahoma_Family_USA" "${oklahoma_family[@]}"
add_family "Oregon_Family_USA" "${oregon_family[@]}"
add_family "Pennsylvania_Family_USA" "${pennsylvania_family[@]}"
add_family "RhodeIsland_Family_USA" "${rhodeisland_family[@]}"
add_family "SouthCarolina_Family_USA" "${southcarolina_family[@]}"
add_family "SouthDakota_Family_USA" "${southdakota_family[@]}"
add_family "Tennessee_Family_USA" "${tennessee_family[@]}"
add_family "Texas_Family_USA" "${texas_family[@]}"
add_family "Utah_Family_USA" "${utah_family[@]}"
add_family "Vermont_Family_USA" "${vermont_family[@]}"
add_family "Virginia_Family_USA" "${virginia_family[@]}"
add_family "Washington_Family_USA" "${washington_family[@]}"
add_family "WestVirginia_Family_USA" "${westvirginia_family[@]}"
add_family "Wisconsin_Family_USA" "${wisconsin_family[@]}"
add_family "Wyoming_Family_USA" "${wyoming_family[@]}"


# ============================================================
# OUTPUT DIRECTORIES
# ============================================================

mkdir -p "$OUTPUT"


# ============================================================
# CLASSIFICATION
# ============================================================
#
# Each email is checked once.
# First matching family wins.
# Unmatched addresses go to Other_Mail.
#
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
    "$OUTPUT/Other_Mail_USA[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-35s %s${NC}\n" \
    "Other_Mail_USA" "$OTHER_COUNT"


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
