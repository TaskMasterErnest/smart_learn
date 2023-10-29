#!/bin/bash

# Install ZAP
echo 'deb http://download.opensuse.org/repositories/home:/cabelo/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/home:cabelo.list
curl -fsSL https://download.opensuse.org/repositories/home:cabelo/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_cabelo.gpg > /dev/null
sudo apt update
sudo apt install owasp-zap

# Start ZAP service
/usr/share/owasp-zap/zap.sh -daemon -port 8090 -host 0.0.0.0 &
# Wait for ZAP to start up
sleep 10
# Run ZAP API Scan against Django API
zap-cli --zap-url http://localhost:8090 -p 8090 -s zap-api-scan.py -t "http://0.0.0.0:8080" -f openapi

# get the exit code
exit_code=$?

# get the exit code
echo "Exit Code : $exit_code"

# processing the exit code
if [[ ${exit_code} -ne 0 ]]; then
  echo "OWASP ZAP report has either Low/Medium/High. Please check the HTML report"
  exit 1;
else
  echo "OWASP ZAP did not report any Risk"
fi;