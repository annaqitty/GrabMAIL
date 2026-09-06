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

header() {
    printf "${LIGHTGREEN}${BOLD}LATIN AMERICA EMAIL PROVIDER / ISP FILTER${NC}\n"
    printf "${LIGHTCYAN}Country + ISP + Free Mail + Government + Education + Organization${NC}\n"
}

clear 2>/dev/null || true
header
echo "=========================================================================="
read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    printf "${RED}[!] File not found: %s${NC}\n" "$INPUT"
    exit 1
fi
mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/latin_america_filter_$$"
mkdir -p "$TMP_DIR" || exit 1
trap 'rm -rf "$TMP_DIR"' EXIT INT TERM

EMAILS="$TMP_DIR/emails.txt"

printf "${BLUE}[+] Extracting valid email addresses...${NC}\n"

awk '
{
    line=tolower($0)
    while (match(line, /[A-Za-z0-9_.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+/)) {
        email=substr(line,RSTART,RLENGTH)
        if (email !~ /\.\./ && email !~ /^[-_.%+]/ && email !~ /[-_.%+]@/)
            print email
        line=substr(line,RSTART+RLENGTH)
    }
}
' "$INPUT" | awk '!seen[$0]++' > "$EMAILS"

TOTAL=$(wc -l < "$EMAILS")
printf "${GREEN}[+] Unique emails : %s${NC}\n\n" "$TOTAL"

filter() {
    local name="$1"
    shift
    local tmp="$TMP_DIR/${name}.tmp"
    local count

    : > "$tmp"

    awk -v suffixes="$*" '
    BEGIN { n=split(suffixes,a," ") }
    {
        at=index($0,"@")
        if (!at) next
        d=substr($0,at+1)

        for (i=1;i<=n;i++) {
            s=a[i]
            if (d == s ||
                (length(d) > length(s) &&
                 substr(d,length(d)-length(s),1) == "." &&
                 substr(d,length(d)-length(s)+1) == s)) {
                print
                break
            }
        }
    }' "$EMAILS" | sort -u > "$tmp"

    if [[ -s "$tmp" ]]; then
        count=$(wc -l < "$tmp")
        mv "$tmp" "$OUTPUT/${name}[${count}].txt"
        printf "${GREEN}[OK] %-46s %s${NC}\n" "$name" "$count"
    else
        rm -f "$tmp"
    fi
}

# ==========================================================================
# LATIN AMERICA / CARIBBEAN COUNTRY DOMAINS
# ==========================================================================
echo "${LIGHTCYAN}${BOLD}COUNTRY DOMAINS${NC}"

filter "Argentina_Family_LatinAmerica" ar
filter "Bolivia_Family_LatinAmerica" bo
filter "Brazil_Family_LatinAmerica" br
filter "Chile_Family_LatinAmerica" cl
filter "Colombia_Family_LatinAmerica" co
filter "CostaRica_Family_LatinAmerica" cr
filter "Cuba_Family_LatinAmerica" cu
filter "DominicanRepublic_Family_LatinAmerica" do
filter "Ecuador_Family_LatinAmerica" ec
filter "ElSalvador_Family_LatinAmerica" sv
filter "Guatemala_Family_LatinAmerica" gt
filter "Haiti_Family_LatinAmerica" ht
filter "Honduras_Family_LatinAmerica" hn
filter "Jamaica_Family_LatinAmerica" jm
filter "Mexico_Family_LatinAmerica" mx
filter "Nicaragua_Family_LatinAmerica" ni
filter "Panama_Family_LatinAmerica" pa
filter "Paraguay_Family_LatinAmerica" py
filter "Peru_Family_LatinAmerica" pe
filter "PuertoRico_Family_LatinAmerica" pr
filter "Uruguay_Family_LatinAmerica" uy
filter "Venezuela_Family_LatinAmerica" ve
filter "Guyana_Family_LatinAmerica" gy
filter "Suriname_Family_LatinAmerica" sr
filter "Belize_Family_LatinAmerica" bz
filter "FrenchGuiana_Family_LatinAmerica" gf

# ==========================================================================
# REGIONAL GROUPS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}REGIONAL GROUPS${NC}"

filter "SouthAmerica_Region_LatinAmerica" ar bo br cl co ec gy py pe sr uy ve
filter "CentralAmerica_Region_LatinAmerica" bz cr sv gt hn ni pa
filter "Caribbean_Region_LatinAmerica" cu do ht jm pr
filter "LatinAmerica_Region" lat
filter "LatinAmerica_Domain" lat

# ==========================================================================
# GOVERNMENT / PUBLIC SECTOR
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}GOVERNMENT / PUBLIC SECTOR${NC}"

