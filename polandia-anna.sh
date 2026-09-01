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
printf "${LIGHTCYAN}${BOLD}GrabMAIL Poland${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Poland\n"
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

TMP_DIR="${TMPDIR:-/tmp}/poland_mail_filter_$$"

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
# POLISH MAIL PROVIDERS
# ============================================================

wp_family=(
    wp
    wp.pl
    wirtualnapolska
    wirtualna-polska
)

onet_family=(
    onet
    onet.pl
)

interia_family=(
    interia
    interia.pl
)

o2_family=(
    o2
    o2.pl
)

gazeta_family=(
    gazeta
    gazeta.pl
)

op_family=(
    op
    op.pl
)

poczta_family=(
    poczta
    poczta.pl
)

interia_poczta_family=(
    poczta.interia
)

tlen_family=(
    tlen
    tlen.pl
)

autograf_family=(
    autograf
    autograf.pl
)

republika_family=(
    republika
    republika.pl
)

onet_poczta_family=(
    poczta.onet
)

mailbox_family=(
    mailbox
    mailbox.pl
)


# ============================================================
# POLAND ISP / TELECOM FAMILIES
# ============================================================

orange_family=(
    orange
    orange.pl
)

neostrada_family=(
    neostrada
    neostrada.pl
)

tp_family=(
    tp
    tpnet
    tpnet.pl
)

play_family=(
    play
    play.pl
)

plus_family=(
    plus
    plus.pl
)

t_mobile_family=(
    t-mobile
    tmobile
    t-mobile.pl
)

netia_family=(
    netia
    netia.pl
)

vectra_family=(
    vectra
    vectra.pl
)

upc_family=(
    upc
    upc.pl
)

cyfrowypolsat_family=(
    cyfrowypolsat
    cyfrowypolsat.pl
)

polsat_family=(
    polsat
    polsat.pl
)

inea_family=(
    inea
    inea.pl
)

multimedia_family=(
    multimedia
    multimedia.pl
)

aero2_family=(
    aero2
    aero2.pl
)

njumobile_family=(
    njumobile
    njumobile.pl
)

lycamobile_family=(
    lycamobile
    lycamobile.pl
)

heyah_family=(
    heyah
    heyah.pl
)

toyafamily=(
    toya
    toya.pl
)

eastwest_family=(
    eastwest
    eastwest.pl
)

dialog_family=(
    dialog
    dialog.pl
)


# ============================================================
# POLAND DOMAIN CATEGORIES
# ============================================================

pl_family=(
    pl
)

compl_family=(
    com.pl
)

netpl_family=(
    net.pl
)

orgpl_family=(
    org.pl
)

bizpl_family=(
    biz.pl
)

info_family=(
    info.pl
)

edupl_family=(
    edu.pl
)

govpl_family=(
    gov.pl
)

milpl_family=(
    mil.pl
)

policepl_family=(
    policja.pl
)

appl_family=(
    app.pl
)


# ============================================================
# POLISH EDUCATION / GOVERNMENT
# ============================================================

education_family=(
    edu.pl
    ac.pl
)

government_family=(
    gov.pl
    sejm.pl
    senat.pl
    prezydent.pl
)

organization_family=(
    org.pl
)

military_family=(
    mil.pl
)

police_family=(
    policja.pl
)


# ============================================================
# POLISH VOIVODESHIPS
# ============================================================

dolnoslaskie_family=(
    dolnoslaskie
    dolnośląskie
    dolno-slaskie
    dolnoslaskie.pl
)

kujawsko_pomorskie_family=(
    kujawsko-pomorskie
    kujawsko_pomorskie
    kujawsko-pomorskie.pl
)

lubelskie_family=(
    lubelskie
    lubelskie.pl
)

lubuskie_family=(
    lubuskie
    lubuskie.pl
)

lodzkie_family=(
    lodzkie
    łódzkie
    lodzkie.pl
)

malopolskie_family=(
    malopolskie
    małopolskie
    malopolskie.pl
)

mazowieckie_family=(
    mazowieckie
    mazowieckie.pl
)

opolskie_family=(
    opolskie
    opolskie.pl
)

podkarpackie_family=(
    podkarpackie
    podkarpackie.pl
)

podlaskie_family=(
    podlaskie
    podlaskie.pl
)

pomorskie_family=(
    pomorskie
    pomorskie.pl
)

slaskie_family=(
    slaskie
    śląskie
    slaskie.pl
)

swietokrzyskie_family=(
    swietokrzyskie
    świętokrzyskie
    swietokrzyskie.pl
)

warminsko_mazurskie_family=(
    warminsko-mazurskie
    warminsko_mazurskie
    warmińsko-mazurskie
    warminsko-mazurskie.pl
)

wielkopolskie_family=(
    wielkopolskie
    wielkopolskie.pl
)

