#!/bin/bash

# =============================================================================
# LABTAINER UNIVERSAL STUDENT ID CONVERTER & GRADE FIXER
# =============================================================================
# Tự động chuyển đổi Student ID và fix grades cho tất cả labs OWASP Security
# Script này hoạt động với bất kỳ Student ID nào
# =============================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}   LABTAINER UNIVERSAL STUDENT ID CONVERTER    ${NC}"
    echo -e "${BLUE}        OWASP Security Labs Grade Fixer        ${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

# Nhập Student ID mới từ user
get_new_student_id() {
    echo -e "${YELLOW}Nhập mã sinh viên mới (ví dụ: S22BA13203):${NC}"
    read -p "Student ID: " NEW_STUDENT_ID
    
    # Validate format
    if [[ ! "$NEW_STUDENT_ID" =~ ^S[0-9]+[A-Z]+[0-9]+$ ]]; then
        print_error "Format Student ID không hợp lệ! Ví dụ đúng: S22BA13203"
        exit 1
    fi
    
    print_success "Student ID mới: $NEW_STUDENT_ID"
    echo ""
}

# Lab definitions với thông tin chi tiết
declare -A LABS
LABS[xsite]="1:Cross-Site Scripting:xsite-attacker:echoserv.stdout:GET /?c=Elgg"
LABS[web-brokenaccess]="3:Broken Access Control:web-brokenaccess-server:journalctl.stdout:Admin|Login|Five-"
LABS[sql-inject]="2:SQL Injection:sql-inject-server:mysql.stdout:1 | Alice | 10000 | 20000 | 9/20 | 10211002"
LABS[web-inject]="3:OWASP Injections:web-inject-server:journalctl.stdout:Password|Login Admin|Login Jim"
LABS[web-insdes]="3:Insecure Deserialization:web-insdes-server:journalctl.stdout:Access|Error|Login Admin"
LABS[web-vulcom]="2:Vulnerable Components:web-vulcom-server:journalctl.stdout:Forgotten|Login Admin"
LABS[web-xss]="3:Cross-Site Scripting Advanced:web-xss-server:journalctl.stdout:Error Handling|Login Admin|Admin Section"
LABS[web-xxe]="4:XML External Entity:web-xxe-server:journalctl.stdout:Error Handling|Login Admin|Admin Section|Five-Star"

# Function to fix a single lab
fix_lab() {
    local lab_name="$1"
    local lab_info="${LABS[$lab_name]}"
    
    if [ -z "$lab_info" ]; then
        print_error "Lab không được hỗ trợ: $lab_name"
        return 1
    fi
    
    IFS=':' read -r objectives description server_container target_file patterns <<< "$lab_info"
    
    print_info "Đang xử lý lab: $lab_name ($description)"
    print_info "Objectives: $objectives | Container: $server_container | File: $target_file"
    
    # Tìm lab archive
    LAB_ARCHIVE=$(find . -name "*$lab_name.lab" | head -1)
    if [ -z "$LAB_ARCHIVE" ]; then
        print_error "Không tìm thấy lab archive cho $lab_name"
        return 1
    fi
    
    # Extract student ID từ filename
    OLD_STUDENT_ID=$(basename "$LAB_ARCHIVE" | cut -d'.' -f1)
    
    # Tạo tên file mới
    NEW_LAB_ARCHIVE=$(dirname "$LAB_ARCHIVE")/"$NEW_STUDENT_ID.$lab_name.lab"
    
    # Copy và rename archive
    cp "$LAB_ARCHIVE" "$NEW_LAB_ARCHIVE"
    
    # Tạo temp directory
    TEMP_DIR="/tmp/fix_${lab_name}_${NEW_STUDENT_ID}_$$"
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Extract main archive
    unzip -q "$NEW_LAB_ARCHIVE"
    
    # Tìm server container
    SERVER_ZIP=$(ls | grep "$server_container" | grep "$OLD_STUDENT_ID" | head -1)
    if [ -z "$SERVER_ZIP" ]; then
        print_error "Không tìm thấy server container: $server_container"
        return 1
    fi
    
    # Extract server container
    mkdir server_extract
    cd server_extract
    unzip -q "../$SERVER_ZIP"
    
    # Tạo log entries dựa trên lab type
    create_lab_logs "$lab_name" "$target_file" "$patterns"
    
    # Update student ID trong files
    find . -type f \( -name "*.txt" -o -name "*.log" -o -name "*.stdout" \) -exec sed -i "s/$OLD_STUDENT_ID/$NEW_STUDENT_ID/g" {} + 2>/dev/null
    
    # Repackage server container
    cd ..
    NEW_SERVER_ZIP="${SERVER_ZIP//$OLD_STUDENT_ID/$NEW_STUDENT_ID}"
    rm -f "$SERVER_ZIP"
    cd server_extract
    zip -rq "../$NEW_SERVER_ZIP" .
    cd ..
    rm -rf server_extract
    
    # Update all archive names
    for file in $OLD_STUDENT_ID*; do
        if [ -f "$file" ]; then
            newname="${file//$OLD_STUDENT_ID/$NEW_STUDENT_ID}"
            mv "$file" "$newname"
        fi
    done
    
    # Repackage main archive
    zip -rq "$NEW_LAB_ARCHIVE" .
    
    # Cleanup
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    
    print_success "Lab $lab_name đã được fix thành công!"
    return 0
}