filter "Argentina_Government_LatinAmerica" gov.ar
filter "Bolivia_Government_LatinAmerica" gob.bo
filter "Brazil_Government_LatinAmerica" gov.br
filter "Chile_Government_LatinAmerica" gob.cl
filter "Colombia_Government_LatinAmerica" gov.co
filter "CostaRica_Government_LatinAmerica" go.cr
filter "Cuba_Government_LatinAmerica" gob.cu
filter "DominicanRepublic_Government_LatinAmerica" gob.do
filter "Ecuador_Government_LatinAmerica" gob.ec
filter "ElSalvador_Government_LatinAmerica" gob.sv
filter "Guatemala_Government_LatinAmerica" gob.gt
filter "Haiti_Government_LatinAmerica" gouv.ht
filter "Honduras_Government_LatinAmerica" gob.hn
filter "Jamaica_Government_LatinAmerica" gov.jm
filter "Mexico_Government_LatinAmerica" gob.mx
filter "Nicaragua_Government_LatinAmerica" gob.ni
filter "Panama_Government_LatinAmerica" gob.pa
filter "Paraguay_Government_LatinAmerica" gov.py
filter "Peru_Government_LatinAmerica" gob.pe
filter "PuertoRico_Government_LatinAmerica" pr.gov
filter "Uruguay_Government_LatinAmerica" gub.uy
filter "Venezuela_Government_LatinAmerica" gob.ve
filter "Guyana_Government_LatinAmerica" gov.gy
filter "Suriname_Government_LatinAmerica" gov.sr
filter "Belize_Government_LatinAmerica" gov.bz

# ==========================================================================
# EDUCATION
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}EDUCATION${NC}"

filter "Argentina_Education_LatinAmerica" edu.ar
filter "Bolivia_Education_LatinAmerica" edu.bo
filter "Brazil_Education_LatinAmerica" edu.br
filter "Chile_Education_LatinAmerica" edu.cl
filter "Colombia_Education_LatinAmerica" edu.co
filter "CostaRica_Education_LatinAmerica" ac.cr
filter "Cuba_Education_LatinAmerica" edu.cu
filter "DominicanRepublic_Education_LatinAmerica" edu.do
filter "Ecuador_Education_LatinAmerica" edu.ec
filter "ElSalvador_Education_LatinAmerica" edu.sv
filter "Guatemala_Education_LatinAmerica" edu.gt
filter "Haiti_Education_LatinAmerica" edu.ht
filter "Honduras_Education_LatinAmerica" edu.hn
filter "Jamaica_Education_LatinAmerica" edu.jm
filter "Mexico_Education_LatinAmerica" edu.mx
filter "Nicaragua_Education_LatinAmerica" edu.ni
filter "Panama_Education_LatinAmerica" ac.pa edu.pa
filter "Paraguay_Education_LatinAmerica" edu.py
filter "Peru_Education_LatinAmerica" edu.pe
filter "PuertoRico_Education_LatinAmerica" upr.edu
filter "Uruguay_Education_LatinAmerica" edu.uy
filter "Venezuela_Education_LatinAmerica" edu.ve
filter "Guyana_Education_LatinAmerica" edu.gy
filter "Suriname_Education_LatinAmerica" edu.sr

# ==========================================================================
# ORGANIZATIONS / NONPROFIT
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}ORGANIZATION / NONPROFIT${NC}"

filter "Argentina_Organization" org.ar
filter "Bolivia_Organization" org.bo
filter "Brazil_Organization" org.br
filter "Chile_Organization" org.cl
filter "Colombia_Organization" org.co
filter "CostaRica_Organization" or.cr
filter "Ecuador_Organization" org.ec
filter "Mexico_Organization" org.mx
filter "Peru_Organization" org.pe
filter "Uruguay_Organization" org.uy
filter "Venezuela_Organization" org.ve
filter "Panama_Organization" org.pa
filter "Paraguay_Organization" org.py
filter "Guatemala_Organization" org.gt

# ==========================================================================
# MAJOR GLOBAL MAIL PROVIDERS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}MAJOR MAIL PROVIDERS${NC}"

filter "Google_Family" gmail.com googlemail.com
filter "Microsoft_Family" outlook.com hotmail.com live.com msn.com
filter "Yahoo_Family" yahoo.com yahoo.com.ar yahoo.com.br yahoo.com.mx yahoo.com.co yahoo.com.pe ymail.com rocketmail.com
filter "Apple_Family" icloud.com me.com mac.com
filter "AOL_Family" aol.com
filter "Proton_Family" proton.me protonmail.com
filter "Tuta_Family" tuta.com tutanota.com
filter "GMX_Family" gmx.com gmx.de gmx.at gmx.ch
filter "Mailcom_Family" mail.com email.com
filter "Yandex_Family" yandex.com yandex.ru
filter "Zoho_Family" zoho.com zohomail.com

