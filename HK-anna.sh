#!/usr/bin/env bash

set -u
export LC_ALL=C

BOLD='\e[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
LIGHTGREEN='\033[0;92m'
LIGHTCYAN='\033[0;96m'
NC='\033[0m'

clear

echo "=============================================================="
printf "${LIGHTCYAN}${BOLD}FAST HONG KONG DOMAIN CLASSIFIER${NC}\n"
echo "=============================================================="
echo

read -rp "[+] Input domain file : " INPUT
read -rp "[+] Output dir        : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP="$OUTPUT/.hk_tmp_$$"
mkdir -p "$TMP"

trap 'rm -rf "$TMP"' EXIT INT TERM

# ============================================================
# ONE-PASS AWK CLASSIFIER
# ============================================================

awk -v out="$TMP" '

BEGIN {

    # --------------------------------------------------------
    # HONG KONG MAIL / ISP PROVIDERS
    # --------------------------------------------------------

    add("Netvigator_Family_HongKong",
        "netvigator\\.com$")

    add("HKBN_Family_HongKong",
        "hkbn\\.com\\.hk$|hkbn\\.net$")

    add("HGC_Family_HongKong",
        "hgc\\.com\\.hk$")

    add("PCCW_Family_HongKong",
        "pccw\\.com$|pccw\\.com\\.hk$")

    add("CSL_Family_HongKong",
        "csl\\.com\\.hk$")

    add("SmarTone_Family_HongKong",
        "smartone\\.com$|smartone\\.com\\.hk$")

    add("HKT_Family_HongKong",
        "hkt\\.com$|hkt\\.com\\.hk$")

    add("NowTV_Family_HongKong",
        "now\\.com\\.hk$")

    add("Y5Zone_Family_HongKong",
        "y5zone\\.net$")

    add("YMail_Family_HongKong",
        "ymail\\.com\\.hk$")

    add("HongKongMail_Family_HongKong",
        "hongkongmail\\.com$")

    add("iCable_Family_HongKong",
        "i-cable\\.com$|icable\\.com\\.hk$")

    add("ChinaMobile_Family_HongKong",
        "cmi\\.chinamobile\\.com$")

    add("ChinaMobileHK_Family_HongKong",
        "chinamobilehk\\.com$|chinamobile\\.com\\.hk$")

    add("Whizpa_Family_HongKong",
        "whizpa\\.com$")

    add("WTT_Family_HongKong",
        "wtt\\.com\\.hk$")


    # --------------------------------------------------------
    # INTERNATIONAL MAIL PROVIDERS
    # --------------------------------------------------------

    add("Microsoft_Family_HongKong",
        "hotmail\\.com$|hotmail\\.com\\.hk$|outlook\\.com$|live\\.com$|msn\\.com$")

    add("Google_Family_HongKong",
        "gmail\\.com$|googlemail\\.com$")

    add("Yahoo_Family_HongKong",
        "yahoo\\.com$|yahoo\\.com\\.hk$")

    add("Apple_Family_HongKong",
        "icloud\\.com$|me\\.com$")

    add("Proton_Family_HongKong",
        "proton\\.me$|protonmail\\.com$")


    # --------------------------------------------------------
    # HONG KONG BUSINESS / SPECIAL TLD
    # --------------------------------------------------------

    add("GOV_HK_Family",
        "\\.gov\\.hk$")

    add("EDU_HK_Family",
        "\\.edu\\.hk$")

    add("ORG_HK_Family",
        "\\.org\\.hk$")

    add("NET_HK_Family",
        "\\.net\\.hk$")

    add("COM_HK_Family",
        "\\.com\\.hk$")

    add("IDV_HK_Family",
        "\\.idv\\.hk$")

    add("INC_HK_Family",
        "\\.inc\\.hk$")

    add("HK_Domain_Family",
        "\\.hk$")


    # --------------------------------------------------------
    # IDN DOMAINS
    # --------------------------------------------------------

    add("Company_IDN_HK_Family",
        "公司\\.hk$")

    add("Network_IDN_HK_Family",
        "網絡\\.hk$")

    add("Government_IDN_HK_Family",
        "政府\\.hk$")


    # --------------------------------------------------------
    # OTHER CATEGORIES
    # --------------------------------------------------------

    add("Government_Family_HongKong",
        "^.*\\.gov\\.hk$")

    add("Education_Family_HongKong",
        "^.*\\.edu\\.hk$")

    add("Organization_Family_HongKong",
        "^.*\\.org\\.hk$")

    add("Individual_Family_HongKong",
        "^.*\\.idv\\.hk$")

    add("Business_Family_HongKong",
        "^.*\\.com\\.hk$|^.*\\.inc\\.hk$")

    total_rules = n
}


