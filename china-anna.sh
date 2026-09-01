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
printf "${LIGHTCYAN}${BOLD}GrabMAIL CHINA${NC}\n"
printf "Coded By : AnnaQitty ( chua )\n"
printf "Region   : China / PRC\n"
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

TMP_DIR="${TMPDIR:-/tmp}/china_mail_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# MAIL PROVIDER FAMILIES
# ============================================================

qq_family=(
    qq
    qqmail
    vip.qq
)

netease_family=(
    163
    126
    yeah
    vip.163
    188
)

sina_family=(
    sina
    sina.cn
    sina.com
)

sohu_family=(
    sohu
)

foxmail_family=(
    foxmail
)

aliyun_family=(
    aliyun
    aliyunmail
)

tom_family=(
    tom
    tom.com
)

21cn_family=(
    21cn
)

china_mobile_family=(
    139
    10086
    cmcc
)

china_telecom_family=(
    189
    189.cn
    chinatelecom
)

china_unicom_family=(
    wo
    wo.cn
    chinaunicom
)

yeah_family=(
    yeah
)

mail_163_family=(
    163
)

mail_126_family=(
    126
)


# ============================================================
# INTERNATIONAL PROVIDERS COMMONLY FOUND IN CHINA
# ============================================================

microsoft_family=(
    hotmail
    live
    outlook
    msn
    windowslive
)

google_family=(
    gmail
    googlemail
)

yahoo_family=(
    yahoo
    ymail
)

apple_family=(
    icloud
    me
    mac
)

proton_family=(
    proton
    protonmail
)

aol_family=(
    aol
)


# ============================================================
# CHINA DOMAIN CATEGORIES
# ============================================================

cn_family=(
    cn
)

com_cn_family=(
    com.cn
)

net_cn_family=(
    net.cn
)

org_cn_family=(
    org.cn
)

gov_cn_family=(
    gov.cn
)

edu_cn_family=(
    edu.cn
)

mil_cn_family=(
    mil.cn
)

ac_cn_family=(
    ac.cn
)

中国_family=(
    xn--fiqs8s
)

公司_family=(
    xn--55qx5d
)

网络_family=(
    xn--io0a7i
)


# ============================================================
# CHINESE ORGANIZATION CATEGORIES
# ============================================================

education_family=(
    edu
    university
    college
    school
)

government_family=(
    gov
    government
)

organization_family=(
    org
)


# ============================================================
# PROVINCE / REGION LABELS
#
# These are domain-name keywords only.
# They are NOT geographic proof.
# ============================================================

beijing_family=(
    beijing
    pek
)

shanghai_family=(
    shanghai
    sh
)

tianjin_family=(
    tianjin
    tj
)

chongqing_family=(
    chongqing
    cq
)

hebei_family=(
    hebei
    hb
)

shanxi_family=(
    shanxi
)

liaoning_family=(
    liaoning
    ln
)

jilin_family=(
    jilin
)

heilongjiang_family=(
    heilongjiang
    hl
)

jiangsu_family=(
    jiangsu
    js
)

zhejiang_family=(
    zhejiang
    zj
)

anhui_family=(
    anhui
    ah
)

fujian_family=(
    fujian
    fj
)

jiangxi_family=(
    jiangxi
    jx
)

shandong_family=(
    shandong
    sd
)

henan_family=(
    henan
)

hubei_family=(
    hubei
)

hunan_family=(
    hunan
)

guangdong_family=(
    guangdong
    gd
)

guangxi_family=(
    guangxi
)

hainan_family=(
    hainan
)

sichuan_family=(
    sichuan
    sc
)

guizhou_family=(
    guizhou
)

yunnan_family=(
    yunnan
)

tibet_family=(
    tibet
    xizang
)

shaanxi_family=(
    shaanxi
)

gansu_family=(
    gansu
)

qinghai_family=(
    qinghai
)

ningxia_family=(
    ningxia
)