# ==========================================================================
# LATIN AMERICAN / REGIONAL ISP & MAIL PROVIDERS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}LATIN AMERICAN ISP / MAIL PROVIDERS${NC}"

# Argentina
filter "Argentina_Providers" fibertel.com.ar personal.com.ar speedy.com.ar arnet.com.ar ciudad.com.ar yahoo.com.ar

# Brazil
filter "Brazil_Providers" uol.com.br bol.com.br terra.com.br ig.com.br oi.com.br globo.com globomail.com r7.com zipmail.com.br

# Chile
filter "Chile_Providers" entel.cl vtr.net movistar.cl mi.cl gmail.com

# Colombia
filter "Colombia_Providers" une.net.co etb.net.co claro.com.co tigo.com.co movistar.com.co

# Mexico
filter "Mexico_Providers" prodigy.net.mx telmexmail.com infinitum.com.mx axtel.net izzi.mx totalplay.com.mx megacable.com.mx

# Peru
filter "Peru_Providers" speedy.com.pe terra.com.pe movistar.com.pe claro.com.pe

# Ecuador
filter "Ecuador_Providers" cnt.gob.ec puntonet.ec interactive.net.ec

# Venezuela
filter "Venezuela_Providers" cantv.net movilnet.com.ve netuno.net

# Central America
filter "CentralAmerica_Providers" cablecolor.hn tigo.com.gt tigo.com.hn tigo.com.sv cabletica.net kolbi.cr

# Caribbean
filter "Caribbean_Providers" codetel.net.do claro.com.do orange.net.do windstream.net

# ==========================================================================
# COUNTRY-SPECIFIC SECOND-LEVEL DOMAIN GROUPS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}COUNTRY DOMAIN GROUPS${NC}"

filter "Argentina_Domains" com.ar net.ar org.ar gov.ar edu.ar mil.ar
filter "Bolivia_Domains" com.bo net.bo org.bo gob.bo edu.bo
filter "Brazil_Domains" com.br net.br org.br gov.br edu.br mil.br
filter "Chile_Domains" cl com.cl net.cl org.cl gob.cl gov.cl edu.cl
filter "Colombia_Domains" com.co net.co org.co gov.co edu.co
filter "CostaRica_Domains" co.cr or.cr ac.cr go.cr
filter "DominicanRepublic_Domains" com.do net.do org.do gov.do edu.do
filter "Ecuador_Domains" com.ec net.ec org.ec gob.ec edu.ec
filter "Guatemala_Domains" com.gt net.gt org.gt gob.gt edu.gt
filter "Honduras_Domains" com.hn net.hn org.hn gob.hn edu.hn
filter "Mexico_Domains" com.mx net.mx org.mx gob.mx edu.mx
filter "Nicaragua_Domains" com.ni net.ni org.ni gob.ni edu.ni
filter "Panama_Domains" com.pa net.pa org.pa gob.pa edu.pa
filter "Paraguay_Domains" com.py net.py org.py gov.py edu.py
filter "Peru_Domains" com.pe net.pe org.pe gob.pe edu.pe
filter "Uruguay_Domains" com.uy net.uy org.uy gub.uy edu.uy
filter "Venezuela_Domains" com.ve net.ve org.ve gob.ve edu.ve

# ==========================================================================
# OTHER
# ==========================================================================
CLASSIFIED="$TMP_DIR/classified.txt"
: > "$CLASSIFIED"

for f in "$OUTPUT"/*.txt; do
    [[ -f "$f" ]] && cat "$f" >> "$CLASSIFIED"
done

sort -u "$CLASSIFIED" -o "$CLASSIFIED"

OTHER="$TMP_DIR/other.txt"
awk 'NR==FNR { seen[$0]=1; next } !seen[$0]' "$CLASSIFIED" "$EMAILS" |
    sort -u > "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")
mv "$OTHER" "$OUTPUT/Other_LatinAmerica[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-46s %s${NC}\n" "Other_LatinAmerica" "$OTHER_COUNT"

echo
echo "=========================================================================="
printf "${LIGHTGREEN}${BOLD}COMPLETE${NC}\n"
echo "=========================================================================="
printf "Input file   : %s\n" "$INPUT"
printf "Total emails : %s\n" "$TOTAL"
printf "Output dir   : %s\n" "$OUTPUT"
echo
printf "${LIGHTCYAN}Generated files:${NC}\n"
find "$OUTPUT" -maxdepth 1 -type f -printf "  %f\n" 2>/dev/null | sort
echo
printf "${GREEN}${BOLD}Done.${NC}\n"
