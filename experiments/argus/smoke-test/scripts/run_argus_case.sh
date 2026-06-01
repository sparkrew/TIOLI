#!/usr/bin/env bash
set -uo pipefail

RUN_NAME="$1"
MODE="$2"
URL="$3"
REF_TYPE="$4"
REF="$5"
EXTRA_ARGS="${6:-}"

BASE_DIR="$(pwd)/argus_runs/$RUN_NAME"
LOG_DIR="$BASE_DIR/logs"
RESULT_DIR="$BASE_DIR/results"

rm -rf "$BASE_DIR"
mkdir -p "$LOG_DIR" "$RESULT_DIR"

echo "[+] Running Argus case: $RUN_NAME"
echo "[+] Mode: $MODE"
echo "[+] URL: $URL"
echo "[+] Ref: $REF_TYPE=$REF"
echo "[+] Extra args: $EXTRA_ARGS"

/usr/bin/time -v -o "$LOG_DIR/time.txt" \
docker-compose run --rm \
  -v "$BASE_DIR:/host_run" \
  --entrypoint bash \
  argus \
  -lc "
    echo '=== Running Argus ==='

    python argus.py \
      --mode '$MODE' \
      --url '$URL' \
      --$REF_TYPE '$REF' \
      $EXTRA_ARGS

    ARGUS_EXIT=\$?

    echo '=== Argus exit code:' \$ARGUS_EXIT '==='

    echo '=== Searching generated files ==='

    find /root /tmp /results -type f 2>/dev/null \
      | tee /host_run/logs/files_inside_container.txt

    echo '=== Copying SARIF reports ==='

    find /root /tmp /results -type f -name '*.sarif' 2>/dev/null \
      -exec cp -v {} /host_run/results/ \; || true

    echo \$ARGUS_EXIT > /host_run/logs/argus_exit_code.txt

    exit \$ARGUS_EXIT
  " \
  > "$LOG_DIR/stdout.txt" \
  2> "$LOG_DIR/stderr.txt"

DOCKER_EXIT=$?

grep -R "ALERT RAISED" "$LOG_DIR" > "$RESULT_DIR/alerts.txt" || true

echo "$DOCKER_EXIT" > "$LOG_DIR/docker_exit_code.txt"

echo "[+] Finished: $RUN_NAME"
echo "[+] Docker exit code: $DOCKER_EXIT"
echo "[+] Results:"
find "$RESULT_DIR" -type f -print

exit 0
