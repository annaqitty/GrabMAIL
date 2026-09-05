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
printf "${LIGHTCYAN}${BOLD}GrabMAIL Canada${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Canada\n"
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

TMP_DIR="${TMPDIR:-/tmp}/canada_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# GLOBAL MAIL FAMILIES
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
    me
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
# CANADA ISP FAMILIES
# ============================================================

rogers_family=(
    rogers
    rogersmail
    rogers.blackberry
)

bell_family=(
    bell
    bellnet
    bellnet.ca
    bellaliant
    sympatico
    bellinternet
    bellmobi
)

videotron_family=(
    videotron
    videotron.ca
)

shaw_family=(
    shaw
    shaw.ca
    shawmail
)

telus_family=(
    telus
    telus.net
    telusplanet
)

cogeco_family=(
    cogeco
    cogeco.ca
)

eastlink_family=(
    eastlink
    eastlink.ca
)

sasktel_family=(
    sasktel
    sasktel.net
)

mymts_family=(
    mts
    mymts
    mts.net
)

xplornet_family=(
    xplornet
    xplornet.ca
)

teksavvy_family=(
    teksavvy
    teksavvy.com
)

primus_family=(
    primus
    primus.ca
)

execulink_family=(
    execulink
    execulink.ca
)

start_family=(
    start
    start.ca
)

distributel_family=(
    distributel
    distributel.ca
)

oxio_family=(
    oxio
    oxio.ca
)

vmedia_family=(
    vmedia
    vmedia.ca
)

acanac_family=(
    acanac
    acanac.com
)

ziply_family=(
    ziply
)

nexicom_family=(
    nexicom
    nexicom.net
)

storm_family=(
    storm
    storm.ca
)

netago_family=(
    netago
    netago.ca
)


# ============================================================
# CANADA DOMAIN CATEGORIES
# ============================================================

ca_family=(
    ca
)

gc_family=(
    gc
    canada
    canadagc
)

gov_family=(
    gov
)

edu_family=(
    edu
)

org_family=(
    org
)

mil_family=(
    mil
)


# ============================================================
# CANADA PROVINCES / TERRITORIES
#
# These are domain-name keywords only.
# They do NOT prove geographic location.
# ============================================================

alberta_family=(
    alberta
    ab
)

britishcolumbia_family=(
    britishcolumbia
    british-columbia
    bc
)

manitoba_family=(
    manitoba
    mb
)

newbrunswick_family=(
    newbrunswick
    new-brunswick
    nb
)

newfoundlandlabrador_family=(
    newfoundland
    newfoundlandlabrador
    newfoundland-labrador
    labrador
    nl
)

novascotia_family=(
    novascotia
    nova-scotia
    ns
)

ontario_family=(
    ontario
    on
)

princeedwardisland_family=(
    princeedwardisland
    prince-edward-island
    pei
)

quebec_family=(
    quebec
    québec
    qc
)

saskatchewan_family=(
    saskatchewan
    sk
)

northwestterritories_family=(
    northwestterritories
    northwest-territories
    nwt
    nt
)

nunavut_family=(
    nunavut
    nu
)

yukon_family=(
    yukon
    yt
)


# ============================================================
# CANADIAN CITY / REGIONAL KEYWORDS
# ============================================================

toronto_family=(
    toronto
)

montreal_family=(
    montreal
    montréal
)

vancouver_family=(
    vancouver
)

calgary_family=(
    calgary
)

edmonton_family=(
    edmonton
)

ottawa_family=(
    ottawa
)

winnipeg_family=(
    winnipeg
)

quebec_city_family=(
    quebeccity
    quebec-city
)

hamilton_family=(
    hamilton
)

kitchener_family=(
    kitchener
)

london_ontario_family=(
    london
    londonontario
)

victoria_family=(
    victoria
)

halifax_family=(
    halifax
)

saskatoon_family=(
    saskatoon
)

regina_family=(
    regina
)

windsor_family=(
    windsor
)

kelowna_family=(
    kelowna
)

barrie_family=(
    barrie
)

surrey_family=(
    surrey
)

burnaby_family=(
    burnaby
)


# ============================================================
# EXTRACT EMAILS
# ============================================================

EMAILS="$TMP_DIR/emails.txt"

printf "${BLUE}[+] Extracting email addresses...${NC}\n"

