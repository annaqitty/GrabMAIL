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
printf "${LIGHTCYAN}${BOLD}GrabMAIL${NC}\n"
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
    printf "${RED}[!] Input file not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

# ============================================================
# TEMP DIRECTORY
# ============================================================

TMP_DIR="${TMPDIR:-/tmp}/grabmail_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

REMAINING="$TMP_DIR/remaining.txt"

cleanup(){
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT INT TERM

# ============================================================
# FAMILY DATABASE
#
# Add only domains you are authorized to process.
#
# Format:
#
# family_name=( domain1 domain2 domain3 )
#
# ============================================================

microsoft_family=( hotmail live outlook msn windowslive )
yahoo_family=( yahoo ymail rocketmail )
google_family=( gmail google googlemail )
aol_family=( aol )
apple_family=( icloud mac apple )
proton_family=( proton protonmail )
tuta_family=( tuta tutanota )
gmx_family=( gmx )

# ============================================================
# USA PROVIDER FAMILIES
# ============================================================

comcast_family=( comcast xfinity )
verizon_family=( verizon )
att_family=( att sbcglobal bellsouth )
charter_family=( charter spectrum )
cox_family=( cox )
frontier_family=( frontier )
centurylink_family=( centurylink )
earthlink_family=( earthlink )
juno_family=( juno )
netzero_family=( netzero )
optimum_family=( optimum )
rcn_family=( rcn )
wowway_family=( wowway )
mediacom_family=( mediacom )
hughesnet_family=( hughesnet )

# ============================================================
# JAPAN PROVIDER FAMILIES
# ============================================================

ocn_family=( ocn )
dti_family=( dti )
dream_family=( dream )
nifty_family=( nifty )
biglobe_family=( biglobe )
sonet_family=( sonet so-net )
plala_family=( plala )
jcom_family=( jcom )
asahinet_family=( asahi-net asahinet )
eo_family=( eo )
hiho_family=( hi-ho hiho )
wakwak_family=( wakwak )
bbexcite_family=( bbexcite excite )
tcom_family=( tcom t-com )
nuro_family=( nuro )
iij_family=( iij )
gmo_family=( gmo )
rakuten_family=( rakuten )

# ============================================================
# JAPAN CARRIER FAMILIES
# ============================================================

docomo_family=( docomo )
au_family=( au ezweb )
softbank_family=( softbank i-softbank )
ymobile_family=( ymobile )
uq_family=( uq )
linemo_family=( linemo )
mineo_family=( mineo )

# ============================================================
# HELPER
# ============================================================

build_regex(){

    local RESULT=""
    local ITEM
    local ESCAPED

    for ITEM in "$@"; do

        [[ -z "$ITEM" ]] && continue

        ESCAPED=$(printf '%s' "$ITEM" |
            sed 's/[][\\.^$*+?(){}|]/\\&/g')

        if [[ -n "$RESULT" ]]; then
            RESULT="${RESULT}|"
        fi

        RESULT="${RESULT}${ESCAPED}"

    done

    printf '%s' "$RESULT"
}

# ============================================================
# EMAIL EXTRACTION
# ============================================================

printf "${BLUE}[+] Extracting email addresses...${NC}\n"

awk '
{
    line = tolower($0)

    while (
        match(
            line,
            /[A-Za-z0-9_.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+/
        )
    ) {

        email = substr(
            line,
            RSTART,
            RLENGTH
        )

        print email

        line = substr(
            line,
            RSTART + RLENGTH
        )
    }
}
' "$INPUT" > "$REMAINING"

TOTAL=$(wc -l < "$REMAINING")

printf "${GREEN}[+] Extracted : %s${NC}\n" "$TOTAL"
echo ""

# ============================================================
# FAMILY FILTER
# ============================================================

filter_family(){

    local NAME="$1"
    shift

    local REGEX
    local MATCH
    local NEXT
    local COUNT

    REGEX=$(build_regex "$@")

    [[ -z "$REGEX" ]] && return

    MATCH="$TMP_DIR/match.txt"
    NEXT="$TMP_DIR/next.txt"

    awk -v re="$REGEX" '
    {
        p = index($0, "@")

        if (p > 0) {

            domain = substr(
                $0,
                p + 1
            )

            if (domain ~ re) {
                print $0
            }
        }
    }
    ' "$REMAINING" > "$MATCH"

    COUNT=$(wc -l < "$MATCH")

    if (( COUNT > 0 )); then

        mv "$MATCH" \
            "$OUTPUT/${NAME}[${COUNT}].txt"

        awk -v re="$REGEX" '
        {
            p = index($0, "@")

            if (p > 0) {

                domain = substr(
                    $0,
                    p + 1
                )

                if (!(domain ~ re)) {
                    print $0
                }
            }
        }
        ' "$REMAINING" > "$NEXT"

        mv "$NEXT" "$REMAINING"

        printf "${GREEN}[OK] %-35s %s${NC}\n" \
            "$NAME" "$COUNT"

    else

        rm -f "$MATCH"

    fi
}

# ============================================================
# PROCESS GLOBAL FAMILIES
# ============================================================

filter_family \
    "Microsoft_Family" \
    "${microsoft_family[@]}"

filter_family \
    "Yahoo_Family" \
    "${yahoo_family[@]}"

filter_family \
    "Google_Family" \
    "${google_family[@]}"

filter_family \
    "AOL_Family" \
    "${aol_family[@]}"

filter_family \
    "Apple_Family" \
    "${apple_family[@]}"

filter_family \
    "Proton_Family" \
    "${proton_family[@]}"

filter_family \
    "Tuta_Family" \
    "${tuta_family[@]}"

filter_family \
    "GMX_Family" \
    "${gmx_family[@]}"

# ============================================================
# PROCESS USA FAMILIES
# ============================================================

filter_family "Comcast_Family_USA" "${comcast_family[@]}"
filter_family "Verizon_Family_USA" "${verizon_family[@]}"
filter_family "ATT_Family_USA" "${att_family[@]}"
filter_family "Charter_Family_USA" "${charter_family[@]}"
filter_family "Cox_Family_USA" "${cox_family[@]}"
filter_family "Frontier_Family_USA" "${frontier_family[@]}"
filter_family "CenturyLink_Family_USA" "${centurylink_family[@]}"
filter_family "EarthLink_Family_USA" "${earthlink_family[@]}"
filter_family "Juno_Family_USA" "${juno_family[@]}"
filter_family "NetZero_Family_USA" "${netzero_family[@]}"
filter_family "Optimum_Family_USA" "${optimum_family[@]}"
filter_family "RCN_Family_USA" "${rcn_family[@]}"
filter_family "WOWWay_Family_USA" "${wowway_family[@]}"
filter_family "Mediacom_Family_USA" "${mediacom_family[@]}"
filter_family "HughesNet_Family_USA" "${hughesnet_family[@]}"

# ============================================================
# PROCESS JAPAN FAMILIES
# ============================================================

filter_family "OCN_Family_Japan" "${ocn_family[@]}"
filter_family "DTI_Family_Japan" "${dti_family[@]}"
filter_family "Dream_Family_Japan" "${dream_family[@]}"
filter_family "Nifty_Family_Japan" "${nifty_family[@]}"
filter_family "BIGLOBE_Family_Japan" "${biglobe_family[@]}"
filter_family "SoNet_Family_Japan" "${sonet_family[@]}"
filter_family "Plala_Family_Japan" "${plala_family[@]}"
filter_family "JCOM_Family_Japan" "${jcom_family[@]}"
filter_family "AsahiNet_Family_Japan" "${asahinet_family[@]}"
filter_family "EO_Family_Japan" "${eo_family[@]}"
filter_family "HiHo_Family_Japan" "${hiho_family[@]}"
filter_family "WAKWAK_Family_Japan" "${wakwak_family[@]}"
filter_family "BBExcite_Family_Japan" "${bbexcite_family[@]}"
filter_family "TCOM_Family_Japan" "${tcom_family[@]}"
filter_family "NURO_Family_Japan" "${nuro_family[@]}"
filter_family "IIJ_Family_Japan" "${iij_family[@]}"
filter_family "GMO_Family_Japan" "${gmo_family[@]}"
filter_family "Rakuten_Family_Japan" "${rakuten_family[@]}"

# ============================================================
# PROCESS JAPAN CARRIERS
# ============================================================

filter_family "Docomo_Family_Japan" "${docomo_family[@]}"
filter_family "AU_Family_Japan" "${au_family[@]}"
filter_family "SoftBank_Family_Japan" "${softbank_family[@]}"
filter_family "YMobile_Family_Japan" "${ymobile_family[@]}"
filter_family "UQ_Family_Japan" "${uq_family[@]}"
filter_family "LINEMO_Family_Japan" "${linemo_family[@]}"
filter_family "Mineo_Family_Japan" "${mineo_family[@]}"

# ============================================================
# OTHER
# ============================================================

OTHER=$(wc -l < "$REMAINING")

mv "$REMAINING" \
    "$OUTPUT/Other_Mail[${OTHER}].txt"

# ============================================================
# SUMMARY
# ============================================================

echo ""
echo "__________________________________________________________________________________"
printf "${LIGHTGREEN}${BOLD}Completed${NC}\n"
echo ""
printf "Input emails : %s\n" "$TOTAL"
printf "Other emails : %s\n" "$OTHER"
printf "Output       : %s\n" "$OUTPUT"
echo "__________________________________________________________________________________"
echo ""

printf "${LIGHTCYAN}Generated files:${NC}\n"

find "$OUTPUT" \
    -maxdepth 1 \
    -type f \
    -printf "  %f\n" |
sort

echo ""
printf "${GREEN}${BOLD}Done.${NC}\n"
