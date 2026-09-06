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
    printf "${LIGHTGREEN}${BOLD}ASIA EMAIL PROVIDER / ISP FILTER${NC}\n"
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

TMP_DIR="${TMPDIR:-/tmp}/asia_provider_filter_$$"
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

# Exact suffix matching. A domain is classified only when it equals a
# suffix or ends with ".suffix". This prevents partial-word false matches.
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
# ASIA COUNTRY / NATIONAL DOMAINS
# ==========================================================================
echo "${LIGHTCYAN}${BOLD}COUNTRY DOMAINS${NC}"

filter "Afghanistan_Family_Asia" af
filter "Armenia_Family_Asia" am
filter "Azerbaijan_Family_Asia" az
filter "Bahrain_Family_Asia" bh
filter "Bangladesh_Family_Asia" bd
filter "Bhutan_Family_Asia" bt
filter "Brunei_Family_Asia" bn
filter "Cambodia_Family_Asia" kh
filter "China_Family_Asia" cn
filter "Cyprus_Family_Asia" cy
filter "Georgia_Family_Asia" ge
filter "India_Family_Asia" in
filter "Indonesia_Family_Asia" id
filter "Iran_Family_Asia" ir
filter "Iraq_Family_Asia" iq
filter "Israel_Family_Asia" il
filter "Japan_Family_Asia" jp
filter "Jordan_Family_Asia" jo
filter "Kazakhstan_Family_Asia" kz
filter "Kuwait_Family_Asia" kw
filter "Kyrgyzstan_Family_Asia" kg
filter "Laos_Family_Asia" la
filter "Lebanon_Family_Asia" lb
filter "Malaysia_Family_Asia" my
filter "Maldives_Family_Asia" mv
filter "Mongolia_Family_Asia" mn
filter "Myanmar_Family_Asia" mm
filter "Nepal_Family_Asia" np
filter "NorthKorea_Family_Asia" kp
filter "Oman_Family_Asia" om
filter "Pakistan_Family_Asia" pk
filter "Palestine_Family_Asia" ps
filter "Philippines_Family_Asia" ph
filter "Qatar_Family_Asia" qa
filter "SaudiArabia_Family_Asia" sa
filter "Singapore_Family_Asia" sg
filter "SouthKorea_Family_Asia" kr
filter "SriLanka_Family_Asia" lk
filter "Syria_Family_Asia" sy
filter "Taiwan_Family_Asia" tw
filter "Tajikistan_Family_Asia" tj
filter "Thailand_Family_Asia" th
filter "TimorLeste_Family_Asia" tl
filter "Turkey_Family_Asia" tr
filter "Turkmenistan_Family_Asia" tm
filter "UAE_Family_Asia" ae
filter "Uzbekistan_Family_Asia" uz
filter "Vietnam_Family_Asia" vn
filter "Yemen_Family_Asia" ye

# ==========================================================================
# REGIONAL GROUPS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}REGIONAL GROUPS${NC}"

filter "EastAsia_Region_Asia" cn jp kr kp mn tw
filter "SoutheastAsia_Region_Asia" bn kh id la my mm ph sg th tl vn
filter "SouthAsia_Region_Asia" af bd bt in mv np pk lk
filter "CentralAsia_Region_Asia" kz kg tj tm uz
filter "WestAsia_Region_Asia" am az bh cy ge iq il jo kw lb om ps qa sa sy tr ae ye
filter "Asia_Regional_Domain" asia

# ==========================================================================
# GOVERNMENT / PUBLIC SECTOR
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}GOVERNMENT / PUBLIC SECTOR${NC}"

filter "China_Government_Asia" gov.cn
filter "India_Government_Asia" gov.in nic.in
filter "Japan_Government_Asia" go.jp
filter "SouthKorea_Government_Asia" go.kr
filter "Indonesia_Government_Asia" go.id
filter "Malaysia_Government_Asia" gov.my
filter "Singapore_Government_Asia" gov.sg
filter "Thailand_Government_Asia" go.th
filter "Philippines_Government_Asia" gov.ph
filter "Taiwan_Government_Asia" gov.tw
filter "Vietnam_Government_Asia" gov.vn
filter "Bangladesh_Government_Asia" gov.bd
filter "Pakistan_Government_Asia" gov.pk
filter "Nepal_Government_Asia" gov.np
filter "SriLanka_Government_Asia" gov.lk
filter "Bhutan_Government_Asia" gov.bt
filter "Brunei_Government_Asia" gov.bn
filter "Cambodia_Government_Asia" gov.kh
filter "Laos_Government_Asia" gov.la
filter "Myanmar_Government_Asia" gov.mm
filter "Mongolia_Government_Asia" gov.mn
filter "Kazakhstan_Government_Asia" gov.kz
filter "Kyrgyzstan_Government_Asia" gov.kg
filter "Tajikistan_Government_Asia" gov.tj
filter "Uzbekistan_Government_Asia" gov.uz
filter "Turkey_Government_Asia" gov.tr
filter "Israel_Government_Asia" gov.il
filter "Jordan_Government_Asia" gov.jo
filter "Qatar_Government_Asia" gov.qa
filter "UAE_Government_Asia" gov.ae
filter "SaudiArabia_Government_Asia" gov.sa
filter "Bahrain_Government_Asia" gov.bh
filter "Kuwait_Government_Asia" gov.kw
filter "Oman_Government_Asia" gov.om

# ==========================================================================
# EDUCATION
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}EDUCATION${NC}"

