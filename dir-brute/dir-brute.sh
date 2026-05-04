#!/bin/bash

# အရောင်သတ်မှတ်ချက်များ
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner လှလှလေးတစ်ခုထည့်မယ် (Optional)
echo -e "${BLUE}---------------------------------------${NC}"
echo -e "${BLUE}   DIRECTORY BRUTE-FORCER v1.0         ${NC}"
echo -e "${BLUE}---------------------------------------${NC}"

echo -e "${YELLOW}[?] Type your target url:${NC}"
read -r target

echo -e "${YELLOW}[?] Type your wordlist path:${NC}"
read -r wordlist

trap "echo -e '\n${RED}[!] User Interrupted, Exiting....${NC}'; exit 1" SIGINT

# URL formatting (သင်ရေးထားတဲ့ logic အတိုင်းပဲ slash ထည့်တာပါ)
if [[ ! "$target" == */ ]]; then
    target="$target/"
fi

line_count=0

if [[ ! -f $wordlist ]]; then
    echo -e "${RED}[!] Your wordlist path does not exist!${NC}"
    exit 1
fi

echo -e "\n${GREEN}[*] Start brute-forcing web directories at: $target${NC}"
echo -e "${BLUE}---------------------------------------${NC}"

while IFS= read -r word; do
    # Logic အပိုင်းကို လုံးဝမပြောင်းလဲထားပါ
    response=$(curl -s -I $target$word | sed -n "1p"| cut -d " " -f 2)
    
    if [[ "$response" != "404" && "$response" != "" ]]; then
        # 200 OK ဖြစ်ရင် စာကြောင်းအသစ်နဲ့ အစိမ်းရောင်ပြမယ်
        echo -e "\n${GREEN}[+] Found: $word ($response)${NC}"
        let "line_count++"
    else
        let "line_count++"
        # 200 မဟုတ်ရင် စာကြောင်းတစ်ကြောင်းတည်းမှာတင် counter တိုးပြမယ်
        echo -ne "${YELLOW}[*] Scanning: $line_count ($word)\e[K${NC}\r"
    fi
done < "$wordlist"

echo -e "\n${BLUE}---------------------------------------${NC}"
echo -e "${GREEN}[V] Finished! Total lines scanned: $line_count${NC}"
exit 0