function add(name, regex) {

    rule_name[++n] = name
    rule_regex[n] = regex
}


{
    # --------------------------------------------------------
    # CLEAN
    # --------------------------------------------------------

    gsub(/\r/, "")
    gsub(/^[ \t]+/, "")
    gsub(/[ \t]+$/, "")

    domain = tolower($0)

    if (domain == "")
        next

    # Domain-only
    if (domain ~ /@/)
        next

    # Remove protocol
    sub(/^https?:\/\//, "", domain)

    # Remove path
    sub(/\/.*$/, "", domain)

    # Remove port
    sub(/:[0-9]+$/, "", domain)

    # Remove trailing dot
    sub(/\.$/, "", domain)

    # --------------------------------------------------------
    # UNIQUE
    # --------------------------------------------------------

    if (seen[domain]++)
        next

    total++

    matched = 0

    # --------------------------------------------------------
    # CLASSIFY
    # --------------------------------------------------------

    for (i = 1; i <= total_rules; i++) {

        if (domain ~ rule_regex[i]) {

            name = rule_name[i]

            print domain >> out "/" name ".tmp"

            count[name]++

            matched = 1

            break
        }
    }

    if (!matched) {

        print domain >> out "/Other_Domain_HongKong.tmp"

        other++
    }
}


END {

    # --------------------------------------------------------
    # SAVE COUNTS
    # --------------------------------------------------------

    for (i = 1; i <= total_rules; i++) {

        name = rule_name[i]

        if (count[name] > 0) {

            print name "|" count[name] >> out "/__results"
        }
    }

    print "TOTAL|" total >> out "/__results"
    print "OTHER|" other >> out "/__results"

    close(out "/__results")
}
' "$INPUT"


# ============================================================
# CREATE FINAL FILES
# ============================================================

if [[ -f "$TMP/__results" ]]; then

    while IFS='|' read -r NAME COUNT; do

        case "$NAME" in

            TOTAL)
                TOTAL="$COUNT"
                ;;

            OTHER)
                OTHER="$COUNT"
                ;;

            *)
                OLD="$TMP/${NAME}.tmp"
                NEW="$OUTPUT/${NAME}[${COUNT}].txt"

                if [[ -f "$OLD" ]]; then
                    mv "$OLD" "$NEW"
                fi
                ;;
        esac

    done < "$TMP/__results"

fi


# ============================================================
# OTHER
# ============================================================

TOTAL="${TOTAL:-0}"
OTHER="${OTHER:-0}"

if [[ -f "$TMP/Other_Domain_HongKong.tmp" ]]; then

    mv "$TMP/Other_Domain_HongKong.tmp" \
       "$OUTPUT/Other_Domain_HongKong[${OTHER}].txt"

fi


# ============================================================
# CLEAN
# ============================================================

rm -f "$TMP/__results"


# ============================================================
# SUMMARY
# ============================================================

echo
echo "=============================================================="
printf "${LIGHTGREEN}${BOLD}COMPLETE${NC}\n"
echo "=============================================================="

printf "Input file    : %s\n" "$INPUT"
printf "Unique domains: %s\n" "$TOTAL"
printf "Other domains : %s\n" "$OTHER"
printf "Output dir    : %s\n" "$OUTPUT"

echo
printf "${LIGHTCYAN}Generated files:${NC}\n"

find "$OUTPUT" \
    -maxdepth 1 \
    -type f \
    -name "*.txt" \
    -printf "  %f\n" |
sort

echo
echo "=============================================================="
printf "${GREEN}Done.${NC}\n"
echo "=============================================================="
