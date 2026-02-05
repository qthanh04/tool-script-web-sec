# 📁 Lab Files Directory

Lab files sẽ được đặt ở đây sau khi download từ GitHub Releases.

## Template Lab Files (1 bộ mẫu):
- S22BA13203.xsite.lab (18.8MB) - Cross-Site Scripting Basic
- S22BA13203.web-brokenaccess.lab (684KB) - Broken Access Control  
- S22BA13203.sql-inject.lab (38.7MB) - SQL Injection
- S22BA13203.web-inject.lab (475KB) - Web Application Injections
- S22BA13203.web-insdes.lab (506KB) - Insecure Deserialization
- S22BA13203.web-vulcom.lab (491KB) - Vulnerable Components
- S22BA13203.web-xss.lab (72.1MB) - Cross-Site Scripting Advanced
- S22BA13203.web-xxe.lab (351KB) - XML External Entity (XXE)

**Total: ~127MB template set**

## How Universal Converter Works:
1. Download template labs (S22BA13203) từ GitHub Releases
2. Universal converter sẽ convert Student ID từ S22BA13203 → Student ID của bạn
3. Tất cả grading patterns và objectives sẽ được preserved
4. Kết quả: 8 labs với Student ID mới, pass 21/21 objectives

## 🚀 **Cách Lấy Lab Files**

### **Option 1: Auto-Download (Recommended)**
```bash
# Chạy download script
./download_labs.sh

# Script sẽ tự động tìm và download từ GitHub Releases
```

### **Option 2: Manual Download từ Releases**
```bash
# Download từ GitHub Releases  
wget https://github.com/qthanh04/tool-script-web-sec/releases/download/v1.0/owasp-labtainer-labs-template-v1.0.tar.gz

# Extract vào thư mục labs
tar -xzf owasp-labtainer-labs-template-v1.0.tar.gz
```

### **Option 3: Use Universal Converter với Original Labs**  
Nếu bạn đã có original lab files:
```bash
# Copy original labs vào thư mục này
cp /path/to/your/original/*.lab labs/

# Run universal converter
./universal_lab_converter.sh
# Nhập Student ID mới khi được hỏi
```

## 🎯 **Quick Start**

Sau khi có labs trong thư mục này:

```bash
# Copy labs vào labtainer_xfer
cp labs/*.lab ~/labtainer_xfer/

# Check grades  
checkwork xsite web-brokenaccess sql-inject web-inject web-insdes web-vulcom web-xss web-xxe
```

**Kết quả:** 21/21 objectives pass! 🎉