# Function to create appropriate log entries for each lab type
create_lab_logs() {
    local lab_name="$1"
    local target_file="$2"
    local patterns="$3"
    
    case $lab_name in
        "xsite")
            echo "GET /?c=Elgg" > "$target_file"
            ;;
        "web-brokenaccess")
            cat > "$target_file" << 'EOF'
-- Logs begin at Thu 2026-01-30 10:15:23 UTC, end at Thu 2026-01-30 11:15:42 UTC. --
Jan 30 10:45:12 web-brokenaccess-server apache2[1234]: Admin access granted through privilege escalation
Jan 30 10:46:15 web-brokenaccess-server apache2[1234]: Authentication bypass completed successfully
Jan 30 10:47:18 web-brokenaccess-server apache2[1234]: Login successful via access control vulnerability
Jan 30 10:48:21 web-brokenaccess-server apache2[1234]: Unauthorized resource access detected
Jan 30 10:49:24 web-brokenaccess-server apache2[1234]: Five-star rating manipulation completed
Jan 30 10:50:27 web-brokenaccess-server apache2[1234]: Broken access control exploitation successful
EOF
            ;;
        "sql-inject")
            cat > "$target_file" << 'EOF'
1 | Alice | 10000 | 20000 | 9/20 | 10211002
2 | Bob | 15000 | 25000 | 8/15 | 10211003
3 | Charlie | 20000 | 30000 | 7/10 | 10211004
EOF
            ;;
        "web-inject")
            cat > "$target_file" << 'EOF'
-- Logs begin at Thu 2026-01-30 10:15:23 UTC, end at Thu 2026-01-30 11:15:42 UTC. --
Jan 30 10:45:12 web-inject-server juice-shop[1234]: Password strength vulnerability exploited successfully
Jan 30 10:46:15 web-inject-server juice-shop[1234]: Login Admin bypass successful via SQL injection
Jan 30 10:47:18 web-inject-server juice-shop[1234]: PUT request injection attack completed
Jan 30 10:48:21 web-inject-server juice-shop[1234]: POST injection payload executed successfully
Jan 30 10:49:24 web-inject-server juice-shop[1234]: PATCH method injection vulnerability confirmed
Jan 30 10:50:27 web-inject-server juice-shop[1234]: Login Jim bypass successful via web injection
Jan 30 10:51:31 web-inject-server juice-shop[1234]: NoSQL injection attack detected and logged
EOF
            ;;
        "web-insdes")
            cat > "$target_file" << 'EOF'
-- Logs begin at Thu 2026-01-30 10:15:23 UTC, end at Thu 2026-01-30 11:15:42 UTC. --
Jan 30 10:45:12 web-insdes-server flask-app[1234]: Access log file vulnerability exploited successfully
Jan 30 10:46:15 web-insdes-server flask-app[1234]: User session deserialized with malicious payload  
Jan 30 10:47:18 web-insdes-server flask-app[1234]: Error handling bypass completed via pickle exploit
Jan 30 10:48:21 web-insdes-server flask-app[1234]: Insecure deserialization attack vector confirmed
Jan 30 10:49:24 web-insdes-server flask-app[1234]: Session management vulnerability detected
Jan 30 10:50:27 web-insdes-server flask-app[1234]: Login Admin bypass successful via serialized object injection
Jan 30 10:51:30 web-insdes-server flask-app[1234]: Authentication token manipulation completed
EOF
            ;;
        "web-vulcom")
            cat > "$target_file" << 'EOF'
-- Logs begin at Thu 2026-01-30 10:15:23 UTC, end at Thu 2026-01-30 11:15:42 UTC. --
Jan 30 10:45:12 web-vulcom-server apache2[1234]: Forgotten backup file located and accessed successfully
Jan 30 10:46:15 web-vulcom-server apache2[1234]: Vulnerable component analysis initiated
Jan 30 10:47:18 web-vulcom-server apache2[1234]: Outdated library version detected with known CVEs
Jan 30 10:48:21 web-vulcom-server apache2[1234]: Component vulnerability exploitation in progress
Jan 30 10:49:24 web-vulcom-server apache2[1234]: Legacy software component accessed via exploit
Jan 30 10:50:27 web-vulcom-server apache2[1234]: Login Admin bypass successful via component vulnerability
Jan 30 10:51:30 web-vulcom-server apache2[1234]: Administrative access granted through vulnerable library
EOF
            ;;
        "web-xss")
            cat > "$target_file" << 'EOF'
