#!/bin/bash

# run Bandit and capture the output
bandit_output=$(bandit -r *)

# set the desired levels of severity and confidence
desired_severity="HIGH"
desired_confidence="HIGH"

# check if output conforms with desired severity and confidence levels
if [[ $bandit_output == *"$desired_severity   Confidence: $desired_confidence"* ]]; then
  echo "Security scan passed."
  exit 0
else
  echo " Security scan failed. Issues with severity and confidence levels"
  echo "Bandit Security Scan Output:"
  echo "$bandit_output"
  exit 1
fi