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
printf "${LIGHTCYAN}${BOLD}GrabMAIL HUNGARY${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Hungary / Magyarország\n"
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

TMP_DIR="${TMPDIR:-/tmp}/hungary_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# HUNGARIAN ISP / MAIL PROVIDERS
# ============================================================

telekom_family=(
    telekom.hu
    t-online.hu
)

t_online_family=(
    t-online.hu
)

upc_family=(
    upc.hu
)

vodafone_family=(
    vodafone.hu
)

digi_family=(
    digi.hu
)

one_family=(
    one.hu
)

invitel_family=(
    invitel.hu
)

freemail_family=(
    freemail.hu
)

citromail_family=(
    citromail.hu
)

indamail_family=(
    indamail.hu
)

mailbox_family=(
    mailbox.hu
)

mailboxonline_family=(
    mailbox.hu
)

fibermail_family=(
    fibermail.hu
)

enternet_family=(
    enternet.hu
)

prtelecom_family=(
    prtelecom.hu
)

giganet_family=(
    giganet.hu
)

netfone_family=(
    netfone.hu
)

tarr_family=(
    tarr.hu
)

invitel_mail_family=(
    invitel.hu
)


# ============================================================
# HUNGARY BUSINESS / MAIL DOMAINS
# ============================================================

mail_hu_family=(
    mail.hu
)

email_hu_family=(
    email.hu
)

posta_family=(
    posta.hu
)

mav_family=(
    mav.hu
)

mol_family=(
    mol.hu
)

otp_family=(
    otpbank.hu
)


# ============================================================
# INTERNATIONAL WEBMAIL
# ============================================================

microsoft_family=(
    hotmail.com
    hotmail.hu
    outlook.com
    outlook.hu
    live.com
    msn.com
)

