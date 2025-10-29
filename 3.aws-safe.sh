aws() {
    # Colors
    RED='\033[1;31m'
    YELLOW='\033[1;33m'
    GREEN='\033[1;32m'
    BLUE='\033[1;34m'
    NC='\033[0m'

    # Fetch identity
    identity=$(command aws sts get-caller-identity --output json 2>/dev/null)
    if [[ $? -ne 0 || -z "$identity" ]]; then
        echo -e "❌ ${RED}Unable to retrieve AWS identity.${NC}"
        return 1
    fi

    account=$(echo "$identity" | jq -r '.Account')
    user_id=$(echo "$identity" | jq -r '.UserId')

    if [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" ]]; then
        source="ENVIRONMENT"
    elif [[ -n "$AWS_PROFILE" ]]; then
        source="PROFILE: ${AWS_PROFILE^^}"
    else
        source="PROFILE: DEFAULT"
    fi
    
    echo
    echo -e "${RED}🔴${NC}  ACCOUNT     : ${BLUE}${account}${NC} (${source})"
    #echo
    #echo -e "🔍  Checking identity..."
    echo
    echo -e "${YELLOW}🟡${NC}  UserId      : ${BLUE}${user_id}${NC}"
    echo
    echo -ne "${GREEN}🟢${NC}  Press Enter to continue or any key to cancel: "
    
    # Read single key (no Enter needed)
    IFS= read -rsn1 input
    echo
    if [[ -n "$input" ]]; then
        echo -e "🚫 ${RED}Command cancelled.${NC}"
        return 0
    fi
    
    echo

    command aws "$@"
}

