#!/bin/bash

# Run ZAP scan against Django API and capture the output
zap_output=$(docker run -t owasp/zap2docker-weekly zap-api-scan.py -t http://0.0.0.0:8080/ -f openapi)

# Extract FAIL-NEW and FAIL-INPROG values from the ZAP output
fail_new=$(echo "$zap_output" | grep -oP 'FAIL-NEW: \K\d+')
fail_inprog=$(echo "$zap_output" | grep -oP 'FAIL-INPROG: \K\d+')

# Check if FAIL-NEW or FAIL-INPROG are not zero, and fail the pipeline
if [[ $fail_new -ne 0 && $fail_inprog -ne 0 ]]; then
  echo "ZAP scan failed with new or in-progress failures."
  echo "Zap Security Scan Output:"
  echo "$zap_output"
  exit 1  # Fail the pipeline
else
  echo "ZAP scan passed."
  echo "Zap Security Scan Output:"
  echo "$zap_output"
fi