zachodniopomorskie_family=(
    zachodniopomorskie
    zachodniopomorskie.pl
)


# ============================================================
# MAJOR POLISH CITIES
# ============================================================

warsaw_family=(
    warsaw
    warszawa
    warszawa.pl
)

krakow_family=(
    krakow
    kraków
    krakow.pl
)

lodz_city_family=(
    lodz
    łódź
    lodz.pl
)

wroclaw_family=(
    wroclaw
    wrocław
    wroclaw.pl
)

poznan_family=(
    poznan
    poznań
    poznan.pl
)

gdansk_family=(
    gdansk
    gdańsk
    gdansk.pl
)

szczecin_family=(
    szczecin
    szczecin.pl
)

bydgoszcz_family=(
    bydgoszcz
    bydgoszcz.pl
)

lublin_family=(
    lublin
    lublin.pl
)

bialystok_family=(
    bialystok
    białystok
    bialystok.pl
)

katowice_family=(
    katowice
    katowice.pl
)

gdynia_family=(
    gdynia
    gdynia.pl
)

czestochowa_family=(
    czestochowa
    częstochowa
    czestochowa.pl
)

radom_family=(
    radom
    radom.pl
)

torun_family=(
    torun
    toruń
    torun.pl
)

sosnowiec_family=(
    sosnowiec
    sosnowiec.pl
)

rzeszow_family=(
    rzeszow
    rzeszów
    rzeszow.pl
)

kielce_family=(
    kielce
    kielce.pl
)

gliwice_family=(
    gliwice
    gliwice.pl
)

