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
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'
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
printf "${LIGHTCYAN}${BOLD}Domain Classifier China${NC}\n"
printf "Region : China\n"
printf "Date   : 01 September 2026\n"
echo "__________________________________________________________________________________"
echo ""


# ============================================================
# INPUT
# ============================================================

read -rp "[+] Input domain file : " INPUT
read -rp "[+] Output dir        : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"


# ============================================================
# TEMP
# ============================================================

TMP_DIR="${TMPDIR:-/tmp}/china_domain_filter_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# CHINA MAIL PROVIDERS
# ============================================================

qq_family=(
    qq.com
    foxmail.com
)

netease_family=(
    163.com
    126.com
    yeah.net
    188.com
)

sina_family=(
    sina.com
    sina.cn
    sina.com.cn
)

sohu_family=(
    sohu.com
)

aliyun_family=(
    aliyun.com
    alibaba.com
    alibaba-inc.com
)

tom_family=(
    tom.com
)

139_family=(
    139.com
)

189_family=(
    189.cn
)

wo_family=(
    wo.cn
    wo.com.cn
)

21cn_family=(
    21cn.com
)

chinaren_family=(
    chinaren.com
)

mailchina_family=(
    mail.china.com
)


# ============================================================
# CHINA TELECOM / ISP
# ============================================================

china_mobile_family=(
    chinamobile.com
    cmcc
    139.com
)

china_telecom_family=(
    chinatelecom.cn
    chinatelecom.com.cn
    189.cn
)

china_unicom_family=(
    chinaunicom.cn
    chinaunicom.com
    10010.com
    wo.cn
)

cnnic_family=(
    cnnic.cn
)

china_net_family=(
    chinanet
)


# ============================================================
# CHINA TLD
# ============================================================

cn_family=(
    .cn
)

com_cn_family=(
    .com.cn
)

net_cn_family=(
    .net.cn
)

org_cn_family=(
    .org.cn
)

gov_cn_family=(
    .gov.cn
)

edu_cn_family=(
    .edu.cn
)

ac_cn_family=(
    .ac.cn
)

mil_cn_family=(
    .mil.cn
)

中国_family=(
    中国
)

公司_family=(
    公司
)

网络_family=(
    网络
)


# ============================================================
# GENERAL INTERNATIONAL PROVIDERS
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
    yahoo.cn
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
# REGISTER CHINA MAIL PROVIDERS
# ============================================================

add_family "QQ_Family_China" "${qq_family[@]}"
add_family "NetEase_Family_China" "${netease_family[@]}"
add_family "Sina_Family_China" "${sina_family[@]}"
add_family "Sohu_Family_China" "${sohu_family[@]}"
add_family "Alibaba_Family_China" "${aliyun_family[@]}"
add_family "TOM_Family_China" "${tom_family[@]}"
add_family "139_Family_China" "${139_family[@]}"
add_family "189_Family_China" "${189_family[@]}"
add_family "ChinaUnicomMail_Family_China" "${wo_family[@]}"
add_family "21CN_Family_China" "${21cn_family[@]}"
add_family "ChinaRen_Family_China" "${chinaren_family[@]}"
add_family "ChinaMail_Family_China" "${mailchina_family[@]}"


# ============================================================
# REGISTER ISP FAMILIES
# ============================================================

add_family "ChinaMobile_Family_China" "${china_mobile_family[@]}"
add_family "ChinaTelecom_Family_China" "${china_telecom_family[@]}"
add_family "ChinaUnicom_Family_China" "${china_unicom_family[@]}"
add_family "CNNIC_Family_China" "${cnnic_family[@]}"
add_family "ChinaNet_Family_China" "${china_net_family[@]}"


# ============================================================
# REGISTER CHINA TLD FAMILIES
# ============================================================

add_family "CN_Domain_Family_China" "${cn_family[@]}"
add_family "COM_CN_Family_China" "${com_cn_family[@]}"
add_family "NET_CN_Family_China" "${net_cn_family[@]}"
add_family "ORG_CN_Family_China" "${org_cn_family[@]}"
add_family "GOV_CN_Family_China" "${gov_cn_family[@]}"
add_family "EDU_CN_Family_China" "${edu_cn_family[@]}"
add_family "AC_CN_Family_China" "${ac_cn_family[@]}"
add_family "MIL_CN_Family_China" "${mil_cn_family[@]}"
add_family "China_IDN_Family_China" "${中国_family[@]}"
add_family "Company_IDN_Family_China" "${公司_family[@]}"
add_family "Network_IDN_Family_China" "${网络_family[@]}"


# ============================================================
# REGISTER INTERNATIONAL PROVIDERS
# ============================================================

add_family "Microsoft_Family_China" "${microsoft_family[@]}"
add_family "Google_Family_China" "${google_family[@]}"
add_family "Yahoo_Family_China" "${yahoo_family[@]}"
add_family "Apple_Family_China" "${apple_family[@]}"
add_family "Proton_Family_China" "${proton_family[@]}"


# ============================================================
# PREPARE OUTPUT
# ============================================================

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
# CLEAN / UNIQUE DOMAINS
# ============================================================

DOMAINS="$TMP_DIR/domains.txt"

printf "${BLUE}[+] Reading domains...${NC}\n"

sed '
    s/\r//g
    s/^[[:space:]]*//
    s/[[:space:]]*$//
' "$INPUT" |
tr '[:upper:]' '[:lower:]' |
sed '
    s#^[a-zA-Z][a-zA-Z0-9+.-]*://##
    s#/.*$##
    s/:[0-9][0-9]*$//
' |
awk '
    NF > 0 &&
    $0 !~ /@/ &&
    $0 ~ /^[a-z0-9\u0080-\uFFFF.-]+$/
' |
awk '!seen[$0]++' > "$DOMAINS"

TOTAL=$(wc -l < "$DOMAINS")

printf "${GREEN}[+] Unique domains : %s${NC}\n" "$TOTAL"
echo ""


# ============================================================
# CLASSIFICATION
# ============================================================

printf "${BLUE}[+] Classifying domains...${NC}\n"

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
    "$OUTPUT/Other_Domain_China[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-40s %s${NC}\n" \
    "Other_Domain_China" "$OTHER_COUNT"


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
    -printf "  %f\n" |
sort

echo ""
echo "__________________________________________________________________________________"

printf "${GREEN}${BOLD}Done.${NC}\n"