filter "China_Education_Asia" edu.cn ac.cn
filter "India_Education_Asia" edu.in ac.in res.in
filter "Japan_Education_Asia" ac.jp
filter "SouthKorea_Education_Asia" ac.kr
filter "Indonesia_Education_Asia" ac.id sch.id
filter "Malaysia_Education_Asia" edu.my
filter "Singapore_Education_Asia" edu.sg
filter "Thailand_Education_Asia" ac.th edu.th
filter "Philippines_Education_Asia" edu.ph
filter "Taiwan_Education_Asia" edu.tw
filter "Vietnam_Education_Asia" edu.vn
filter "Bangladesh_Education_Asia" edu.bd ac.bd
filter "Pakistan_Education_Asia" edu.pk
filter "Nepal_Education_Asia" edu.np
filter "SriLanka_Education_Asia" ac.lk edu.lk
filter "Brunei_Education_Asia" edu.bn
filter "Cambodia_Education_Asia" edu.kh
filter "Mongolia_Education_Asia" edu.mn
filter "Kazakhstan_Education_Asia" edu.kz
filter "Kyrgyzstan_Education_Asia" edu.kg
filter "Uzbekistan_Education_Asia" edu.uz
filter "Turkey_Education_Asia" edu.tr
filter "Israel_Education_Asia" ac.il
filter "Jordan_Education_Asia" edu.jo
filter "SaudiArabia_Education_Asia" edu.sa
filter "UAE_Education_Asia" ac.ae edu.ae

# ==========================================================================
# ORGANIZATIONS / NONPROFIT
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}ORGANIZATION / NONPROFIT${NC}"

filter "Asia_Organization" org
filter "China_Organization" org.cn
filter "India_Organization" org.in
filter "Japan_Organization" or.jp
filter "Korea_Organization" or.kr
filter "Indonesia_Organization" or.id
filter "Malaysia_Organization" org.my
filter "Singapore_Organization" org.sg
filter "Thailand_Organization" or.th
filter "Philippines_Organization" org.ph
filter "Vietnam_Organization" org.vn
filter "Taiwan_Organization" org.tw
filter "Pakistan_Organization" org.pk
filter "Bangladesh_Organization" org.bd
filter "Nepal_Organization" org.np
filter "SriLanka_Organization" org.lk

# ==========================================================================
# MAJOR FREE / COMMERCIAL MAIL PROVIDERS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}MAJOR MAIL PROVIDERS${NC}"

filter "Google_Family" gmail.com googlemail.com
filter "Microsoft_Family" outlook.com hotmail.com live.com msn.com
filter "Yahoo_Family" yahoo.com yahoo.co.jp yahoo.co.in yahoo.co.id yahoo.co.kr yahoo.com.sg yahoo.com.my yahoo.com.ph ymail.com rocketmail.com
filter "Apple_Family" icloud.com me.com mac.com
filter "AOL_Family" aol.com
filter "Proton_Family" proton.me protonmail.com
filter "Tuta_Family" tuta.com tutanota.com
filter "GMX_Family" gmx.com gmx.de gmx.at gmx.ch
filter "Mailcom_Family" mail.com email.com
filter "Yandex_Family" yandex.com yandex.ru yandex.kz
filter "Zoho_Family" zoho.com zohomail.com

# ==========================================================================
# IMPORTANT ASIAN PROVIDERS / HOSTS
# ==========================================================================
echo
echo "${LIGHTCYAN}${BOLD}ASIAN COMMERCIAL MAIL PROVIDERS${NC}"

filter "China_Providers" qq.com foxmail.com 163.com 126.com yeah.net sina.com sina.cn sohu.com tom.com 139.com 189.cn 21cn.com
filter "Japan_Providers" docomo.ne.jp ezweb.ne.jp au.com softbank.ne.jp i.softbank.jp nttdocomo.co.jp
filter "Korea_Providers" naver.com daum.net hanmail.net nate.com kakao.com
filter "India_Providers" rediffmail.com rediff.com indiatimes.com sify.com
filter "Taiwan_Providers" pchome.com.tw seed.net.tw msa.hinet.net
filter "Vietnam_Providers" vnn.vn fpt.vn viettel.com.vn
filter "Indonesia_Providers" telkom.net indosat.net.id
filter "Thailand_Providers" trueemail.co.th
filter "Malaysia_Providers" tm.net.my streamyx.com
filter "Philippines_Providers" pldt.com.ph
filter "Singapore_Providers" singnet.com.sg starhub.net.sg

# ==========================================================================
# OTHER: anything not matched above
# ==========================================================================
OTHER="$TMP_DIR/other.txt"

awk '
NR==FNR { seen[$0]=1; next }
{
    if (!seen[$0]) print
}
' "$EMAILS" "$EMAILS" > "$OTHER"

# Build a combined list of every generated classified email and remove them
# from the original set for a useful Other file.
CLASSIFIED="$TMP_DIR/classified.txt"
: > "$CLASSIFIED"
for f in "$OUTPUT"/*.txt; do
    [[ -f "$f" ]] && cat "$f" >> "$CLASSIFIED"
done
sort -u "$CLASSIFIED" -o "$CLASSIFIED"

awk 'NR==FNR { seen[$0]=1; next } !seen[$0]' "$CLASSIFIED" "$EMAILS" |
    sort -u > "$OTHER"

OTHER_COUNT=$(wc -l < "$OTHER")
mv "$OTHER" "$OUTPUT/Other_Asia[${OTHER_COUNT}].txt"

printf "${YELLOW}[OTHER] %-46s %s${NC}\n" "Other_Asia" "$OTHER_COUNT"

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
