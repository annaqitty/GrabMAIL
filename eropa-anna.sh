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
    printf "${LIGHTGREEN}${BOLD}EUROPE EMAIL PROVIDER / ISP FILTER${NC}\n"
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

TMP_DIR="${TMPDIR:-/tmp}/europe_filter_$$"
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
# EUROPE COUNTRY DOMAINS
# ==========================================================================
echo "${LIGHTCYAN}${BOLD}COUNTRY DOMAINS${NC}"

filter "UnitedKingdom_Family_Europe" uk co.uk org.uk me.uk
filter "Germany_Family_Europe" de
filter "France_Family_Europe" fr
filter "Italy_Family_Europe" it
filter "Spain_Family_Europe" es
filter "Netherlands_Family_Europe" nl
filter "Poland_Family_Europe" pl
filter "Switzerland_Family_Europe" ch
filter "Austria_Family_Europe" at
filter "Belgium_Family_Europe" be
filter "Sweden_Family_Europe" se
filter "Norway_Family_Europe" no
filter "Denmark_Family_Europe" dk
filter "Finland_Family_Europe" fi
filter "Ireland_Family_Europe" ie
filter "Portugal_Family_Europe" pt
filter "Greece_Family_Europe" gr
filter "Czechia_Family_Europe" cz
filter "Romania_Family_Europe" ro
filter "Hungary_Family_Europe" hu
filter "Slovakia_Family_Europe" sk
filter "Ukraine_Family_Europe" ua
filter "Estonia_Family_Europe" ee
filter "Latvia_Family_Europe" lv
filter "Lithuania_Family_Europe" lt
filter "Croatia_Family_Europe" hr
filter "Bulgaria_Family_Europe" bg
filter "Slovenia_Family_Europe" si
filter "Serbia_Family_Europe" rs
filter "Iceland_Family_Europe" is
filter "Luxembourg_Family_Europe" lu

# ==========================================================================
# REGIONAL GROUPS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}REGIONAL GROUPS${NC}"

filter "EuropeanUnion_Domain" eu
filter "WesternEurope_Region" fr de nl be lu ie uk
filter "SouthernEurope_Region" es it pt gr
filter "NorthernEurope_Region" se no dk fi is
filter "CentralEurope_Region" at ch cz hu pl sk
filter "EasternEurope_Region" ro bg hr si rs ua ee lv lt

# ==========================================================================
# GOVERNMENT / PUBLIC SECTOR
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}GOVERNMENT / PUBLIC SECTOR${NC}"

filter "UnitedKingdom_Government_Europe" gov.uk
filter "Germany_Government_Europe" bund.de
filter "France_Government_Europe" gouv.fr
filter "Italy_Government_Europe" gov.it
filter "Spain_Government_Europe" gob.es
filter "Netherlands_Government_Europe" gov.nl
filter "Poland_Government_Europe" gov.pl
filter "Switzerland_Government_Europe" admin.ch
filter "Austria_Government_Europe" gv.at
filter "Belgium_Government_Europe" fgov.be
filter "Ireland_Government_Europe" gov.ie
filter "Portugal_Government_Europe" gov.pt
filter "Greece_Government_Europe" gov.gr
filter "Czechia_Government_Europe" gov.cz
filter "Romania_Government_Europe" gov.ro
filter "Hungary_Government_Europe" gov.hu
filter "Ukraine_Government_Europe" gov.ua

# ==========================================================================
# EDUCATION
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}EDUCATION${NC}"

filter "UnitedKingdom_Education_Europe" ac.uk
filter "Germany_Education_Europe" uni-*.de
filter "France_Education_Europe" univ-*.fr
filter "Italy_Education_Europe" edu.it
filter "Spain_Education_Europe" edu.es
filter "Netherlands_Education_Europe" edu.nl
filter "Poland_Education_Europe" edu.pl
filter "Austria_Education_Europe" ac.at
filter "Ireland_Education_Europe" edu.ie
filter "Portugal_Education_Europe" edu.pt
filter "Greece_Education_Europe" edu.gr
filter "Czechia_Education_Europe" edu.cz
filter "Romania_Education_Europe" edu.ro
filter "Hungary_Education_Europe" edu.hu
filter "Ukraine_Education_Europe" edu.ua

