#!/usr/bin/env bash

set -u
export LC_ALL=C

echo "============================================================"
echo "          FAST JAPAN EMAIL FAMILY FILTER"
echo "============================================================"
echo

read -rp "[+] Input file : " INPUT
read -rp "[+] Output dir : " OUTPUT

if [[ ! -f "$INPUT" ]]; then
    echo "[!] Input file not found: $INPUT"
    exit 1
fi

mkdir -p "$OUTPUT"

TMP_DIR="${TMPDIR:-/tmp}/japan_filter_$$"
mkdir -p "$TMP_DIR"

REMAINING="$TMP_DIR/emails.txt"

cleanup() {
    rm -rf "$TMP_DIR"
}

trap cleanup EXIT INT TERM

# ============================================================
# EMAIL EXTRACTION
# ============================================================

echo "[+] Extracting valid email addresses..."

awk '
{
    line = tolower($0)

    while (match(line, /[A-Za-z0-9_.%+-]+@[A-Za-z0-9.-]+\.[A-Za-z][A-Za-z]+/)) {
        email = substr(line, RSTART, RLENGTH)
        print email
        line = substr(line, RSTART + RLENGTH)
    }
}
' "$INPUT" > "$REMAINING"

TOTAL=$(wc -l < "$REMAINING")

echo "[+] Extracted : $TOTAL"
echo

# ============================================================
# FAMILY ARRAYS
# ============================================================

microsoft_family=( hotmail live outlook msn windowslive )
yahoo_family=( yahoo ymail rocketmail )
google_family=( gmail google googlemail )
aol_family=( aol )
apple_family=( mac apple icloud )
mail_family=( mail gmx )
proton_family=( proton protonmail )
tuta_family=( tuta tutanota )

ocn_family=( ocn )
dti_family=( dti )
dream_family=( dream )
nifty_family=( nifty )
biglobe_family=( biglobe )
sonet_family=( sonet so-net )
plala_family=( plala )
jcom_family=( jcom )
asahinet_family=( asahi-net asahinet )
eo_family=( eo )
hiho_family=( hi-ho hiho )
wakwak_family=( wakwak )
bbexcite_family=( bbexcite excite )
tcom_family=( tcom t-com )
nuro_family=( nuro )
iij_family=( iij )
gmo_family=( gmo )
rakuten_family=( rakuten )

docomo_family=( docomo )
au_family=( au ezweb )
softbank_family=( softbank i-softbank )
ymobile_family=( ymobile )
uq_family=( uq )
linemo_family=( linemo )
mineo_family=( mineo )

sakura_family=( sakura )
xserver_family=( xserver )
conoha_family=( conoha )
kagoya_family=( kagoya )
webarena_family=( webarena )
cpi_family=( cpi )

# ============================================================
# FAMILY FILTER
# ============================================================

filter_family() {

    local NAME="$1"
    shift

    local REGEX=""
    local WORD
    local MATCH
    local NEXT
    local COUNT

    for WORD in "$@"; do

        [[ -z "$WORD" ]] && continue

        if [[ -n "$REGEX" ]]; then
            REGEX+="|"
        fi

        REGEX+="$WORD"
    done

    [[ -z "$REGEX" ]] && return

    MATCH="$TMP_DIR/${NAME}.match"
    NEXT="$TMP_DIR/${NAME}.next"

    awk -v re="$REGEX" '
    {
        n = split($0, parts, "@")

        if (n == 2 && parts[2] ~ re) {
            print $0
        }
    }
    ' "$REMAINING" > "$MATCH"

    COUNT=$(wc -l < "$MATCH")

    if (( COUNT > 0 )); then

        mv "$MATCH" \
            "$OUTPUT/${NAME}[${COUNT}].txt"

        awk -v re="$REGEX" '
        {
            n = split($0, parts, "@")

            if (!(n == 2 && parts[2] ~ re)) {
                print $0
            }
        }
        ' "$REMAINING" > "$NEXT"

        mv "$NEXT" "$REMAINING"

        echo "[OK] $NAME -> $COUNT"

    else
        rm -f "$MATCH"
    fi
}

# ============================================================
# PROCESS FAMILIES
# ============================================================

echo "============================================================"
echo "Processing families..."
echo "============================================================"
echo

filter_family "Microsoft_Family_Japan" "${microsoft_family[@]}"
filter_family "Yahoo_Family_Japan" "${yahoo_family[@]}"
filter_family "Google_Family_Japan" "${google_family[@]}"
filter_family "AOL_Family_Japan" "${aol_family[@]}"
filter_family "Apple_Family_Japan" "${apple_family[@]}"
filter_family "Mail_Family_Japan" "${mail_family[@]}"
filter_family "Proton_Family_Japan" "${proton_family[@]}"
filter_family "Tuta_Family_Japan" "${tuta_family[@]}"

filter_family "OCN_Family_Japan" "${ocn_family[@]}"
filter_family "DTI_Family_Japan" "${dti_family[@]}"
filter_family "Dream_Family_Japan" "${dream_family[@]}"
filter_family "Nifty_Family_Japan" "${nifty_family[@]}"
filter_family "BIGLOBE_Family_Japan" "${biglobe_family[@]}"
filter_family "SoNet_Family_Japan" "${sonet_family[@]}"
filter_family "Plala_Family_Japan" "${plala_family[@]}"
filter_family "JCOM_Family_Japan" "${jcom_family[@]}"
filter_family "AsahiNet_Family_Japan" "${asahinet_family[@]}"
filter_family "EO_Family_Japan" "${eo_family[@]}"
filter_family "HiHo_Family_Japan" "${hiho_family[@]}"
filter_family "WAKWAK_Family_Japan" "${wakwak_family[@]}"
filter_family "BBExcite_Family_Japan" "${bbexcite_family[@]}"
filter_family "TCOM_Family_Japan" "${tcom_family[@]}"
filter_family "NURO_Family_Japan" "${nuro_family[@]}"
filter_family "IIJ_Family_Japan" "${iij_family[@]}"
filter_family "GMO_Family_Japan" "${gmo_family[@]}"
filter_family "Rakuten_Family_Japan" "${rakuten_family[@]}"

filter_family "Docomo_Family_Japan" "${docomo_family[@]}"
filter_family "AU_Family_Japan" "${au_family[@]}"
filter_family "SoftBank_Family_Japan" "${softbank_family[@]}"
filter_family "YMobile_Family_Japan" "${ymobile_family[@]}"
filter_family "UQ_Family_Japan" "${uq_family[@]}"
filter_family "LINEMO_Family_Japan" "${linemo_family[@]}"
filter_family "Mineo_Family_Japan" "${mineo_family[@]}"

filter_family "Sakura_Family_Japan" "${sakura_family[@]}"
filter_family "XServer_Family_Japan" "${xserver_family[@]}"
filter_family "ConoHa_Family_Japan" "${conoha_family[@]}"
filter_family "Kagoya_Family_Japan" "${kagoya_family[@]}"
filter_family "WebArena_Family_Japan" "${webarena_family[@]}"
filter_family "CPI_Family_Japan" "${cpi_family[@]}"

# ============================================================
# OTHER
# ============================================================

OTHER=$(wc -l < "$REMAINING")

mv "$REMAINING" \
    "$OUTPUT/Other_Mail_Japan[${OTHER}].txt"

echo
echo "============================================================"
echo "                         COMPLETE"
echo "============================================================"
echo
echo "Original : $TOTAL"
echo "Other    : $OTHER"
echo "Output   : $OUTPUT"
echo
echo "============================================================"