awk '
{
    s = tolower($0)
    while (match(s, /[A-Za-z0-9_.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+/)) {
        email = substr(s, RSTART, RLENGTH)
        print email
        s = substr(s, RSTART + RLENGTH)
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
FAMILY_ORDER=()


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
    FAMILY_ORDER+=("$name")
}


# ============================================================
# REGISTER GLOBAL MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_Canada" "${microsoft_family[@]}"
add_family "Yahoo_Family_Canada" "${yahoo_family[@]}"
add_family "Google_Family_Canada" "${google_family[@]}"
add_family "AOL_Family_Canada" "${aol_family[@]}"
add_family "Apple_Family_Canada" "${apple_family[@]}"
add_family "Proton_Family_Canada" "${proton_family[@]}"
add_family "Tuta_Family_Canada" "${tuta_family[@]}"


# ============================================================
# REGISTER CANADA ISP FAMILIES
# ============================================================

add_family "Rogers_Family_Canada" "${rogers_family[@]}"
add_family "Bell_Family_Canada" "${bell_family[@]}"
add_family "Videotron_Family_Canada" "${videotron_family[@]}"
add_family "Shaw_Family_Canada" "${shaw_family[@]}"
add_family "TELUS_Family_Canada" "${telus_family[@]}"
add_family "Cogeco_Family_Canada" "${cogeco_family[@]}"
add_family "Eastlink_Family_Canada" "${eastlink_family[@]}"
add_family "SaskTel_Family_Canada" "${sasktel_family[@]}"
add_family "MTS_Family_Canada" "${mymts_family[@]}"
add_family "Xplornet_Family_Canada" "${xplornet_family[@]}"
add_family "TekSavvy_Family_Canada" "${teksavvy_family[@]}"
add_family "Primus_Family_Canada" "${primus_family[@]}"
add_family "Execulink_Family_Canada" "${execulink_family[@]}"
add_family "Start_Family_Canada" "${start_family[@]}"
add_family "Distributel_Family_Canada" "${distributel_family[@]}"
add_family "OXIO_Family_Canada" "${oxio_family[@]}"
add_family "VMedia_Family_Canada" "${vmedia_family[@]}"
add_family "Acanac_Family_Canada" "${acanac_family[@]}"
add_family "Nexicom_Family_Canada" "${nexicom_family[@]}"
add_family "Storm_Family_Canada" "${storm_family[@]}"
add_family "Netago_Family_Canada" "${netago_family[@]}"


# ============================================================
# REGISTER CANADA TLD CATEGORIES
# ============================================================

add_family "Canada_Domain_Family_Canada" "${ca_family[@]}"
add_family "Government_Family_Canada" "${gc_family[@]}"
add_family "Gov_Domain_Family_Canada" "${gov_family[@]}"
add_family "Education_Family_Canada" "${edu_family[@]}"
add_family "Organization_Family_Canada" "${org_family[@]}"
add_family "Military_Family_Canada" "${mil_family[@]}"


# ============================================================
# REGISTER PROVINCES / TERRITORIES
# ============================================================

add_family "Alberta_Family_Canada" "${alberta_family[@]}"
add_family "BritishColumbia_Family_Canada" "${britishcolumbia_family[@]}"
add_family "Manitoba_Family_Canada" "${manitoba_family[@]}"
add_family "NewBrunswick_Family_Canada" "${newbrunswick_family[@]}"
add_family "NewfoundlandLabrador_Family_Canada" "${newfoundlandlabrador_family[@]}"
add_family "NovaScotia_Family_Canada" "${novascotia_family[@]}"
add_family "Ontario_Family_Canada" "${ontario_family[@]}"
add_family "PrinceEdwardIsland_Family_Canada" "${princeedwardisland_family[@]}"
add_family "Quebec_Family_Canada" "${quebec_family[@]}"
add_family "Saskatchewan_Family_Canada" "${saskatchewan_family[@]}"
add_family "NorthwestTerritories_Family_Canada" "${northwestterritories_family[@]}"
add_family "Nunavut_Family_Canada" "${nunavut_family[@]}"
add_family "Yukon_Family_Canada" "${yukon_family[@]}"


# ============================================================
# REGISTER MAJOR CANADIAN CITIES
# ============================================================

add_family "Toronto_Family_Canada" "${toronto_family[@]}"
add_family "Montreal_Family_Canada" "${montreal_family[@]}"
add_family "Vancouver_Family_Canada" "${vancouver_family[@]}"
add_family "Calgary_Family_Canada" "${calgary_family[@]}"
add_family "Edmonton_Family_Canada" "${edmonton_family[@]}"
add_family "Ottawa_Family_Canada" "${ottawa_family[@]}"
add_family "Winnipeg_Family_Canada" "${winnipeg_family[@]}"
add_family "QuebecCity_Family_Canada" "${quebec_city_family[@]}"
add_family "Hamilton_Family_Canada" "${hamilton_family[@]}"
add_family "Kitchener_Family_Canada" "${kitchener_family[@]}"
add_family "LondonOntario_Family_Canada" "${london_ontario_family[@]}"
add_family "Victoria_Family_Canada" "${victoria_family[@]}"
add_family "Halifax_Family_Canada" "${halifax_family[@]}"
add_family "Saskatoon_Family_Canada" "${saskatoon_family[@]}"
add_family "Regina_Family_Canada" "${regina_family[@]}"
add_family "Windsor_Family_Canada" "${windsor_family[@]}"
add_family "Kelowna_Family_Canada" "${kelowna_family[@]}"
add_family "Barrie_Family_Canada" "${barrie_family[@]}"
add_family "Surrey_Family_Canada" "${surrey_family[@]}"
add_family "Burnaby_Family_Canada" "${burnaby_family[@]}"


# ============================================================
# OUTPUT DIRECTORIES
# ============================================================

mkdir -p "$OUTPUT"


# ============================================================
# CLASSIFICATION
# ============================================================

printf "${BLUE}[+] Classifying emails...${NC}\n"

OTHER_TMP="$TMP_DIR/other.tmp"
MAP_FILE="$TMP_DIR/families.map"
COUNTS_FILE="$TMP_DIR/counts.tsv"

: > "$OTHER_TMP"
: > "$MAP_FILE"

# Preserve registration order (bash associative-array key order is
# unspecified) and hand it to a single awk process instead of doing
# an O(emails * families) regex match inside interpreted bash.
for family in "${FAMILY_ORDER[@]}"; do
    printf '%s\t%s\n' "$family" "${FAMILY_REGEX[$family]}" >> "$MAP_FILE"
done


# ============================================================
# PROCESS EMAILS (single fast awk pass)
# ============================================================

awk -v mapfile="$MAP_FILE" -v outdir="$OUTPUT" -v otherfile="$OTHER_TMP" '
BEGIN {
    n = 0
    while ((getline line < mapfile) > 0) {
        split(line, parts, "\t")
        n++
        fam[n] = parts[1]
        pat[n] = parts[2]
        cnt[n] = 0
    }
    close(mapfile)
}
{
    email = $0
    if (email == "") next

    at = index(email, "@")
    domain = (at > 0) ? substr(email, at + 1) : email

    matched = 0
    for (i = 1; i <= n; i++) {
        if (pat[i] != "" && domain ~ pat[i]) {
            outfile = outdir "/" fam[i] ".tmp"
            print email >> outfile
            cnt[i]++
            matched = 1
            break
        }
    }

    if (!matched) {
        print email >> otherfile
    }
}
END {
    for (i = 1; i <= n; i++) {
        print fam[i] "\t" cnt[i]
    }
}
' "$EMAILS" > "$COUNTS_FILE"


# ============================================================
# RENAME OUTPUT FILES
# ============================================================

while IFS=$'\t' read -r family count; do

    [[ -z "$family" ]] && continue

    file="$OUTPUT/${family}.tmp"

    if (( count > 0 )); then

        mv "$file" \
            "$OUTPUT/${family}[${count}].txt"

        printf "${GREEN}[OK] %-45s %s${NC}\n" \
            "$family" "$count"

    else

        rm -f "$file"

    fi

done < "$COUNTS_FILE"


# ============================================================
# OTHER
# ============================================================

OTHER_COUNT=$(wc -l < "$OTHER_TMP")

mv "$OTHER_TMP" \
    "$OUTPUT/Other_Mail_Canada[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-40s %s${NC}\n" \
    "Other_Mail_Canada" "$OTHER_COUNT"


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
