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

header() {
    printf "    ${LIGHTGREEN}       ___ ${NC}\n"
    printf "    ${LIGHTGREEN}     o|* *|o  Thailand Domain Classifier ${NC}\n"
    printf "    ${LIGHTGREEN}       |||    Provider / TLD Organizer ${NC}\n"
    printf "    ${LIGHTGREEN}    ___|||___ ${NC}\n"
}


# ============================================================
# START
# ============================================================

clear
header

echo ""
echo "__________________________________________________________________________________"
echo ""

printf "${LIGHTCYAN}${BOLD}Thailand Domain Classifier${NC}\n"
printf "Date : 01 September 2026\n"

echo "__________________________________________________________________________________"
echo ""


# ============================================================
# INPUT
# ============================================================

read -rp "[+] Input domain file : " INPUT
read -rp "[+] Output directory : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

if ! mkdir -p "$OUTPUT"; then
    printf "${RED}[!] Cannot create output directory.${NC}\n"
    exit 1
fi


# ============================================================
# TEMP DIRECTORY
# ============================================================

TMP_DIR="${TMPDIR:-/tmp}/thai_domain_classifier_$$"

mkdir -p "$TMP_DIR" || {
    printf "${RED}[!] Cannot create temporary directory.${NC}\n"
    exit 1
}

trap 'rm -rf "$TMP_DIR"' EXIT INT TERM


# ============================================================
# PROVIDER DATABASE
# ============================================================

declare -A PROVIDER_DOMAINS

PROVIDER_DOMAINS["Gmail"]="gmail.com googlemail.com"

PROVIDER_DOMAINS["Yahoo"]="yahoo.com yahoo.co.th"

PROVIDER_DOMAINS["Microsoft"]="hotmail.com hotmail.co.th outlook.com outlook.co.th live.com live.co.th msn.com"

PROVIDER_DOMAINS["Apple"]="icloud.com me.com mac.com"

PROVIDER_DOMAINS["True"]="trueinternet.co.th truecorp.co.th trueemail.com"

PROVIDER_DOMAINS["AIS"]="ais.co.th aismail.com"

PROVIDER_DOMAINS["DTAC"]="dtac.co.th dtacmail.com"

PROVIDER_DOMAINS["3BB"]="3bb.co.th 3bbmail.com"

PROVIDER_DOMAINS["NT"]="ntplc.co.th nt.com tot.co.th"

PROVIDER_DOMAINS["CAT"]="cat.net.th cattelecom.com"

PROVIDER_DOMAINS["CS_LoxInfo"]="csloxinfo.com csloxinfo.net loxinfo.co.th"

PROVIDER_DOMAINS["Internet_Thailand"]="inet.co.th inet.net.th"

PROVIDER_DOMAINS["KSC"]="ksc.net.th ksc.co.th"

PROVIDER_DOMAINS["Jasmine"]="jasmine.com"

PROVIDER_DOMAINS["Jinet"]="jinet.net.th ji-net.com"

PROVIDER_DOMAINS["UIH"]="uih.co.th"

PROVIDER_DOMAINS["Symphony"]="symphony.net.th sym.co.th"

PROVIDER_DOMAINS["Samart"]="samart.net.th"

PROVIDER_DOMAINS["Buddy_Broadband"]="buddybb.co.th"

PROVIDER_DOMAINS["Thaicom"]="thaicom.net thaicom.net.th"


# ============================================================
# THAILAND TLD DATABASE
# ============================================================

declare -A THAILAND_TLDS

THAILAND_TLDS["Thailand_Commercial"]=".co.th"

THAILAND_TLDS["Thailand_Education"]=".ac.th .edu.th"

THAILAND_TLDS["Thailand_Government"]=".go.th"

THAILAND_TLDS["Thailand_Organization"]=".or.th"

THAILAND_TLDS["Thailand_Network"]=".net.th"

THAILAND_TLDS["Thailand_Individual"]=".in.th"

THAILAND_TLDS["Thailand_Military"]=".mi.th"

THAILAND_TLDS["Thailand_IDN"]=".ไทย"


# ============================================================
# FIXED PROVIDER ORDER
# ============================================================

PROVIDERS=(
    "Gmail"
    "Yahoo"
    "Microsoft"
    "Apple"
    "True"
    "AIS"
    "DTAC"
    "3BB"
    "NT"
    "CAT"
    "CS_LoxInfo"
    "Internet_Thailand"
    "KSC"
    "Jasmine"
    "Jinet"
    "UIH"
    "Symphony"
    "Samart"
    "Buddy_Broadband"
    "Thaicom"
)


