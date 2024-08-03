#!/bin/bash

# 색상 코드
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
NC=$(tput sgr0)

# ===================================================
site_names=(
  "Google"
  "Naver"
  "Daum"
  "Nate"
)

site_urls=(
  "https://www.google.co.kr/"
  "https://www.naver.com/"
  "https://www.daum.net/"
  "https://www.nate.com/"
)
# ===================================================

# 열 길이 정의
name_length=30
url_length=80
status_length=10

# HTTP 상태 코드를 기반으로 상태를 확인
site_health_check() {
  local name="$1"
  local url="$2"
  local status_code=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 "$url")
  local status
  
  if [ "$status_code" -eq 200 ]; then
    status="${GREEN}UP${NC}"
  elif [ "$status_code" -eq 302 ]; then
    status="${YELLOW}REDIRECT${NC} (Status code: $status_code)"
  elif [ "$status_code" -ge 400 ] && [ "$status_code" -lt 500 ]; then
    status="${RED}CLIENT ERROR${NC} (Status code: $status_code)"
  else
    status="${RED}DOWN${NC} (Status code: $status_code)"
  fi
  
  # 각 요소를 정렬하여 출력
  printf "%-${name_length}s %-${url_length}s %-${status_length}s\n" "$name" "$url" "$status"
}

site_health_loop() {
  # 함수를 호출할 때 전달된 문자열을 배열로 변환
  local site_names=($1)
  local site_urls=($2)

  printf "%-${name_length}s %-${url_length}s %-${status_length}s\n" "Name" "URL" "Status"
  echo "----------------------------------------------------------------------------------------------------------------------------------------------------"

  # 각 사이트의 상태 확인
  for i in "${!site_names[@]}"
  do
    name=${site_names[$i]}
    url=${site_urls[$i]}
    site_health_check "$name" "$url"
  done
}

echo -e "\n\n Site Health Check"
echo "----------------------------------------------------------------------------------------------------------------------------------------------------"
site_health_loop "$(printf "%s " "${other_site_names[@]}")" "$(printf "%s " "${other_site_urls[@]}")"