yahoo_family=(
    yahoo.com
    yahoo.hu
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
# HUNGARY DOMAIN CATEGORIES
# ============================================================

hu_family=(
    hu
)

co_hu_family=(
    co.hu
)

info_hu_family=(
    info.hu
)

org_hu_family=(
    org.hu
)

net_hu_family=(
    net.hu
)

gov_hu_family=(
    gov.hu
)

edu_hu_family=(
    edu.hu
)


# ============================================================
# HUNGARY ORGANIZATION CATEGORIES
# ============================================================

government_family=(
    gov.hu
    kormany
    kormanyzat
    government
)

education_family=(
    edu.hu
    egyetem
    university
    foiskola
    college
)

organization_family=(
    org.hu
)


# ============================================================
# NATIONAL / LANGUAGE KEYWORDS
# ============================================================

hungary_family=(
    hungary
    magyarorszag
    magyarország
    magyar
)

hungarian_family=(
    hungarian
    magyar
)


# ============================================================
# HUNGARY COUNTIES
#
# Domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

budapest_family=(
    budapest
)

baranya_family=(
    baranya
)

bacs_kiskun_family=(
    bacs-kiskun
    bacs_kiskun
    bacskiskun
)

bekes_family=(
    bekes
    békés
)

borsod_abauj_zemplen_family=(
    borsod
    abauj
    zemplen
    borsod-abauj-zemplen
)

csongrad_csanad_family=(
    csongrad
    csongrád
    csanad
    csongrad-csanad
)

fejer_family=(
    fejer
    fejér
)

gyor_moson_sopron_family=(
    gyor
    győr
    moson
    sopron
    gyor-moson-sopron
)

hajdu_bihar_family=(
    hajdu
    hajdú
    bihar
    hajdu-bihar
)

heves_family=(
    heves
)

jasz_nagykun_szolnok_family=(
    jasz
    jász
    nagykun
    szolnok
    jász-nagykun-szolnok
)

komarom_esztergom_family=(
    komarom
    komárom
    esztergom
    komarom-esztergom
)

nograd_family=(
    nograd
    nógrád
)

pest_family=(
    pest
)

somogy_family=(
    somogy
)

szabolcs_szatmar_bereg_family=(
    szabolcs
    szatmar
    bereg
    szabolcs-szatmar-bereg
)

tolna_family=(
    tolna
)

vas_family=(
    vas
)

veszprem_family=(
    veszprem
    veszprém
)

zala_family=(
    zala
)


# ============================================================
# MAJOR HUNGARIAN CITIES
# ============================================================

debrecen_family=(
    debrecen
)

szeged_family=(
    szeged
)

miskolc_family=(
    miskolc
)

pecs_family=(
    pecs
    pécs
)

gyor_city_family=(
    gyor
    győr
)

nyiregyhaza_family=(
    nyiregyhaza
    nyíregyháza
)

kecskemet_family=(
    kecskemet
    kecskemét
)

szekesfehervar_family=(
    szekesfehervar
    székesfehérvár
)

szombathely_family=(
    szombathely
)

szolnok_family=(
    szolnok
)

tatabanya_family=(
    tatabanya
    tatabánya
)

kaposvar_family=(
    kaposvar
    kaposvár
)

bekescsaba_family=(
    bekescsaba
    békéscsaba
)

zalaegerszeg_family=(
    zalaegerszeg
)

eger_family=(
    eger
)

erd_family=(
    erd
    erd.hu
)

sopron_city_family=(
    sopron
)

veszprem_city_family=(
    veszprem
    veszprém
)

nagykanizsa_family=(
    nagykanizsa
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
# REGISTER HUNGARIAN ISP PROVIDERS
# ============================================================

add_family "Telekom_Family_HUNGARY" "${telekom_family[@]}"
add_family "TOnline_Family_HUNGARY" "${t_online_family[@]}"
add_family "UPC_Family_HUNGARY" "${upc_family[@]}"
add_family "Vodafone_Family_HUNGARY" "${vodafone_family[@]}"
add_family "DIGI_Family_HUNGARY" "${digi_family[@]}"
add_family "One_Family_HUNGARY" "${one_family[@]}"
add_family "Invitel_Family_HUNGARY" "${invitel_family[@]}"
add_family "Freemail_Family_HUNGARY" "${freemail_family[@]}"
add_family "Citromail_Family_HUNGARY" "${citromail_family[@]}"
add_family "Indamail_Family_HUNGARY" "${indamail_family[@]}"
add_family "Mailbox_Family_HUNGARY" "${mailbox_family[@]}"
add_family "MailboxOnline_Family_HUNGARY" "${mailboxonline_family[@]}"
add_family "FiberMail_Family_HUNGARY" "${fibermail_family[@]}"
add_family "Enternet_Family_HUNGARY" "${enternet_family[@]}"
add_family "PRTelecom_Family_HUNGARY" "${prtelecom_family[@]}"
add_family "GigaNet_Family_HUNGARY" "${giganet_family[@]}"
add_family "Netfone_Family_HUNGARY" "${netfone_family[@]}"
add_family "TARR_Family_HUNGARY" "${tarr_family[@]}"
add_family "InvitelMail_Family_HUNGARY" "${invitel_mail_family[@]}"


# ============================================================
# REGISTER HUNGARY BUSINESS / MAIL
# ============================================================

add_family "Mail_HU_Family_HUNGARY" "${mail_hu_family[@]}"
add_family "Email_HU_Family_HUNGARY" "${email_hu_family[@]}"
add_family "Posta_Family_HUNGARY" "${posta_family[@]}"
add_family "MAV_Family_HUNGARY" "${mav_family[@]}"
add_family "MOL_Family_HUNGARY" "${mol_family[@]}"
add_family "OTP_Family_HUNGARY" "${otp_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL WEBMAIL
# ============================================================

add_family "Microsoft_Family_HUNGARY" "${microsoft_family[@]}"
add_family "Yahoo_Family_HUNGARY" "${yahoo_family[@]}"
add_family "Google_Family_HUNGARY" "${google_family[@]}"
add_family "Apple_Family_HUNGARY" "${apple_family[@]}"
add_family "AOL_Family_HUNGARY" "${aol_family[@]}"
add_family "Proton_Family_HUNGARY" "${proton_family[@]}"
add_family "Tuta_Family_HUNGARY" "${tuta_family[@]}"


# ============================================================
# REGISTER HUNGARY TLD FAMILIES
# ============================================================

add_family "HU_Domain_Family_HUNGARY" "${hu_family[@]}"
add_family "CO_HU_Domain_Family_HUNGARY" "${co_hu_family[@]}"
add_family "INFO_HU_Domain_Family_HUNGARY" "${info_hu_family[@]}"
add_family "ORG_HU_Domain_Family_HUNGARY" "${org_hu_family[@]}"
add_family "NET_HU_Domain_Family_HUNGARY" "${net_hu_family[@]}"
add_family "GOV_HU_Domain_Family_HUNGARY" "${gov_hu_family[@]}"
add_family "EDU_HU_Domain_Family_HUNGARY" "${edu_hu_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Government_Family_HUNGARY" "${government_family[@]}"
add_family "Education_Family_HUNGARY" "${education_family[@]}"
add_family "Organization_Family_HUNGARY" "${organization_family[@]}"


# ============================================================
# REGISTER NATIONAL / LANGUAGE
# ============================================================

add_family "Hungary_Family_HUNGARY" "${hungary_family[@]}"
add_family "Hungarian_Family_HUNGARY" "${hungarian_family[@]}"


# ============================================================
# REGISTER COUNTIES
# ============================================================

add_family "Budapest_Family_HUNGARY" "${budapest_family[@]}"
add_family "Baranya_Family_HUNGARY" "${baranya_family[@]}"
add_family "BacsKiskun_Family_HUNGARY" "${bacs_kiskun_family[@]}"
add_family "Bekes_Family_HUNGARY" "${bekes_family[@]}"
add_family "BorsodAbaujZemplen_Family_HUNGARY" "${borsod_abauj_zemplen_family[@]}"
add_family "CsongradCsanad_Family_HUNGARY" "${csongrad_csanad_family[@]}"
add_family "Fejer_Family_HUNGARY" "${fejer_family[@]}"
add_family "GyorMosonSopron_Family_HUNGARY" "${gyor_moson_sopron_family[@]}"
add_family "HajduBihar_Family_HUNGARY" "${hajdu_bihar_family[@]}"
add_family "Heves_Family_HUNGARY" "${heves_family[@]}"
add_family "JaszNagykunSzolnok_Family_HUNGARY" "${jasz_nagykun_szolnok_family[@]}"
add_family "KomaromEsztergom_Family_HUNGARY" "${komarom_esztergom_family[@]}"
add_family "Nograd_Family_HUNGARY" "${nograd_family[@]}"
add_family "Pest_Family_HUNGARY" "${pest_family[@]}"
add_family "Somogy_Family_HUNGARY" "${somogy_family[@]}"
add_family "SzabolcsSzatmarBereg_Family_HUNGARY" "${szabolcs_szatmar_bereg_family[@]}"
add_family "Tolna_Family_HUNGARY" "${tolna_family[@]}"
add_family "Vas_Family_HUNGARY" "${vas_family[@]}"
add_family "Veszprem_Family_HUNGARY" "${veszprem_family[@]}"
add_family "Zala_Family_HUNGARY" "${zala_family[@]}"


# ============================================================
# REGISTER MAJOR CITIES
# ============================================================

add_family "Debrecen_Family_HUNGARY" "${debrecen_family[@]}"
add_family "Szeged_Family_HUNGARY" "${szeged_family[@]}"
add_family "Miskolc_Family_HUNGARY" "${miskolc_family[@]}"
add_family "Pecs_Family_HUNGARY" "${pecs_family[@]}"
add_family "GyorCity_Family_HUNGARY" "${gyor_city_family[@]}"
add_family "Nyiregyhaza_Family_HUNGARY" "${nyiregyhaza_family[@]}"
add_family "Kecskemet_Family_HUNGARY" "${kecskemet_family[@]}"
add_family "Szekesfehervar_Family_HUNGARY" "${szekesfehervar_family[@]}"
add_family "Szombathely_Family_HUNGARY" "${szombathely_family[@]}"
add_family "Szolnok_Family_HUNGARY" "${szolnok_family[@]}"
add_family "Tatabanya_Family_HUNGARY" "${tatabanya_family[@]}"
add_family "Kaposvar_Family_HUNGARY" "${kaposvar_family[@]}"
add_family "Bekescsaba_Family_HUNGARY" "${bekescsaba_family[@]}"
add_family "Zalaegerszeg_Family_HUNGARY" "${zalaegerszeg_family[@]}"
add_family "Eger_Family_HUNGARY" "${eger_family[@]}"
add_family "Erd_Family_HUNGARY" "${erd_family[@]}"
add_family "SopronCity_Family_HUNGARY" "${sopron_city_family[@]}"
add_family "VeszpremCity_Family_HUNGARY" "${veszprem_city_family[@]}"
add_family "Nagykanizsa_Family_HUNGARY" "${nagykanizsa_family[@]}"


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
    "$OUTPUT/Other_Mail_HUNGARY[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-45s %s${NC}\n" \
    "Other_Mail_HUNGARY" "$OTHER_COUNT"


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
