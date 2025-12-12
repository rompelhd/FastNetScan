#!/usr/bin/env bash

# CONFIG ------------------------------------

RANGE="$1"
OUTPUT="online_hosts.txt"
PARALLEL_JOBS=100  # adjust based on CPU cores

# Remember to use this script in a controlled environment. 
# We are not responsible for any incidents. You are solely responsible.
# CREATED BY ROMPELHD ------------------------

if [ -z "$RANGE" ]; then
    echo "Usage: $0 <range-with-asterisks>"
    echo "Examples:"
    echo "  $0 10.0.0.*"
    echo "  $0 10.0.*.*"
    echo "  $0 10.0.*.1"
    exit 1
fi

if ! command -v fping &> /dev/null; then
    echo "[!] Error: fping is not installed."
    exit 1
fi

cleanup() {
    echo -e "\n[!] Interrupted by user. Exiting..."
    rm -f "$TEMP_IPS" "$PROGRESS_FILE" 2>/dev/null
    exit 1
}
trap cleanup SIGINT

clear_line() {
    printf "\r%-80s\r" " "
}

# GENERATE IP LIST

generate_ips_dot_one() {
    local a=$1
    local b=$2
    TEMP_IPS=$(mktemp)
    for i in {0..255}; do
        echo "${a}.${b}.$i.1"
    done > "$TEMP_IPS"
}

generate_ips_subnet() {
    local subnet=$1
    TEMP_IPS=$(mktemp)
    for i in {0..255}; do
        echo "${subnet%.*}.$i"
    done > "$TEMP_IPS"
}

generate_ips_full() {
    local a=$1
    local b=$2
    TEMP_IPS=$(mktemp)
    for i in {0..255}; do
        for j in {0..255}; do
            echo "${a}.${b}.$i.$j"
        done
    done > "$TEMP_IPS"
}

# PARALLEL SCAN WITH PROGRESS

parallel_scan() {
    TOTAL=$(wc -l < "$TEMP_IPS")
    echo "[+] Total IPs to scan: $TOTAL"
    > "$OUTPUT"

    PROGRESS_FILE=$(mktemp)
    FOUND_FILE=$(mktemp)
    echo 0 > "$PROGRESS_FILE"
    echo 0 > "$FOUND_FILE"

    start_time=$(date +%s)

    cat "$TEMP_IPS" | xargs -P $PARALLEL_JOBS -n1 bash -c '
        ip="$1"
        if fping -c1 -t300 "$ip" >/dev/null 2>&1; then
            echo "$ip" >> "'"$OUTPUT"'"
            flock "'"$FOUND_FILE"'" -c "n=\$(cat "'"$FOUND_FILE"'"); echo \$((n+1)) > "'"$FOUND_FILE"'""
        fi
        
        # increment progress safely
        flock "'"$PROGRESS_FILE"'" -c "n=\$(cat "'"$PROGRESS_FILE"'"); echo \$((n+1)) > "'"$PROGRESS_FILE"'""
    ' _ &

    while true; do
        CURRENT=$(cat "$PROGRESS_FILE" 2>/dev/null)
        CURRENT=${CURRENT:-0}
        FOUND=$(cat "$FOUND_FILE" 2>/dev/null || echo 0)
        printf "\r[%5d/%5d] Found: %d" "$CURRENT" "$TOTAL" "$FOUND"
        sleep 0.1
        [[ "$CURRENT" -ge "$TOTAL" ]] && break
    done

    wait
    clear_line

    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "[+] Scan completed in $duration seconds"

    if [ -s "$OUTPUT" ]; then
        echo ""
        echo "[+] Active hosts found:"
        echo "-------------------"
        cat "$OUTPUT"
    fi

    rm -f "$PROGRESS_FILE" "$FOUND_FILE"
}

# MAIN

echo "[+] Network scanner with fping"
echo "[+] Range: $RANGE"
echo ""

> "$OUTPUT"

IFS='.' read -r A B C D <<< "$RANGE"

if [[ "$C" == "*" && "$D" == "1" ]]; then
    generate_ips_dot_one "$A" "$B"
elif [[ "$C" == "*" && "$D" == "*" ]]; then
    generate_ips_full "$A" "$B"
elif [[ "$D" == "*" ]]; then
    base="${A}.${B}.${C}.0"
    generate_ips_subnet "$base"
else
    echo "[!] Unsupported range format."
    exit 1
fi

parallel_scan

FOUND=$(wc -l < "$OUTPUT" 2>/dev/null || echo 0)
echo "[+] Total active hosts found: $FOUND"
echo ""
echo "[+] Results saved to: $OUTPUT"
rm -f "$TEMP_IPS"
