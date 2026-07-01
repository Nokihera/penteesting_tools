#!/bin/bash
if ((UID != 0)); then
  echo "You need to run this script as root!"
  exit 1
fi
if [[ "$1" == "open" ]]; then
  ufw allow 9000
  ufw allow 4444
  ufw logging medium
  echo -e "\nSUCCESSFULLY SET THE FIREWALL RULES TO ALLOW PORT 9000,4444..."
  exit 0
elif [[ "$1" == "close" ]]; then
  ufw delete allow 9000
  ufw delete allow 4444
  ufw logging low
  echo -e "\nSUCCESSFULLY SET THE FIREWALL RULES TO DISALLOW PORT 9000,4444..."
  exit 0
else
  echo "INVALID FLAG! YOU NEED TO SET FLAG INTO OPEN OR CLOSE..."
  exit 1
fi
