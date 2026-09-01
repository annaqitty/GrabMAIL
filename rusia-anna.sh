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
printf "${LIGHTCYAN}${BOLD}GrabMAIL Russia${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : Russia\n"
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

TMP_DIR="${TMPDIR:-/tmp}/russia_mail_filter_$$"

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
# RUSSIAN MAIL PROVIDERS
# ============================================================

yandex_family=(
    yandex
    yandex.ru
    ya.ru
)

mailru_family=(
    mail
    mail.ru
    mail-ru
)

rambler_family=(
    rambler
    rambler.ru
)

inboxru_family=(
    inbox
    inbox.ru
)

list_family=(
    list
    list.ru
)

bk_family=(
    bk
    bk.ru
)

internetru_family=(
    internet
    internet.ru
)

qip_family=(
    qip
    qip.ru
)

pochta_family=(
    pochta
    pochta.ru
)

autorambler_family=(
    autorambler
    autorambler.ru
)

kmru_family=(
    km
    km.ru
)

rol_family=(
    rol
    rol.ru
)

newmailru_family=(
    newmail
    newmail.ru
)


# ============================================================
# RUSSIAN ISP / TELECOM FAMILIES
# ============================================================

rostelecom_family=(
    rostelecom
)

mts_family=(
    mts
    mts.ru
)

beeline_family=(
    beeline
    beeline.ru
)

megafon_family=(
    megafon
    megafon.ru
)

tele2_family=(
    tele2
    tele2.ru
)

ttk_family=(
    ttk
    ttk.ru
)

domru_family=(
    dom
    dom.ru
    domru
)

ertelecom_family=(
    ertelecom
)

akado_family=(
    akado
    akado.ru
)

netbynet_family=(
    netbynet
    netbynet.ru
)

yota_family=(
    yota
    yota.ru
)

rt_family=(
    rt
    rt.ru
)

skylink_family=(
    skylink
    skylink.ru
)

transtelecom_family=(
    transtelecom
)

corbina_family=(
    corbina
    corbina.ru
)

comstar_family=(
    comstar
    comstar.ru
)

avangard_family=(
    avangard
    avangard.ru
)

stream_family=(
    stream
    stream.ru
)

onlime_family=(
    onlime
    onlime.ru
)


# ============================================================
# RUSSIA DOMAIN CATEGORIES
# ============================================================

ru_family=(
    ru
)

rf_family=(
    рф
)

xn_rf_family=(
    xn--p1ai
)

su_family=(
    su
)

moscow_domain_family=(
    mos
    moscow
)

spb_domain_family=(
    spb
    petersburg
)


# ============================================================
# GENERAL DOMAIN CATEGORIES
# ============================================================

edu_family=(
    edu
)

gov_family=(
    gov
)

org_family=(
    org
)

mil_family=(
    mil
)


# ============================================================
# FEDERAL CITIES
# ============================================================

moscow_family=(
    moscow
    moskva
    москва
)

saintpetersburg_family=(
    saintpetersburg
    saint-petersburg
    stpetersburg
    spb
    питер
    петербург
)

sevastopol_family=(
    sevastopol
    севастополь
)


# ============================================================
# REPUBLICS
# ============================================================

adygea_family=(
    adygea
    adygeya
    адыгея
)

altai_republic_family=(
    altai
    altai-republic
    республика-алтай
)

bashkortostan_family=(
    bashkortostan
    bashkiria
    башкортостан
)

buryatia_family=(
    buryatia
    бурятия
)

dagestan_family=(
    dagestan
    дагестан
)

ingushetia_family=(
    ingushetia
    ингушетия
)

kabardinobalkaria_family=(
    kabardino-balkaria
    kabardinobalkaria
    кабардино-балкария
)

kalmykia_family=(
    kalmykia
    калмыкия
)

karachaycherkessia_family=(
    karachay-cherkessia
    karachaycherkessia
    карачаево-черкесия
)

karelia_family=(
    karelia
    карелия
)

komi_family=(
    komi
    коми
)

mari_el_family=(
    mari-el
    mariel
    марий-эл
)

mordovia_family=(
    mordovia
    мордовия
)

sakha_family=(
    sakha
    yakutia
    саха
    якутия
)

north_ossetia_family=(
    north-ossetia
    northossetia
    северная-осетия
)

tatarstan_family=(
    tatarstan
    татарстан
)

tuva_family=(
    tuva
    тыва
    тувa
)

udmurtia_family=(
    udmurtia
    удмуртия
)

khakassia_family=(
    khakassia
    хакасия
)

