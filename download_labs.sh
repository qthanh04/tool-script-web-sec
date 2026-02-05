#!/bin/bash

# =============================================================================
# DOWNLOAD LAB FILES SCRIPT - ALTERNATIVE TO GITHUB RELEASES
# =============================================================================
# Script này giúp users download lab files từ alternative sources
# =============================================================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${BLUE}================================================${NC}"
    echo -e "${BLUE}        DOWNLOAD OWASP SECURITY LAB FILES        ${NC}"
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

# Auto download from GitHub releases
auto_download_from_github() {
    print_info "Checking GitHub releases for lab files..."
    
    # Check if gh CLI is available
    if command -v gh &> /dev/null; then
        print_info "GitHub CLI detected, attempting auto-download..."
        
        # Get latest release download URL
        RELEASE_URL=$(gh release view --repo qthanh04/tool-script-web-sec --json assets --jq '.assets[0].url' 2>/dev/null)
        
        if [ ! -z "$RELEASE_URL" ] && [ "$RELEASE_URL" != "null" ]; then
            print_info "Found release, downloading..."
            gh release download --repo qthanh04/tool-script-web-sec --pattern "*.tar.gz" --dir ./
            
            # Extract if download successful
            if [ -f *.tar.gz ]; then
                print_info "Extracting lab files..."
                tar -xzf *.tar.gz
                rm *.tar.gz
                print_success "Lab files downloaded and extracted successfully!"
                return 0
            fi
        fi
    fi
    
    print_warning "Auto-download không available hoặc không tìm thấy releases"
    print_info "Please follow manual download options below"
    return 1
}

check_labs_status() {
    if [ ! -d "labs" ]; then
        mkdir -p labs
        print_info "Tạo thư mục labs/"
    fi
    
    LAB_COUNT=$(find labs/ -name "*.lab" 2>/dev/null | wc -l)
    
    if [ "$LAB_COUNT" -gt 0 ]; then
        print_success "Đã có $LAB_COUNT lab files trong thư mục labs/"
        echo ""
        print_info "Bạn có thể sử dụng ngay:"
        echo "1. ./universal_lab_converter.sh    # Convert Student ID"
        echo "2. cp labs/*.lab ~/labtainer_xfer/ # Copy vào Labtainer"
        echo "3. checkwork [lab_names]           # Check grades"
        return 0
    fi
    
    return 1
}

# Main download options
show_download_options() {
    echo -e "${YELLOW}📥 CÁC CÁCH DOWNLOAD LAB FILES${NC}"
    echo ""
    
    echo -e "${GREEN}Option 1: Download from GitHub Releases${NC}"
    echo "   - Check repository releases: https://github.com/qthanh04/tool-script-web-sec/releases"
    echo "   - Download latest owasp-labs-*.tar.gz file"
    echo "   - Extract: tar -xzf owasp-labs-*.tar.gz"
    echo ""
    
    echo -e "${GREEN}Option 2: Contact Repository Owner${NC}"
    echo "   - Create GitHub Issue để request lab files nếu releases không available"
    echo "   - Repository: https://github.com/qthanh04/tool-script-web-sec"
    echo "   - Files có thể được share qua Google Drive hoặc alternative hosting"
    echo ""
    
    echo -e "${GREEN}Option 2: Use Your Original Labs${NC}"
    echo "   - Nếu bạn đã có original lab files từ Labtainer:"
    echo "   - cp /path/to/your/original/*.lab labs/"
    echo "   - ./universal_lab_converter.sh"
    echo ""
    
    echo -e "${GREEN}Option 3: Generate From Individual Scripts${NC}"
    echo "   - Nếu bạn có access to individual lab setups:"
    echo "   - ./scripts/fix_xsite.sh"
    echo "   - ./scripts/fix_sql_inject.sh"
    echo "   - ... (repeat for all 8 labs)"
    echo ""
    
    echo -e "${GREEN}Option 4: Manual Lab Completion${NC}"
    echo "   - Complete labs manually và use scripts để fix grades"
    echo "   - Educational approach: học cách exploit trước"
    echo "   - Sau đó use automation để save time"
    echo ""
}

# Create demo labs structure
create_demo_structure() {
    print_info "Tạo demo structure để test scripts..."
    
    # Create labs directory if not exists
    mkdir -p labs
    
    # Create placeholder files
    cat > labs/README.md << 'EOF'
# 📁 Lab Files Directory

Lab files sẽ được đặt ở đây sau khi download.

## Expected Files:
- S22BA13203.xsite.lab (18.8MB)
- S22BA13203.web-brokenaccess.lab (684KB)  
- S22BA13203.sql-inject.lab (38.7MB)
- S22BA13203.web-inject.lab (475KB)
- S22BA13203.web-insdes.lab (506KB)
- S22BA13203.web-vulcom.lab (491KB)
- S22BA13203.web-xss.lab (72.1MB)
- S22BA13203.web-xxe.lab (351KB)

Total: ~130MB for all 8 labs
EOF

    print_success "Demo structure created!"
}

# Main function
main() {
    print_header
    
    print_info "Kiểm tra status lab files..."
    echo ""
    
    if check_labs_status; then
        exit 0
    fi
    
    print_warning "Lab files chưa có sẵn trong thư mục labs/"
    echo ""
    
    # Try auto-download first
    if auto_download_from_github; then
        print_success "Auto-download thành công!"
        if check_labs_status; then
            exit 0
        fi
    fi
    
    show_download_options
    
    echo ""
    print_info "Tạo demo structure..."
    create_demo_structure
    
    echo ""
    echo -e "${BLUE}================================================${NC}"
    echo -e "${YELLOW}           DOWNLOAD INSTRUCTIONS               ${NC}"
    echo -e "${BLUE}================================================${NC}"
    
    print_info "After downloading lab files:"
    echo "1. Place *.lab files vào thư mục labs/"
    echo "2. Run ./universal_lab_converter.sh"  
    echo "3. Input Student ID mới"
    echo "4. Copy converted labs: cp labs/*.lab ~/labtainer_xfer/"
    echo "5. Check grades: checkwork [lab_names]"
    
    echo ""
    print_success "Repository structure ready! Download lab files để bắt đầu."
}

# Execute main function
main "$@"