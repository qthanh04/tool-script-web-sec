#!/bin/bash

# =============================================================================
# LABTAINER OWASP SECURITY LABS - QUICK SETUP SCRIPT
# =============================================================================
# Script này giúp setup nhanh environment và hướng dẫn download labs
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}   LABTAINER OWASP SECURITY LABS SETUP         ${NC}"
    echo -e "${BLUE}        Quick Environment Setup Script         ${NC}"
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

# Check if labs directory exists and has files
check_labs_directory() {
    if [ ! -d "labs" ]; then
        print_error "Thư mục labs/ không tồn tại!"
        return 1
    fi
    
    LAB_COUNT=$(find labs/ -name "*.lab" | wc -l)
    if [ "$LAB_COUNT" -eq 0 ]; then
        print_warning "Thư mục labs/ trống (không có files .lab)"
        return 1
    fi
    
    print_success "Tìm thấy $LAB_COUNT lab files trong thư mục labs/"
    return 0
}

# Download instructions
show_download_instructions() {
    echo -e "${YELLOW}📥 LAB FILES KHÔNG CÓ SẴN${NC}"
    echo ""
    echo -e "${BLUE}Có 3 cách để lấy lab files:${NC}"
    echo ""
    echo -e "${GREEN}1. Download Template Package (Recommended):${NC}"
    echo "   wget https://github.com/qthanh04/tool-script-web-sec/releases/download/v1.0/owasp-labtainer-labs-template-v1.0.tar.gz"
    echo "   tar -xzf owasp-labtainer-labs-template-v1.0.tar.gz"
    echo "   ./universal_lab_converter.sh  # Convert to your Student ID"
    echo ""
    echo -e "${GREEN}2. Use Individual Scripts (if you have original labs):${NC}"
    echo "   ./scripts/fix_xsite.sh"
    echo "   ./scripts/fix_sql_inject.sh"
    echo "   # ... repeat for all labs"
    echo ""
    echo -e "${GREEN}3. Use Universal Converter (if you have original labs):${NC}"
    echo "   ./universal_lab_converter.sh"
    echo "   # Nhập Student ID mới khi được hỏi"
    echo ""
}

# Main setup function
main() {
    print_header
    
    print_info "Kiểm tra môi trường hiện tại..."
    echo ""
    
    # Check current directory
    if [ ! -f "universal_lab_converter.sh" ]; then
        print_error "Không tìm thấy universal_lab_converter.sh"
        print_info "Đảm bảo bạn đang ở trong thư mục LABTAINER_COMPLETE_PACKAGE"
        exit 1
    fi
    
    print_success "Tìm thấy universal converter script"
    
    # Check scripts directory
    if [ ! -d "scripts" ]; then
        print_error "Không tìm thấy thư mục scripts/"
        exit 1
    fi
    
    SCRIPT_COUNT=$(find scripts/ -name "*.sh" | wc -l)
    print_success "Tìm thấy $SCRIPT_COUNT individual scripts"
    
    # Check labs
    if check_labs_directory; then
        echo ""
        print_success "Setup hoàn tất! Bạn có thể sử dụng ngay:"
        echo ""
        echo -e "${GREEN}Quick Start:${NC}"
        echo "1. ./universal_lab_converter.sh    # Convert với Student ID mới"
        echo "2. cp labs/*.lab ~/labtainer_xfer/ # Copy labs vào Labtainer"
        echo "3. checkwork xsite web-brokenaccess sql-inject web-inject web-insdes web-vulcom web-xss web-xxe"
        echo ""
        print_success "Expected Result: 21/21 objectives pass! 🎉"
    else
        echo ""
        show_download_instructions
    fi
    
    echo ""
    echo -e "${BLUE}================================================${NC}"
    echo -e "${GREEN}           SETUP COMPLETE                     ${NC}"
    echo -e "${BLUE}================================================${NC}"
}

# Execute main function
main "$@"