# ============================================================
# FIXED TLD ORDER
# ============================================================

TLD_CATEGORIES=(
    "Thailand_Commercial"
    "Thailand_Education"
    "Thailand_Government"
    "Thailand_Organization"
    "Thailand_Network"
    "Thailand_Individual"
    "Thailand_Military"
    "Thailand_IDN"
)


# ============================================================
# INITIALIZE TEMP FILES
# ============================================================

for provider in "${PROVIDERS[@]}"; do
    : > "$TMP_DIR/${provider}.tmp"
done

for category in "${TLD_CATEGORIES[@]}"; do
    : > "$TMP_DIR/${category}.tmp"
done

: > "$TMP_DIR/Other_Domain.tmp"


# ============================================================
# NORMALIZE INPUT
# ============================================================

NORMALIZED="$TMP_DIR/normalized.txt"

printf "${BLUE}[+] Reading domains...${NC}\n"

awk '
{
    domain = tolower($0)

    gsub(/^[[:space:]]+/, "", domain)
    gsub(/[[:space:]]+$/, "", domain)
    gsub(/\r/, "", domain)

    if (domain != "")
        print domain
}
' "$INPUT" |
awk '!seen[$0]++' > "$NORMALIZED"


TOTAL=$(wc -l < "$NORMALIZED")

printf "${GREEN}[+] Unique domains : %s${NC}\n" "$TOTAL"
echo ""


# ============================================================
# CLASSIFICATION
# ============================================================

printf "${BLUE}[+] Classifying domains...${NC}\n"

while IFS= read -r domain; do

    [[ -z "$domain" ]] && continue

    matched=0


    # --------------------------------------------------------
    # PROVIDER
    # --------------------------------------------------------

    for provider in "${PROVIDERS[@]}"; do

        for provider_domain in ${PROVIDER_DOMAINS[$provider]}; do

            if [[ "$domain" == "$provider_domain" ]]; then

                printf '%s\n' "$domain" \
                    >> "$TMP_DIR/${provider}.tmp"

                matched=1
                break 2

            fi

        done

    done


    if (( matched == 1 )); then
        continue
    fi


    # --------------------------------------------------------
    # THAILAND TLD
    # --------------------------------------------------------

    for category in "${TLD_CATEGORIES[@]}"; do

        for suffix in ${THAILAND_TLDS[$category]}; do

            if [[ "$domain" == *"$suffix" ]]; then

                printf '%s\n' "$domain" \
                    >> "$TMP_DIR/${category}.tmp"

                matched=1
                break 2

            fi

        done

    done


    # --------------------------------------------------------
    # OTHER
    # --------------------------------------------------------

    if (( matched == 0 )); then

        printf '%s\n' "$domain" \
            >> "$TMP_DIR/Other_Domain.tmp"

    fi

done < "$NORMALIZED"


# ============================================================
# SAVE PROVIDERS
# ============================================================

echo ""

printf "${LIGHTCYAN}${BOLD}Provider Results${NC}\n"

for provider in "${PROVIDERS[@]}"; do

    file="$TMP_DIR/${provider}.tmp"

    count=$(wc -l < "$file")

    if (( count > 0 )); then

        sort -u "$file" > "$file.sorted"

        mv "$file.sorted" \
            "$OUTPUT/${provider}[${count}].txt"

        printf \
            "${GREEN}[OK] %-25s %s${NC}\n" \
            "$provider" \
            "$count"

    fi

done


# ============================================================
# SAVE THAILAND TLD CATEGORIES
# ============================================================

echo ""

printf "${LIGHTCYAN}${BOLD}Thailand TLD Results${NC}\n"

for category in "${TLD_CATEGORIES[@]}"; do

    file="$TMP_DIR/${category}.tmp"

    count=$(wc -l < "$file")

    if (( count > 0 )); then

        sort -u "$file" > "$file.sorted"

        mv "$file.sorted" \
            "$OUTPUT/${category}[${count}].txt"

        printf \
            "${GREEN}[OK] %-30s %s${NC}\n" \
            "$category" \
            "$count"

    fi

done


# ============================================================
# SAVE OTHER
# ============================================================

OTHER_COUNT=$(wc -l < "$TMP_DIR/Other_Domain.tmp")

sort -u "$TMP_DIR/Other_Domain.tmp" \
    > "$OUTPUT/Other_Domain[${OTHER_COUNT}].txt"

printf \
    "${YELLOW}[OTHER] %-25s %s${NC}\n" \
    "Other_Domain" \
    "$OTHER_COUNT"


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