chechnya_family=(
    chechnya
    чечня
)


# ============================================================
# OBLASTS
# ============================================================

amur_family=(
    amur
    amuroblast
    амур
)

arkhangelsk_family=(
    arkhangelsk
    архангельск
)

astrakhan_family=(
    astrakhan
    астрахань
)

belgorod_family=(
    belgorod
    белгород
)

bryansk_family=(
    bryansk
    брянск
)

vladimir_family=(
    vladimir
    владимир
)

volgograd_family=(
    volgograd
    волгоград
)

vologda_family=(
    vologda
    вологда
)

voronezh_family=(
    voronezh
    воронеж
)

ivanovo_family=(
    ivanovo
    иваново
)

irkutsk_family=(
    irkutsk
    иркутск
)

kaliningrad_family=(
    kaliningrad
    калининград
)

kaluga_family=(
    kaluga
    калуга
)

kemerovo_family=(
    kemerovo
    кемерово
)

kirov_family=(
    kirov
    киров
)

kostroma_family=(
    kostroma
    кострома
)

kurgan_family=(
    kurgan
    курган
)

kursk_family=(
    kursk
    курск
)

leningrad_family=(
    leningrad
    ленинград
)

lipetsk_family=(
    lipetsk
    липецк
)

magadan_family=(
    magadan
    магадан
)

moscow_oblast_family=(
    moscowoblast
    moscow-region
    московская-область
)

murmansk_family=(
    murmansk
    мурманск
)

nizhny_novgorod_family=(
    nizhny-novgorod
    nizhny_novgorod
    нижний-новгород
)

novgorod_family=(
    novgorod
    новгород
)

novosibirsk_family=(
    novosibirsk
    новосибирск
)

omsk_family=(
    omsk
    омск
)

orenburg_family=(
    orenburg
    оренбург
)

oryol_family=(
    oryol
    orel
    орёл
    орел
)

penza_family=(
    penza
    пенза
)

perm_family=(
    perm
    пермь
)

pskov_family=(
    pskov
    псков
)

rostov_family=(
    rostov
    ростов
)

ryazan_family=(
    ryazan
    рязань
)

samara_family=(
    samara
    самара
)

saratov_family=(
    saratov
    саратов
)

sakhalin_family=(
    sakhalin
    сахалин
)

smolensk_family=(
    smolensk
    смоленск
)

sverdlovsk_family=(
    sverdlovsk
    екатеринбург
)

tambov_family=(
    tambov
    тамбов
)

tver_family=(
    tver
    тверь
)

tomsk_family=(
    tomsk
    томск
)

tula_family=(
    tula
    тула
)

tyumen_family=(
    tyumen
    тюмень
)

ulyanovsk_family=(
    ulyanovsk
    ульяновск
)

chelyabinsk_family=(
    chelyabinsk
    челябинск
)

yaroslavl_family=(
    yaroslavl
    ярославль
)


# ============================================================
# KRAIS
# ============================================================

altai_krai_family=(
    altai-krai
    altai-kraj
    алтайский-край
)

kamchatka_family=(
    kamchatka
    камчатка
)

khabarovsk_family=(
    khabarovsk
    хабаровск
)

krasnodar_family=(
    krasnodar
    краснодар
)

krasnoyarsk_family=(
    krasnoyarsk
    красноярск
)

perm_krai_family=(
    perm-krai
    пермский-край
)

primorsky_family=(
    primorsky
    primorsky-krai
    приморский-край
)

stavropol_family=(
    stavropol
    stavropol-krai
    ставропольский-край
)

zabaykalsky_family=(
    zabaykalsky
    transbaikal
    забайкальский-край
)


# ============================================================
# AUTONOMOUS OKRUGS
# ============================================================

nenets_family=(
    nenets
    nenetsia
    ненецкий
)

khantymansi_family=(
    khanty-mansi
    khantymansi
    хмао
)

chukotka_family=(
    chukotka
    чукотка
)

yamal_family=(
    yamal
    yamal-nenets
    ямал
)


# ============================================================
# MAJOR RUSSIAN CITIES
# ============================================================

novosibirsk_city_family=(
    novosibirsk
    новосибирск
)

yekaterinburg_family=(
    yekaterinburg
    ekaterinburg
    екатеринбург
)

kazan_family=(
    kazan
    казань
)

nizhny_novgorod_city_family=(
    nizhny-novgorod
    нижний-новгород
)

chelyabinsk_city_family=(
    chelyabinsk
    челябинск
)

samara_city_family=(
    samara
    самара
)

