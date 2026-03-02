#!/bin/bash
# ============================================================
# run_all.sh — Run teller automation tests for all banks
# Usage: bash run_all.sh [tag]
#   e.g. bash run_all.sh           → runs all tests
#   e.g. bash run_all.sh smoke     → runs smoke tests only
#   e.g. bash run_all.sh regression → runs regression tests only
# ============================================================

BANKS=(
  "rural-bank-san-antonio"
  "banco-abucay"
  "rural-bank-hermosa"
  "alegre"
)

TAG=$1
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

for BANK in "${BANKS[@]}"; do
  echo ""
  echo "============================================================"
  echo "  Running tests for: $BANK"
  echo "============================================================"

  VAR_FILE="resources/variables/${BANK}.yaml"
  OUTPUT_DIR="results/${TIMESTAMP}/${BANK}"

  if [ -n "$TAG" ]; then
    robot -V "$VAR_FILE" -d "$OUTPUT_DIR" --include "$TAG" tests/
  else
    robot -V "$VAR_FILE" -d "$OUTPUT_DIR" tests/
  fi

  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    echo "  [FAILED] Tests failed for $BANK (exit code $STATUS)"
  else
    echo "  [PASSED] All tests passed for $BANK"
  fi
done

echo ""
echo "============================================================"
echo "  All runs complete. Reports saved under: results/${TIMESTAMP}/"
echo "============================================================"
