# 📥 Request Lab Files

## Issue Template cho Users

### **Problem:**
Lab files (.lab archives) không được include trong GitHub repository do size constraints (130MB+ total). Users need access to these files để sử dụng Universal Converter.

### **Solutions Available:**

#### **Option 1: Contact Repository Owner (Recommended)**
- **Create GitHub Issue** với template này
- **Title:** "Request Lab Files Access - [Your Student ID]"  
- **Body:** Include Student ID format bạn cần và use case
- **Response:** Lab files sẽ được share qua Google Drive/cloud storage

#### **Option 2: Use Original Labs** 
- Nếu bạn đã have access to original Labtainer labs
- Copy files vào `labs/` directory và run Universal Converter
- Most efficient nếu bạn đã có labs từ coursework

#### **Option 3: Manual Completion + Automation**
- Complete labs manually để learn concepts
- Use scripts để fix grades after understanding vulnerabilities  
- Educational approach: học trước → automate sau

#### **Option 4: Individual Lab Scripts**
- Sử dụng `scripts/` directory cho từng lab riêng lẻ
- Fix grades cho labs bạn đã complete manually
- Good for targeted fixes thay vì batch processing

### **Repository Structure:**
```
tool-script-web-sec/
├── download_labs.sh          # ← Run this để check options
├── universal_lab_converter.sh # ← Main automation tool  
├── setup.sh                  # ← Environment checker
├── scripts/                  # ← Individual lab fixers
└── labs/                     # ← Lab files go here
```

### **Quick Test:**
```bash
git clone https://github.com/qthanh04/tool-script-web-sec.git
cd tool-script-web-sec
./setup.sh                   # Check environment
./download_labs.sh           # See download options
```

### **Educational Note:**
Tool này designed for educational purposes. Best practice: understand vulnerabilities trước khi use automation. Labs provide hands-on experience với OWASP Top 10 security issues.

---

**🎯 Ready để request lab files? Create GitHub Issue hoặc contact repository owner!**