omsk_city_family=(
    omsk
    омск
)

rostov_on_don_family=(
    rostov-on-don
    rostovondon
    ростов-на-дону
)

ufa_family=(
    ufa
    уфа
)

krasnoyarsk_city_family=(
    krasnoyarsk
    красноярск
)

voronezh_city_family=(
    voronezh
    воронеж
)

perm_city_family=(
    perm
    пермь
)

volgograd_city_family=(
    volgograd
    волгоград
)

krasnodar_city_family=(
    krasnodar
    краснодар
)

saratov_city_family=(
    saratov
    саратов
)

tyumen_city_family=(
    tyumen
    тюмень
)

irkutsk_city_family=(
    irkutsk
    иркутск
)

barnaul_family=(
    barnaul
    барнаул
)

vladivostok_family=(
    vladivostok
    владивосток
)

yaroslavl_city_family=(
    yaroslavl
    ярославль
)

makhachkala_family=(
    makhachkala
    махачкала
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
# REGISTER MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_Russia" "${microsoft_family[@]}"
add_family "Yahoo_Family_Russia" "${yahoo_family[@]}"
add_family "Google_Family_Russia" "${google_family[@]}"
add_family "AOL_Family_Russia" "${aol_family[@]}"
add_family "Apple_Family_Russia" "${apple_family[@]}"
add_family "Proton_Family_Russia" "${proton_family[@]}"
add_family "Tuta_Family_Russia" "${tuta_family[@]}"

add_family "Yandex_Family_Russia" "${yandex_family[@]}"
add_family "MailRU_Family_Russia" "${mailru_family[@]}"
add_family "Rambler_Family_Russia" "${rambler_family[@]}"
add_family "InboxRU_Family_Russia" "${inboxru_family[@]}"
add_family "ListRU_Family_Russia" "${list_family[@]}"
add_family "BK_Family_Russia" "${bk_family[@]}"
add_family "InternetRU_Family_Russia" "${internetru_family[@]}"
add_family "QIP_Family_Russia" "${qip_family[@]}"
add_family "Pochta_Family_Russia" "${pochta_family[@]}"
add_family "AutoRambler_Family_Russia" "${autorambler_family[@]}"
add_family "KM_Family_Russia" "${kmru_family[@]}"
add_family "ROL_Family_Russia" "${rol_family[@]}"
add_family "NewMailRU_Family_Russia" "${newmailru_family[@]}"


# ============================================================
# REGISTER ISP FAMILIES
# ============================================================

add_family "Rostelecom_Family_Russia" "${rostelecom_family[@]}"
add_family "MTS_Family_Russia" "${mts_family[@]}"
add_family "Beeline_Family_Russia" "${beeline_family[@]}"
add_family "MegaFon_Family_Russia" "${megafon_family[@]}"
add_family "Tele2_Family_Russia" "${tele2_family[@]}"
add_family "TTK_Family_Russia" "${ttk_family[@]}"
add_family "DomRU_Family_Russia" "${domru_family[@]}"
add_family "ERTelecom_Family_Russia" "${ertelecom_family[@]}"
add_family "Akado_Family_Russia" "${akado_family[@]}"
add_family "NetByNet_Family_Russia" "${netbynet_family[@]}"
add_family "Yota_Family_Russia" "${yota_family[@]}"
add_family "RT_Family_Russia" "${rt_family[@]}"
add_family "SkyLink_Family_Russia" "${skylink_family[@]}"
add_family "Transtelecom_Family_Russia" "${transtelecom_family[@]}"
add_family "Corbina_Family_Russia" "${corbina_family[@]}"
add_family "Comstar_Family_Russia" "${comstar_family[@]}"
add_family "Avangard_Family_Russia" "${avangard_family[@]}"
add_family "Stream_Family_Russia" "${stream_family[@]}"
add_family "Onlime_Family_Russia" "${onlime_family[@]}"


# ============================================================
# REGISTER TLD CATEGORIES
# ============================================================

add_family "RU_Domain_Family_Russia" "${ru_family[@]}"
add_family "RF_Domain_Family_Russia" "${rf_family[@]}"
add_family "XN_RF_Domain_Family_Russia" "${xn_rf_family[@]}"
add_family "SU_Domain_Family_Russia" "${su_family[@]}"

add_family "Education_Family_Russia" "${edu_family[@]}"
add_family "Government_Family_Russia" "${gov_family[@]}"
add_family "Organization_Family_Russia" "${org_family[@]}"
add_family "Military_Family_Russia" "${mil_family[@]}"


# ============================================================
# REGISTER FEDERAL CITIES
# ============================================================

add_family "Moscow_Family_Russia" "${moscow_family[@]}"
add_family "SaintPetersburg_Family_Russia" "${saintpetersburg_family[@]}"
add_family "Sevastopol_Family_Russia" "${sevastopol_family[@]}"


# ============================================================
# REGISTER REPUBLICS
# ============================================================

add_family "Adygea_Family_Russia" "${adygea_family[@]}"
add_family "AltaiRepublic_Family_Russia" "${altai_republic_family[@]}"
add_family "Bashkortostan_Family_Russia" "${bashkortostan_family[@]}"
add_family "Buryatia_Family_Russia" "${buryatia_family[@]}"
add_family "Dagestan_Family_Russia" "${dagestan_family[@]}"
add_family "Ingushetia_Family_Russia" "${ingushetia_family[@]}"
add_family "KabardinoBalkaria_Family_Russia" "${kabardinobalkaria_family[@]}"
add_family "Kalmykia_Family_Russia" "${kalmykia_family[@]}"
add_family "KarachayCherkessia_Family_Russia" "${karachaycherkessia_family[@]}"
add_family "Karelia_Family_Russia" "${karelia_family[@]}"
add_family "Komi_Family_Russia" "${komi_family[@]}"
add_family "MariEl_Family_Russia" "${mari_el_family[@]}"
add_family "Mordovia_Family_Russia" "${mordovia_family[@]}"
add_family "Sakha_Family_Russia" "${sakha_family[@]}"
add_family "NorthOssetia_Family_Russia" "${north_ossetia_family[@]}"
add_family "Tatarstan_Family_Russia" "${tatarstan_family[@]}"
add_family "Tuva_Family_Russia" "${tuva_family[@]}"
add_family "Udmurtia_Family_Russia" "${udmurtia_family[@]}"
add_family "Khakassia_Family_Russia" "${khakassia_family[@]}"
add_family "Chechnya_Family_Russia" "${chechnya_family[@]}"


# ============================================================
# REGISTER OBLASTS
# ============================================================

add_family "Amur_Family_Russia" "${amur_family[@]}"
add_family "Arkhangelsk_Family_Russia" "${arkhangelsk_family[@]}"
add_family "Astrakhan_Family_Russia" "${astrakhan_family[@]}"
add_family "Belgorod_Family_Russia" "${belgorod_family[@]}"
add_family "Bryansk_Family_Russia" "${bryansk_family[@]}"
add_family "Vladimir_Family_Russia" "${vladimir_family[@]}"
add_family "Volgograd_Family_Russia" "${volgograd_family[@]}"
add_family "Vologda_Family_Russia" "${vologda_family[@]}"
add_family "Voronezh_Family_Russia" "${voronezh_family[@]}"
add_family "Ivanovo_Family_Russia" "${ivanovo_family[@]}"
add_family "Irkutsk_Family_Russia" "${irkutsk_family[@]}"
add_family "Kaliningrad_Family_Russia" "${kaliningrad_family[@]}"
add_family "Kaluga_Family_Russia" "${kaluga_family[@]}"
add_family "Kemerovo_Family_Russia" "${kemerovo_family[@]}"
add_family "Kirov_Family_Russia" "${kirov_family[@]}"
add_family "Kostroma_Family_Russia" "${kostroma_family[@]}"
add_family "Kurgan_Family_Russia" "${kurgan_family[@]}"
add_family "Kursk_Family_Russia" "${kursk_family[@]}"
add_family "Leningrad_Family_Russia" "${leningrad_family[@]}"
add_family "Lipetsk_Family_Russia" "${lipetsk_family[@]}"
add_family "Magadan_Family_Russia" "${magadan_family[@]}"
add_family "MoscowOblast_Family_Russia" "${moscow_oblast_family[@]}"
add_family "Murmansk_Family_Russia" "${murmansk_family[@]}"
add_family "NizhnyNovgorod_Family_Russia" "${nizhny_novgorod_family[@]}"
add_family "Novgorod_Family_Russia" "${novgorod_family[@]}"
add_family "Novosibirsk_Family_Russia" "${novosibirsk_family[@]}"
add_family "Omsk_Family_Russia" "${omsk_family[@]}"
add_family "Orenburg_Family_Russia" "${orenburg_family[@]}"
add_family "Oryol_Family_Russia" "${oryol_family[@]}"
add_family "Penza_Family_Russia" "${penza_family[@]}"
add_family "Perm_Family_Russia" "${perm_family[@]}"
add_family "Pskov_Family_Russia" "${pskov_family[@]}"
add_family "Rostov_Family_Russia" "${rostov_family[@]}"
add_family "Ryazan_Family_Russia" "${ryazan_family[@]}"
add_family "Samara_Family_Russia" "${samara_family[@]}"
add_family "Saratov_Family_Russia" "${saratov_family[@]}"
add_family "Sakhalin_Family_Russia" "${sakhalin_family[@]}"
add_family "Smolensk_Family_Russia" "${smolensk_family[@]}"
add_family "Sverdlovsk_Family_Russia" "${sverdlovsk_family[@]}"
add_family "Tambov_Family_Russia" "${tambov_family[@]}"
add_family "Tver_Family_Russia" "${tver_family[@]}"
add_family "Tomsk_Family_Russia" "${tomsk_family[@]}"
add_family "Tula_Family_Russia" "${tula_family[@]}"
add_family "Tyumen_Family_Russia" "${tyumen_family[@]}"
add_family "Ulyanovsk_Family_Russia" "${ulyanovsk_family[@]}"
add_family "Chelyabinsk_Family_Russia" "${chelyabinsk_family[@]}"
add_family "Yaroslavl_Family_Russia" "${yaroslavl_family[@]}"


# ============================================================
# REGISTER KRAIS
# ============================================================

add_family "AltaiKrai_Family_Russia" "${altai_krai_family[@]}"
add_family "Kamchatka_Family_Russia" "${kamchatka_family[@]}"
add_family "Khabarovsk_Family_Russia" "${khabarovsk_family[@]}"
add_family "Krasnodar_Family_Russia" "${krasnodar_family[@]}"
add_family "Krasnoyarsk_Family_Russia" "${krasnoyarsk_family[@]}"
add_family "PermKrai_Family_Russia" "${perm_krai_family[@]}"
add_family "Primorsky_Family_Russia" "${primorsky_family[@]}"
add_family "Stavropol_Family_Russia" "${stavropol_family[@]}"
add_family "Zabaykalsky_Family_Russia" "${zabaykalsky_family[@]}"


# ============================================================
# REGISTER AUTONOMOUS OKRUGS
# ============================================================

add_family "Nenets_Family_Russia" "${nenets_family[@]}"
add_family "KhantyMansi_Family_Russia" "${khantymansi_family[@]}"
add_family "Chukotka_Family_Russia" "${chukotka_family[@]}"
add_family "Yamal_Family_Russia" "${yamal_family[@]}"


# ============================================================
# REGISTER MAJOR CITIES
# ============================================================

add_family "NovosibirskCity_Family_Russia" "${novosibirsk_city_family[@]}"
add_family "Yekaterinburg_Family_Russia" "${yekaterinburg_family[@]}"
add_family "Kazan_Family_Russia" "${kazan_family[@]}"
add_family "NizhnyNovgorodCity_Family_Russia" "${nizhny_novgorod_city_family[@]}"
add_family "ChelyabinskCity_Family_Russia" "${chelyabinsk_city_family[@]}"
add_family "SamaraCity_Family_Russia" "${samara_city_family[@]}"
add_family "OmskCity_Family_Russia" "${omsk_city_family[@]}"
add_family "RostovOnDon_Family_Russia" "${rostov_on_don_family[@]}"
add_family "Ufa_Family_Russia" "${ufa_family[@]}"
add_family "KrasnoyarskCity_Family_Russia" "${krasnoyarsk_city_family[@]}"
add_family "VoronezhCity_Family_Russia" "${voronezh_city_family[@]}"
add_family "PermCity_Family_Russia" "${perm_city_family[@]}"
add_family "VolgogradCity_Family_Russia" "${volgograd_city_family[@]}"
add_family "KrasnodarCity_Family_Russia" "${krasnodar_city_family[@]}"
add_family "SaratovCity_Family_Russia" "${saratov_city_family[@]}"
add_family "TyumenCity_Family_Russia" "${tyumen_city_family[@]}"
add_family "IrkutskCity_Family_Russia" "${irkutsk_city_family[@]}"
add_family "Barnaul_Family_Russia" "${barnaul_family[@]}"
add_family "Vladivostok_Family_Russia" "${vladivostok_family[@]}"
add_family "YaroslavlCity_Family_Russia" "${yaroslavl_city_family[@]}"
add_family "Makhachkala_Family_Russia" "${makhachkala_family[@]}"


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
    "$OUTPUT/Other_Mail_Russia[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-45s %s${NC}\n" \
    "Other_Mail_Russia" "$OTHER_COUNT"


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
