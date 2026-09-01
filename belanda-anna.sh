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
printf "${LIGHTCYAN}${BOLD}GrabMAIL NETHERLANDS${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Netherlands / Nederland\n"
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

TMP_DIR="${TMPDIR:-/tmp}/netherlands_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# DUTCH ISP / MAIL PROVIDERS
# ============================================================

kpn_family=(
    kpn.com
    kpn.nl
    planet.nl
    planetinternet.nl
)

ziggo_family=(
    ziggo.nl
    ziggo.com
)

vodafoneziggo_family=(
    vodafoneziggo.nl
)

xs4all_family=(
    xs4all.nl
)

upc_family=(
    upc.nl
)

tele2_family=(
    tele2.nl
)

odido_family=(
    odido.nl
    t-mobile.nl
    t-mobile.com
)

telfort_family=(
    telfort.nl
)

solcon_family=(
    solcon.nl
)

online_family=(
    online.nl
)

delta_family=(
    delta.nl
)

zeelandnet_family=(
    zeelandnet.nl
)

freedom_family=(
    freedom.nl
)

youfone_family=(
    youfone.nl
)

simyo_family=(
    simyo.nl
)

budget_family=(
    budgetthuis.nl
)

nlex_family=(
    nlex.nl
)

fiber_family=(
    fiber.nl
)


# ============================================================
# DUTCH MAIL SERVICES
# ============================================================

mail_nl_family=(
    mail.nl
)

email_nl_family=(
    email.nl
)

hetnet_family=(
    hetnet.nl
)

home_family=(
    home.nl
)

versatel_family=(
    versatel.nl
)

wanadoo_family=(
    wanadoo.nl
)

planet_family=(
    planet.nl
)

casema_family=(
    casema.nl
)


# ============================================================
# INTERNATIONAL WEBMAIL
# ============================================================

microsoft_family=(
    hotmail.com
    hotmail.nl
    live.com
    outlook.com
    outlook.nl
    msn.com
)

