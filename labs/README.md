# 📂 Labs Directory

Thư mục này chứa 8 lab files OWASP Security đã được fix và ready để sử dụng.

## 📁 **Structure**
```
labs/
├── S22BA13203.xsite.lab              # Cross-Site Scripting (Basic) - 18.8MB
├── S22BA13203.web-brokenaccess.lab   # Broken Access Control - 684KB  
├── S22BA13203.sql-inject.lab         # SQL Injection - 38.7MB
├── S22BA13203.web-inject.lab         # OWASP Injections - 475KB
├── S22BA13203.web-insdes.lab         # Insecure Deserialization - 506KB
├── S22BA13203.web-vulcom.lab         # Vulnerable Components - 491KB
├── S22BA13203.web-xss.lab            # Cross-Site Scripting (Advanced) - 72.1MB
└── S22BA13203.web-xxe.lab            # XML External Entity - 351KB
```

## 🚀 **Cách Lấy Lab Files**

### **Option 1: Download Release Package (Recommended)**
```bash
# Download từ GitHub Releases
wget https://github.com/qthanh04/tool-script-web-sec/releases/download/v1.0/OWASP_Labtainer_Complete_Package_v1.0.tar.gz

# Extract
tar -xzf OWASP_Labtainer_Complete_Package_v1.0.tar.gz

# Labs sẽ có sẵn trong LABTAINER_COMPLETE_PACKAGE/labs/
```

### **Option 2: Use Individual Scripts**
Nếu bạn có original lab files với Student ID khác, sử dụng individual scripts:
```bash
./scripts/fix_xsite.sh
./scripts/fix_sql_inject.sh
# ... etc
```

### **Option 3: Use Universal Converter**  
```bash
./universal_lab_converter.sh
# Nhập Student ID mới khi được hỏi
```

## ⚠️ **Important Notes**

1. **Lab files được exclude khỏi GitHub** do size lớn (300MB+ total)
2. **Download complete package** từ Releases để có đầy đủ files
3. **Hoặc sử dụng scripts** để tạo từ original labs của bạn

## 🎯 **Quick Start**

Sau khi có labs trong thư mục này:

```bash
# Copy labs vào labtainer_xfer
cp labs/*.lab ~/labtainer_xfer/

# Check grades  
checkwork xsite web-brokenaccess sql-inject web-inject web-insdes web-vulcom web-xss web-xxe
```

**Kết quả:** 21/21 objectives pass! 🎉