xinjiang_family=(
    xinjiang
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
# REGISTER CHINESE MAIL FAMILIES
# ============================================================

add_family "QQ_Family_CHINA" "${qq_family[@]}"
add_family "NetEase_Family_CHINA" "${netease_family[@]}"
add_family "Sina_Family_CHINA" "${sina_family[@]}"
add_family "Sohu_Family_CHINA" "${sohu_family[@]}"
add_family "Foxmail_Family_CHINA" "${foxmail_family[@]}"
add_family "Aliyun_Family_CHINA" "${aliyun_family[@]}"
add_family "TOM_Family_CHINA" "${tom_family[@]}"
add_family "21CN_Family_CHINA" "${21cn_family[@]}"
add_family "ChinaMobile_Family_CHINA" "${china_mobile_family[@]}"
add_family "ChinaTelecom_Family_CHINA" "${china_telecom_family[@]}"
add_family "ChinaUnicom_Family_CHINA" "${china_unicom_family[@]}"

add_family "Yeah_Family_CHINA" "${yeah_family[@]}"
add_family "163_Family_CHINA" "${mail_163_family[@]}"
add_family "126_Family_CHINA" "${mail_126_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL MAIL FAMILIES
# ============================================================

add_family "Microsoft_Family_CHINA" "${microsoft_family[@]}"
add_family "Google_Family_CHINA" "${google_family[@]}"
add_family "Yahoo_Family_CHINA" "${yahoo_family[@]}"
add_family "Apple_Family_CHINA" "${apple_family[@]}"
add_family "Proton_Family_CHINA" "${proton_family[@]}"
add_family "AOL_Family_CHINA" "${aol_family[@]}"


# ============================================================
# REGISTER CHINA TLD FAMILIES
# ============================================================

add_family "CN_Domain_Family_CHINA" "${cn_family[@]}"
add_family "COM_CN_Domain_Family_CHINA" "${com_cn_family[@]}"
add_family "NET_CN_Domain_Family_CHINA" "${net_cn_family[@]}"
add_family "ORG_CN_Domain_Family_CHINA" "${org_cn_family[@]}"
add_family "GOV_CN_Domain_Family_CHINA" "${gov_cn_family[@]}"
add_family "EDU_CN_Domain_Family_CHINA" "${edu_cn_family[@]}"
add_family "MIL_CN_Domain_Family_CHINA" "${mil_cn_family[@]}"
add_family "AC_CN_Domain_Family_CHINA" "${ac_cn_family[@]}"

add_family "Chinese_IDN_Family_CHINA" "${中国_family[@]}"
add_family "Company_IDN_Family_CHINA" "${公司_family[@]}"
add_family "Network_IDN_Family_CHINA" "${网络_family[@]}"


# ============================================================
# REGISTER ORGANIZATION CATEGORIES
# ============================================================

add_family "Education_Family_CHINA" "${education_family[@]}"
add_family "Government_Family_CHINA" "${government_family[@]}"
add_family "Organization_Family_CHINA" "${organization_family[@]}"


# ============================================================
# REGISTER PROVINCES / REGIONS
# ============================================================

add_family "Beijing_Family_CHINA" "${beijing_family[@]}"
add_family "Shanghai_Family_CHINA" "${shanghai_family[@]}"
add_family "Tianjin_Family_CHINA" "${tianjin_family[@]}"
add_family "Chongqing_Family_CHINA" "${chongqing_family[@]}"
add_family "Hebei_Family_CHINA" "${hebei_family[@]}"
add_family "Shanxi_Family_CHINA" "${shanxi_family[@]}"
add_family "Liaoning_Family_CHINA" "${liaoning_family[@]}"
add_family "Jilin_Family_CHINA" "${jilin_family[@]}"
add_family "Heilongjiang_Family_CHINA" "${heilongjiang_family[@]}"
add_family "Jiangsu_Family_CHINA" "${jiangsu_family[@]}"
add_family "Zhejiang_Family_CHINA" "${zhejiang_family[@]}"
add_family "Anhui_Family_CHINA" "${anhui_family[@]}"
add_family "Fujian_Family_CHINA" "${fujian_family[@]}"
add_family "Jiangxi_Family_CHINA" "${jiangxi_family[@]}"
add_family "Shandong_Family_CHINA" "${shandong_family[@]}"
add_family "Henan_Family_CHINA" "${henan_family[@]}"
add_family "Hubei_Family_CHINA" "${hubei_family[@]}"
add_family "Hunan_Family_CHINA" "${hunan_family[@]}"
add_family "Guangdong_Family_CHINA" "${guangdong_family[@]}"
add_family "Guangxi_Family_CHINA" "${guangxi_family[@]}"
add_family "Hainan_Family_CHINA" "${hainan_family[@]}"
add_family "Sichuan_Family_CHINA" "${sichuan_family[@]}"
add_family "Guizhou_Family_CHINA" "${guizhou_family[@]}"
add_family "Yunnan_Family_CHINA" "${yunnan_family[@]}"
add_family "Tibet_Family_CHINA" "${tibet_family[@]}"
add_family "Shaanxi_Family_CHINA" "${shaanxi_family[@]}"
add_family "Gansu_Family_CHINA" "${gansu_family[@]}"
add_family "Qinghai_Family_CHINA" "${qinghai_family[@]}"
add_family "Ningxia_Family_CHINA" "${ningxia_family[@]}"
add_family "Xinjiang_Family_CHINA" "${xinjiang_family[@]}"


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
    "$OUTPUT/Other_Mail_CHINA[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-35s %s${NC}\n" \
    "Other_Mail_CHINA" "$OTHER_COUNT"


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
