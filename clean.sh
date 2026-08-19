#!/usr/bin/env bash

# ============================================================
# GrabMAIL
# Optimized single-pass email-domain classifier
# ============================================================

set -u

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

header() {
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
# INPUT CHECK
# ============================================================

clear
header

echo
echo "__________________________________________________________________________________"
echo
echo "GrabMAIL"
echo "Coded By : AnnaQitty ( chua )"
echo "Date     : 28 July 2010"
echo "__________________________________________________________________________________"
echo

echo "List of files in this directory:"
echo

ls -lah

echo
echo "__________________________________________________________________________________"
echo

# ============================================================
# ASK INPUT FILE
# ============================================================

printf "[+] Email List : ${LIGHTCYAN}"
read -r emaillist
printf "${NC}"

if [[ ! -f "$emaillist" ]]; then
    echo -e "${RED}[ERR]${NC} File does not exist: $emaillist"
    exit 1
fi

# ============================================================
# ASK OUTPUT DIRECTORY
# ============================================================

printf "[+] Result will save in : ${LIGHTCYAN}"
read -r save
printf "${NC}"

if [[ -z "$save" ]]; then
    echo -e "${RED}[ERR]${NC} Output directory cannot be empty."
    exit 1
fi

# ============================================================
# CREATE OUTPUT DIRECTORY
# ============================================================

echo
printf "[+] Making directory : "

if [[ ! -d "$save" ]]; then
    if mkdir -p -- "$save"; then
        echo -e "${GREEN}[OK]${NC}"
    else
        echo -e "${RED}[ERR]${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}[EXISTS]${NC}"
fi

# ============================================================
# TEMP FILE
# ============================================================

tmp_file=$(mktemp)

cleanup() {
    rm -f -- "$tmp_file"
}

trap cleanup EXIT

# ============================================================
# CLEAN EMAIL LIST
# ============================================================

echo
echo "[+] Cleaning email list..."
echo "[+] Extracting valid email addresses..."
echo "[+] Lowercasing..."
echo "[+] Removing duplicates..."
echo

grep -Eioh \
    '[[:alnum:]_.-]+@[[:alnum:]_.-]+\.[[:alpha:]]{2,}' \
    "$emaillist" |
    tr '[:upper:]' '[:lower:]' |
    LC_ALL=C sort -u > "$tmp_file"

if [[ ! -s "$tmp_file" ]]; then
    echo -e "${RED}[ERR]${NC} No valid email addresses found."
    exit 1
fi

mv -- "$tmp_file" "$emaillist"

counter=$(wc -l < "$emaillist")

echo -e "[+] Total unique emails : ${LIGHTGREEN}${counter}${NC}"
echo

# ============================================================
# PROVIDER LIST
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
    btinternet
    bt
    rocketmail
    sky
)

google_family=(
    gmail
    google
    googlemail
)

aol_family=(
    aol
)

mail_family=(
    mail
    gmx
)

sbcglobal_family=(
    sbcglobal
)

bellsouth_family=(
    bellsouth
)

comcast_family=(
    comcast
)

juno_family=(
    juno
)

apple_family=(
    mac
    apple
    icloud
)

qq_family=(
    qq
)

# ============================================================
# CREATE OUTPUT FILES
# ============================================================

output_files=(
    microsoft_family.txt
    yahoo_family.txt
    google_family.txt
    aol_family.txt
    mail_family.txt
    sbcglobal_family.txt
    bellsouth_family.txt
    comcast_family.txt
    juno_family.txt
    apple_family.txt
    qq_family.txt
    other_mail.txt
)

for file in "${output_files[@]}"; do
    : > "$save/$file"
done

# ============================================================
# SINGLE-PASS CLASSIFICATION
# ============================================================

echo "[+] Classifying email domains..."
echo

awk -v out="$save" '
BEGIN {
    FS = "@"
}

{
    email  = tolower($0)
    domain = tolower($2)

    file = "other_mail.txt"

    if (domain ~ /^(hotmail|live|outlook|msn|windowslive)\./)
        file = "microsoft_family.txt"

    else if (domain ~ /^(yahoo|ymail|btinternet|bt|rocketmail|sky)\./)
        file = "yahoo_family.txt"

    else if (domain ~ /^(gmail|google|googlemail)\./)
        file = "google_family.txt"

    else if (domain ~ /^aol\./)
        file = "aol_family.txt"

    else if (domain ~ /^(mail|gmx)\./)
        file = "mail_family.txt"

    else if (domain ~ /^sbcglobal\./)
        file = "sbcglobal_family.txt"

    else if (domain ~ /^bellsouth\./)
        file = "bellsouth_family.txt"

    else if (domain ~ /^comcast\./)
        file = "comcast_family.txt"

    else if (domain ~ /^juno\./)
        file = "juno_family.txt"

    else if (domain ~ /^(mac|apple|icloud)\./)
        file = "apple_family.txt"

    else if (domain ~ /^qq\./)
        file = "qq_family.txt"

    print email >> (out "/" file)
}
' "$emaillist"

# ============================================================
# RESULTS
# ============================================================

echo "__________________________________________________________________________________"
echo
echo "Results:"
echo

print_count() {
    local name="$1"
    local file="$2"

    local count
    count=$(wc -l < "$save/$file")

    printf "  %-22s : ${LIGHTGREEN}%s${NC}\n" "$name" "$count"
}

print_count "Microsoft Family" "microsoft_family.txt"
print_count "Yahoo Family"     "yahoo_family.txt"
print_count "Google Family"    "google_family.txt"
print_count "AOL Family"       "aol_family.txt"
print_count "Mail Family"      "mail_family.txt"
print_count "SBCGlobal Family" "sbcglobal_family.txt"
print_count "BellSouth Family" "bellsouth_family.txt"
print_count "Comcast Family"   "comcast_family.txt"
print_count "Juno Family"      "juno_family.txt"
print_count "Apple Family"     "apple_family.txt"
print_count "QQ Family"        "qq_family.txt"
print_count "Other Mail"       "other_mail.txt"

echo
echo "__________________________________________________________________________________"
echo
echo -e "${GREEN}[OK] Processing completed.${NC}"
echo
echo "Output directory:"
echo "$save"
echo