yahoo_family=(
    yahoo.com
    yahoo.nl
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
# NETHERLANDS DOMAIN CATEGORIES
# ============================================================

nl_family=(
    nl
)

com_nl_family=(
    com.nl
)

net_nl_family=(
    net.nl
)

org_nl_family=(
    org.nl
)

gov_nl_family=(
    gov.nl
)

edu_nl_family=(
    edu.nl
)

ac_nl_family=(
    ac.nl
)


# ============================================================
# NETHERLANDS ORGANIZATION CATEGORIES
# ============================================================

government_family=(
    gov.nl
    overheid
    government
)

education_family=(
    edu.nl
    ac.nl
    universiteit
    hogeschool
    university
    college
)

organization_family=(
    org.nl
)


# ============================================================
# NATIONAL / LANGUAGE KEYWORDS
# ============================================================

netherlands_family=(
    netherlands
    nederland
    dutch
)

dutch_family=(
    dutch
    nederlands
)


# ============================================================
# NETHERLANDS PROVINCES
#
# Domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

north_holland_family=(
    noordholland
    noord-holland
    noord_holland
)

south_holland_family=(
    zuidholland
    zuid-holland
    zuid_holland
)

utrecht_family=(
    utrecht
)

north_brabant_family=(
    noordbrabant
    noord-brabant
    noord_brabant
)

limburg_family=(
    limburg
)

gelderland_family=(
    gelderland
)

overijssel_family=(
    overijssel
)

flevoland_family=(
    flevoland
)

friesland_family=(
    friesland
    fryslan
    fryslân
)

groningen_family=(
    groningen
)

drenthe_family=(
    drenthe
)

zeeland_family=(
    zeeland
)


# ============================================================
# MAJOR DUTCH CITIES
# ============================================================

amsterdam_family=(
    amsterdam
)

rotterdam_family=(
    rotterdam
)

the_hague_family=(
    denhaag
    den-haag
    thehague
)

utrecht_city_family=(
    utrecht
)

eindhoven_family=(
    eindhoven
)

tilburg_family=(
    tilburg
)

groningen_city_family=(
    groningen
)

almere_family=(
    almere
)

breda_family=(
    breda
)

nijmegen_family=(
    nijmegen
)

haarlem_family=(
    haarlem
)

arnhem_family=(
    arnhem
)

enschede_family=(
    enschede
)

apeldoorn_family=(
    apeldoorn
)

amersfoort_family=(
    amersfoort
)

zaanstad_family=(
    zaanstad
)

den_bosch_family=(
    denbosch
    's-hertogenbosch
)

maastricht_family=(
    maastricht
)

delft_family=(
    delft
)

leiden_family=(
    leiden
)

dordrecht_family=(
    dordrecht
)

leeuwarden_family=(
    leeuwarden
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
# REGISTER DUTCH ISP PROVIDERS
# ============================================================

add_family "KPN_Family_NETHERLANDS" "${kpn_family[@]}"
add_family "Ziggo_Family_NETHERLANDS" "${ziggo_family[@]}"
add_family "VodafoneZiggo_Family_NETHERLANDS" "${vodafoneziggo_family[@]}"
add_family "XS4ALL_Family_NETHERLANDS" "${xs4all_family[@]}"
add_family "UPC_Family_NETHERLANDS" "${upc_family[@]}"
add_family "Tele2_Family_NETHERLANDS" "${tele2_family[@]}"
add_family "Odido_Family_NETHERLANDS" "${odido_family[@]}"
add_family "Telfort_Family_NETHERLANDS" "${telfort_family[@]}"
add_family "Solcon_Family_NETHERLANDS" "${solcon_family[@]}"
add_family "Online_Family_NETHERLANDS" "${online_family[@]}"
add_family "DELTA_Family_NETHERLANDS" "${delta_family[@]}"
add_family "ZeelandNet_Family_NETHERLANDS" "${zeelandnet_family[@]}"
add_family "Freedom_Family_NETHERLANDS" "${freedom_family[@]}"
add_family "Youfone_Family_NETHERLANDS" "${youfone_family[@]}"
add_family "Simyo_Family_NETHERLANDS" "${simyo_family[@]}"
add_family "BudgetThuis_Family_NETHERLANDS" "${budget_family[@]}"
add_family "NLEx_Family_NETHERLANDS" "${nlex_family[@]}"
add_family "Fiber_Family_NETHERLANDS" "${fiber_family[@]}"


# ============================================================
# REGISTER DUTCH MAIL FAMILIES
# ============================================================

add_family "Mail_NL_Family_NETHERLANDS" "${mail_nl_family[@]}"
add_family "Email_NL_Family_NETHERLANDS" "${email_nl_family[@]}"
add_family "HetNet_Family_NETHERLANDS" "${hetnet_family[@]}"
add_family "Home_Family_NETHERLANDS" "${home_family[@]}"
add_family "Versatel_Family_NETHERLANDS" "${versatel_family[@]}"
add_family "Wanadoo_Family_NETHERLANDS" "${wanadoo_family[@]}"
add_family "Planet_Family_NETHERLANDS" "${planet_family[@]}"
add_family "Casema_Family_NETHERLANDS" "${casema_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL WEBMAIL
# ============================================================

add_family "Microsoft_Family_NETHERLANDS" "${microsoft_family[@]}"
add_family "Yahoo_Family_NETHERLANDS" "${yahoo_family[@]}"
add_family "Google_Family_NETHERLANDS" "${google_family[@]}"
add_family "Apple_Family_NETHERLANDS" "${apple_family[@]}"
add_family "AOL_Family_NETHERLANDS" "${aol_family[@]}"
add_family "Proton_Family_NETHERLANDS" "${proton_family[@]}"
add_family "Tuta_Family_NETHERLANDS" "${tuta_family[@]}"


# ============================================================
# REGISTER NETHERLANDS TLD FAMILIES
# ============================================================

add_family "NL_Domain_Family_NETHERLANDS" "${nl_family[@]}"
add_family "COM_NL_Domain_Family_NETHERLANDS" "${com_nl_family[@]}"
add_family "NET_NL_Domain_Family_NETHERLANDS" "${net_nl_family[@]}"
add_family "ORG_NL_Domain_Family_NETHERLANDS" "${org_nl_family[@]}"
add_family "GOV_NL_Domain_Family_NETHERLANDS" "${gov_nl_family[@]}"
add_family "EDU_NL_Domain_Family_NETHERLANDS" "${edu_nl_family[@]}"
add_family "AC_NL_Domain_Family_NETHERLANDS" "${ac_nl_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Government_Family_NETHERLANDS" "${government_family[@]}"
add_family "Education_Family_NETHERLANDS" "${education_family[@]}"
add_family "Organization_Family_NETHERLANDS" "${organization_family[@]}"


# ============================================================
# REGISTER NATIONAL / LANGUAGE
# ============================================================

add_family "Netherlands_Family_NETHERLANDS" "${netherlands_family[@]}"
add_family "Dutch_Family_NETHERLANDS" "${dutch_family[@]}"


# ============================================================
# REGISTER PROVINCES
# ============================================================

add_family "NorthHolland_Family_NETHERLANDS" "${north_holland_family[@]}"
add_family "SouthHolland_Family_NETHERLANDS" "${south_holland_family[@]}"
add_family "Utrecht_Family_NETHERLANDS" "${utrecht_family[@]}"
add_family "NorthBrabant_Family_NETHERLANDS" "${north_brabant_family[@]}"
add_family "Limburg_Family_NETHERLANDS" "${limburg_family[@]}"
add_family "Gelderland_Family_NETHERLANDS" "${gelderland_family[@]}"
add_family "Overijssel_Family_NETHERLANDS" "${overijssel_family[@]}"
add_family "Flevoland_Family_NETHERLANDS" "${flevoland_family[@]}"
add_family "Friesland_Family_NETHERLANDS" "${friesland_family[@]}"
add_family "Groningen_Family_NETHERLANDS" "${groningen_family[@]}"
add_family "Drenthe_Family_NETHERLANDS" "${drenthe_family[@]}"
add_family "Zeeland_Family_NETHERLANDS" "${zeeland_family[@]}"


# ============================================================
# REGISTER MAJOR CITIES
# ============================================================

add_family "Amsterdam_Family_NETHERLANDS" "${amsterdam_family[@]}"
add_family "Rotterdam_Family_NETHERLANDS" "${rotterdam_family[@]}"
add_family "TheHague_Family_NETHERLANDS" "${the_hague_family[@]}"
add_family "UtrechtCity_Family_NETHERLANDS" "${utrecht_city_family[@]}"
add_family "Eindhoven_Family_NETHERLANDS" "${eindhoven_family[@]}"
add_family "Tilburg_Family_NETHERLANDS" "${tilburg_family[@]}"
add_family "GroningenCity_Family_NETHERLANDS" "${groningen_city_family[@]}"
add_family "Almere_Family_NETHERLANDS" "${almere_family[@]}"
add_family "Breda_Family_NETHERLANDS" "${breda_family[@]}"
add_family "Nijmegen_Family_NETHERLANDS" "${nijmegen_family[@]}"
add_family "Haarlem_Family_NETHERLANDS" "${haarlem_family[@]}"
add_family "Arnhem_Family_NETHERLANDS" "${arnhem_family[@]}"
add_family "Enschede_Family_NETHERLANDS" "${enschede_family[@]}"
add_family "Apeldoorn_Family_NETHERLANDS" "${apeldoorn_family[@]}"
add_family "Amersfoort_Family_NETHERLANDS" "${amersfoort_family[@]}"
add_family "Zaanstad_Family_NETHERLANDS" "${zaanstad_family[@]}"
add_family "DenBosch_Family_NETHERLANDS" "${den_bosch_family[@]}"
add_family "Maastricht_Family_NETHERLANDS" "${maastricht_family[@]}"
add_family "Delft_Family_NETHERLANDS" "${delft_family[@]}"
add_family "Leiden_Family_NETHERLANDS" "${leiden_family[@]}"
add_family "Dordrecht_Family_NETHERLANDS" "${dordrecht_family[@]}"
add_family "Leeuwarden_Family_NETHERLANDS" "${leeuwarden_family[@]}"


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
    "$OUTPUT/Other_Mail_NETHERLANDS[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-40s %s${NC}\n" \
    "Other_Mail_NETHERLANDS" "$OTHER_COUNT"


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