# ==========================================================================
# ORGANIZATIONS / NONPROFIT
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}ORGANIZATION / NONPROFIT${NC}"

filter "UnitedKingdom_Organization" org.uk
filter "Germany_Organization" org.de
filter "France_Organization" asso.fr
filter "Italy_Organization" org.it
filter "Spain_Organization" org.es
filter "Poland_Organization" org.pl
filter "Austria_Organization" org.at
filter "Romania_Organization" org.ro
filter "Ukraine_Organization" org.ua

# ==========================================================================
# MAJOR GLOBAL & EUROPEAN MAIL PROVIDERS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}MAJOR MAIL PROVIDERS${NC}"

filter "Google_Family" gmail.com googlemail.com
filter "Microsoft_Family" outlook.com hotmail.com live.com msn.com outlook.de outlook.fr outlook.es outlook.it
filter "Yahoo_Family" yahoo.com yahoo.co.uk yahoo.de yahoo.fr yahoo.es yahoo.it yahoo.gr
filter "Apple_Family" icloud.com me.com mac.com
filter "Proton_Family" proton.me protonmail.com protonmail.ch
filter "Tuta_Family" tuta.com tutanota.com tutanota.de
filter "GMX_Family" gmx.com gmx.de gmx.at gmx.ch gmx.net gmx.fr gmx.es gmx.co.uk
filter "WEBDE_Family" web.de
filter "Mailcom_Family" mail.com email.com

# ==========================================================================
# EUROPEAN ISP & MAIL PROVIDERS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}EUROPEAN ISP / MAIL PROVIDERS${NC}"

# Germany / Austria / Switzerland
filter "DACH_Providers" t-online.de freenet.de arcor.de vodafone.de bluewin.ch a1.net chello.at

# UK & Ireland
filter "UK_Ireland_Providers" btinternet.com virginmedia.com sky.com talktalk.net ntlworld.com eircom.net

# France
filter "France_Providers" orange.fr wanadoo.fr free.fr sfr.fr laposte.net bouyguestelecom.fr club-internet.fr

# Italy
filter "Italy_Providers" libero.it alice.it tin.it virgilio.it tiscali.it fastwebnet.it tim.it

# Spain & Portugal
filter "Iberia_Providers" telefonica.net movistar.es ono.com terra.es meo.pt sapo.pt nos.pt

# Netherlands & Belgium
filter "Benelux_Providers" kpnmail.nl ziggo.nl home.nl hetnet.nl skynet.be telenet.be proximus.be

# Nordics
filter "Nordic_Providers" telia.com online.no steinkjer.no lyse.net mail.dk yahoo.se

# Eastern Europe
filter "EasternEurope_Providers" wp.pl onet.pl o2.pl interia.pl seznam.cz centrum.cz ukr.net i.ua freemail.hu

# ==========================================================================
# COUNTRY-SPECIFIC SECOND-LEVEL DOMAIN GROUPS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}COUNTRY DOMAIN GROUPS${NC}"

filter "UnitedKingdom_Domains" co.uk org.uk me.uk gov.uk ac.uk net.uk
filter "Germany_Domains" de com.de
filter "France_Domains" fr gouv.fr asso.fr tm.fr
filter "Italy_Domains" it gov.it edu.it
filter "Spain_Domains" es com.es org.es gob.es edu.es
filter "Netherlands_Domains" nl co.nl org.nl
filter "Poland_Domains" pl com.pl net.pl org.pl gov.pl edu.pl
filter "Austria_Domains" at co.at or.at gv.at ac.at
filter "Switzerland_Domains" ch com.ch org.ch
filter "Czechia_Domains" cz co.cz org.cz
filter "Romania_Domains" ro com.ro store.ro tm.ro www.ro
filter "Ukraine_Domains" ua com.ua net.ua org.ua gov.ua edu.ua

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
mv "$OTHER" "$OUTPUT/Other_Europe[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-46s %s${NC}\n" "Other_Europe" "$OTHER_COUNT"

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