olsztyn_family=(
    olsztyn
    olsztyn.pl
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
# REGISTER GLOBAL MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_Poland" "${microsoft_family[@]}"
add_family "Yahoo_Family_Poland" "${yahoo_family[@]}"
add_family "Google_Family_Poland" "${google_family[@]}"
add_family "AOL_Family_Poland" "${aol_family[@]}"
add_family "Apple_Family_Poland" "${apple_family[@]}"
add_family "Proton_Family_Poland" "${proton_family[@]}"
add_family "Tuta_Family_Poland" "${tuta_family[@]}"


# ============================================================
# REGISTER POLISH MAIL PROVIDERS
# ============================================================

add_family "WP_Family_Poland" "${wp_family[@]}"
add_family "Onet_Family_Poland" "${onet_family[@]}"
add_family "Interia_Family_Poland" "${interia_family[@]}"
add_family "O2_Family_Poland" "${o2_family[@]}"
add_family "Gazeta_Family_Poland" "${gazeta_family[@]}"
add_family "OP_Family_Poland" "${op_family[@]}"
add_family "Poczta_Family_Poland" "${poczta_family[@]}"
add_family "InteriaPoczta_Family_Poland" "${interia_poczta_family[@]}"
add_family "Tlen_Family_Poland" "${tlen_family[@]}"
add_family "Autograf_Family_Poland" "${autograf_family[@]}"
add_family "Republika_Family_Poland" "${republika_family[@]}"
add_family "OnetPoczta_Family_Poland" "${onet_poczta_family[@]}"
add_family "Mailbox_Family_Poland" "${mailbox_family[@]}"


# ============================================================
# REGISTER ISP FAMILIES
# ============================================================

add_family "Orange_Family_Poland" "${orange_family[@]}"
add_family "Neostrada_Family_Poland" "${neostrada_family[@]}"
add_family "TP_Family_Poland" "${tp_family[@]}"
add_family "Play_Family_Poland" "${play_family[@]}"
add_family "Plus_Family_Poland" "${plus_family[@]}"
add_family "TMobile_Family_Poland" "${t_mobile_family[@]}"
add_family "Netia_Family_Poland" "${netia_family[@]}"
add_family "Vectra_Family_Poland" "${vectra_family[@]}"
add_family "UPC_Family_Poland" "${upc_family[@]}"
add_family "CyfrowyPolsat_Family_Poland" "${cyfrowypolsat_family[@]}"
add_family "Polsat_Family_Poland" "${polsat_family[@]}"
add_family "INEA_Family_Poland" "${inea_family[@]}"
add_family "Multimedia_Family_Poland" "${multimedia_family[@]}"
add_family "Aero2_Family_Poland" "${aero2_family[@]}"
add_family "NjuMobile_Family_Poland" "${njumobile_family[@]}"
add_family "LycaMobile_Family_Poland" "${lycamobile_family[@]}"
add_family "Heyah_Family_Poland" "${heyah_family[@]}"
add_family "Toya_Family_Poland" "${toyafamily[@]}"
add_family "EastWest_Family_Poland" "${eastwest_family[@]}"
add_family "Dialog_Family_Poland" "${dialog_family[@]}"


# ============================================================
# REGISTER POLISH TLD FAMILIES
# ============================================================

add_family "PL_Domain_Family_Poland" "${pl_family[@]}"
add_family "COM_PL_Family_Poland" "${compl_family[@]}"
add_family "NET_PL_Family_Poland" "${netpl_family[@]}"
add_family "ORG_PL_Family_Poland" "${orgpl_family[@]}"
add_family "BIZ_PL_Family_Poland" "${bizpl_family[@]}"
add_family "INFO_PL_Family_Poland" "${info_family[@]}"
add_family "EDU_PL_Family_Poland" "${edupl_family[@]}"
add_family "GOV_PL_Family_Poland" "${govpl_family[@]}"
add_family "MIL_PL_Family_Poland" "${milpl_family[@]}"
add_family "Police_PL_Family_Poland" "${policepl_family[@]}"
add_family "APP_PL_Family_Poland" "${appl_family[@]}"


# ============================================================
# REGISTER SPECIAL CATEGORIES
# ============================================================

add_family "Education_Family_Poland" "${education_family[@]}"
add_family "Government_Family_Poland" "${government_family[@]}"
add_family "Organization_Family_Poland" "${organization_family[@]}"
add_family "Military_Family_Poland" "${military_family[@]}"
add_family "Police_Family_Poland" "${police_family[@]}"


# ============================================================
# REGISTER VOIVODESHIPS
# ============================================================

add_family "Dolnoslaskie_Family_Poland" "${dolnoslaskie_family[@]}"
add_family "KujawskoPomorskie_Family_Poland" "${kujawsko_pomorskie_family[@]}"
add_family "Lubelskie_Family_Poland" "${lubelskie_family[@]}"
add_family "Lubuskie_Family_Poland" "${lubuskie_family[@]}"
add_family "Lodzkie_Family_Poland" "${lodzkie_family[@]}"
add_family "Malopolskie_Family_Poland" "${malopolskie_family[@]}"
add_family "Mazowieckie_Family_Poland" "${mazowieckie_family[@]}"
add_family "Opolskie_Family_Poland" "${opolskie_family[@]}"
add_family "Podkarpackie_Family_Poland" "${podkarpackie_family[@]}"
add_family "Podlaskie_Family_Poland" "${podlaskie_family[@]}"
add_family "Pomorskie_Family_Poland" "${pomorskie_family[@]}"
add_family "Slaskie_Family_Poland" "${slaskie_family[@]}"
add_family "Swietokrzyskie_Family_Poland" "${swietokrzyskie_family[@]}"
add_family "WarminskoMazurskie_Family_Poland" "${warminsko_mazurskie_family[@]}"
add_family "Wielkopolskie_Family_Poland" "${wielkopolskie_family[@]}"
add_family "Zachodniopomorskie_Family_Poland" "${zachodniopomorskie_family[@]}"


# ============================================================
# REGISTER MAJOR CITIES
# ============================================================

add_family "Warsaw_Family_Poland" "${warsaw_family[@]}"
add_family "Krakow_Family_Poland" "${krakow_family[@]}"
add_family "Lodz_Family_Poland" "${lodz_city_family[@]}"
add_family "Wroclaw_Family_Poland" "${wroclaw_family[@]}"
add_family "Poznan_Family_Poland" "${poznan_family[@]}"
add_family "Gdansk_Family_Poland" "${gdansk_family[@]}"
add_family "Szczecin_Family_Poland" "${szczecin_family[@]}"
add_family "Bydgoszcz_Family_Poland" "${bydgoszcz_family[@]}"
add_family "Lublin_Family_Poland" "${lublin_family[@]}"
add_family "Bialystok_Family_Poland" "${bialystok_family[@]}"
add_family "Katowice_Family_Poland" "${katowice_family[@]}"
add_family "Gdynia_Family_Poland" "${gdynia_family[@]}"
add_family "Czestochowa_Family_Poland" "${czestochowa_family[@]}"
add_family "Radom_Family_Poland" "${radom_family[@]}"
add_family "Torun_Family_Poland" "${torun_family[@]}"
add_family "Sosnowiec_Family_Poland" "${sosnowiec_family[@]}"
add_family "Rzeszow_Family_Poland" "${rzeszow_family[@]}"
add_family "Kielce_Family_Poland" "${kielce_family[@]}"
add_family "Gliwice_Family_Poland" "${gliwice_family[@]}"
add_family "Olsztyn_Family_Poland" "${olsztyn_family[@]}"


# ============================================================
# OUTPUT
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

        printf "${GREEN}[OK] %-50s %s${NC}\n" \
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
    "$OUTPUT/Other_Mail_Poland[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-45s %s${NC}\n" \
    "Other_Mail_Poland" "$OTHER_COUNT"


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