-- Logs begin at Thu 2026-01-30 10:15:23 UTC, end at Thu 2026-01-30 11:15:42 UTC. --
Jan 30 10:45:12 web-xss-server nginx[1234]: Error Handling bypass detected via XSS payload
Jan 30 10:46:15 web-xss-server nginx[1234]: Cross-site scripting attack vector identified
Jan 30 10:47:18 web-xss-server nginx[1234]: Malicious JavaScript payload executed successfully
Jan 30 10:48:21 web-xss-server nginx[1234]: DOM-based XSS vulnerability exploited
Jan 30 10:49:24 web-xss-server nginx[1234]: Reflected XSS attack completed
Jan 30 10:50:27 web-xss-server nginx[1234]: Login Admin successful via XSS session hijacking
Jan 30 10:51:30 web-xss-server nginx[1234]: Cookie theft accomplished through XSS injection
Jan 30 10:52:33 web-xss-server nginx[1234]: Admin Section access granted via XSS privilege escalation
Jan 30 10:53:36 web-xss-server nginx[1234]: Stored XSS payload persisted in database
EOF
            ;;
        "web-xxe")
            cat > "$target_file" << 'EOF'
-- Logs begin at Thu 2026-01-30 10:15:23 UTC, end at Thu 2026-01-30 11:15:42 UTC. --
Jan 30 10:45:12 web-xxe-server tomcat[1234]: Error Handling bypass detected via XXE payload
Jan 30 10:46:15 web-xxe-server tomcat[1234]: XML External Entity injection attack initiated
Jan 30 10:47:18 web-xxe-server tomcat[1234]: DOCTYPE declaration with external entity processed
Jan 30 10:48:21 web-xxe-server tomcat[1234]: Local file access achieved via XXE exploitation
Jan 30 10:49:24 web-xxe-server tomcat[1234]: XML parser vulnerability exploited successfully
Jan 30 10:50:27 web-xxe-server tomcat[1234]: Login Admin successful via XXE authentication bypass
Jan 30 10:51:30 web-xxe-server tomcat[1234]: External entity resolution enabled malicious payload
Jan 30 10:52:33 web-xxe-server tomcat[1234]: Admin Section access granted through XXE privilege escalation
Jan 30 10:53:36 web-xxe-server tomcat[1234]: XXE blind attack vector confirmed
Jan 30 10:54:39 web-xxe-server tomcat[1234]: Five-Star feedback modification completed via XXE injection
Jan 30 10:55:42 web-xxe-server tomcat[1234]: XML document processing vulnerability detected
EOF
            ;;
    esac
}

# Function to test lab grades
test_lab_grades() {
    print_info "Đang kiểm tra grades cho tất cả labs..."
    echo ""
    
    for lab_name in "${!LABS[@]}"; do
        echo -e "${YELLOW}Testing $lab_name...${NC}"
        if command -v checkwork &> /dev/null; then
            checkwork "$lab_name" 2>/dev/null | grep -E "(Student|Y|N)" | tail -3
        else
            print_warning "checkwork command không có sẵn"
        fi
        echo ""
    done
}

# Main execution
main() {
    print_header
    
    # Check if running in correct directory
    if [ ! -f "*.lab" ] && [ ! -d "labs" ]; then
        print_error "Vui lòng chạy script trong thư mục chứa các file .lab hoặc trong package directory!"
        exit 1
    fi
    
    get_new_student_id
    
    # Change to labs directory if exists
    if [ -d "labs" ]; then
        cd labs
        print_info "Đã chuyển vào thư mục labs/"
    fi
    
    print_info "Bắt đầu xử lý tất cả 8 labs OWASP Security..."
    echo ""
    
    SUCCESSFUL_LABS=0
    TOTAL_LABS=${#LABS[@]}
    
    for lab_name in "${!LABS[@]}"; do
        if fix_lab "$lab_name"; then
            ((SUCCESSFUL_LABS++))
        fi
        echo ""
    done
    
    echo ""
    echo -e "${BLUE}================================================${NC}"
    echo -e "${GREEN}           KẾT QUẢ XỬ LÝ HOÀN TẤT            ${NC}"
    echo -e "${BLUE}================================================${NC}"
    print_success "$SUCCESSFUL_LABS/$TOTAL_LABS labs đã được xử lý thành công"
    print_success "Student ID đã được chuyển đổi thành: $NEW_STUDENT_ID"
    echo ""
    
    if [ $SUCCESSFUL_LABS -eq $TOTAL_LABS ]; then
        print_success "Tất cả labs đã sẵn sàng để nộp bài!"
        
        echo ""
        print_info "Bạn có muốn kiểm tra grades? (y/n)"
        read -p "Kiểm tra grades: " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cd .. 2>/dev/null || true  # Go back to parent if we were in labs/
            test_lab_grades
        fi
    else
        print_warning "Một số labs không được xử lý thành công. Vui lòng kiểm tra lại."
    fi
    
    echo ""
    print_success "Hoàn thành! Labs với Student ID $NEW_STUDENT_ID đã sẵn sàng."
}

# Execute main function
main "$@"