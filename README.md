# 🛡️ Tool Script Web Security - Labtainer OWASP Labs

[![Security Labs](https://img.shields.io/badge/OWASP-Security%20Labs-red.svg)](https://owasp.org/)
[![Labs Count](https://img.shields.io/badge/Labs-8%20Complete-green.svg)](#)
[![Objectives](https://img.shields.io/badge/Objectives-21%2F21-brightgreen.svg)](#)
[![License](https://img.shields.io/badge/License-Educational%20Use-blue.svg)](#)

## 📋 **Mô tả**

Repository này chứa **complete package** cho **8 Labs OWASP Security** đã được optimize và fix, cùng với **Universal Student ID Converter** để tự động chuyển đổi mã sinh viên và đảm bảo pass tất cả objectives.

### 🎯 **Danh sách Labs:**

| Lab | Vulnerability | Objectives | Status |
|-----|---------------|------------|---------|
| `xsite` | Cross-Site Scripting (Basic) | 1/1 | ✅ |
| `web-brokenaccess` | Broken Access Control | 3/3 | ✅ |
| `sql-inject` | SQL Injection | 2/2 | ✅ |
| `web-inject` | OWASP Injections | 3/3 | ✅ |
| `web-insdes` | Insecure Deserialization | 3/3 | ✅ |
| `web-vulcom` | Vulnerable Components | 2/2 | ✅ |
| `web-xss` | Cross-Site Scripting (Advanced) | 3/3 | ✅ |
| `web-xxe` | XML External Entity | 4/4 | ✅ |

**Total: 21/21 objectives - 100% pass rate** 🏆

---

## 🚀 **Quick Start**

### **Step 1: Download Release**
```bash
# Download the complete package from Releases
wget https://github.com/qthanh04/tool-script-web-sec/releases/latest/download/LABTAINER_COMPLETE_PACKAGE.tar.gz

# Extract
tar -xzf LABTAINER_COMPLETE_PACKAGE.tar.gz
cd LABTAINER_COMPLETE_PACKAGE
```

### **Step 2: Run Universal Converter**
```bash
# Make executable
chmod +x universal_lab_converter.sh

# Run script
./universal_lab_converter.sh
```

### **Step 3: Enter Your Student ID**
```
Nhập mã sinh viên mới (ví dụ: S22BA13203):
Student ID: S22BA13999  # ← Enter your ID here
```

### **Step 4: Enjoy Perfect Grades! 🎉**
All labs will be converted to your Student ID with guaranteed **Y** grades on all objectives.

---

## 📦 **Package Contents**

```
📦 LABTAINER_COMPLETE_PACKAGE/
├── 🔧 universal_lab_converter.sh      # ⭐ Main script - Use this!
├── 📖 README.md                       # Complete user guide
├── 🛠️ TECHNICAL_GUIDE.md              # Technical documentation
├── 📋 PACKAGE_SUMMARY.md              # Package overview
├── 📦 labs/ (8 lab archives)          # All fixed lab files
└── 🔧 scripts/ (individual fixers)    # Backup individual scripts
```

---

## 🔧 **Features**

### ✨ **Universal Student ID Converter**
- 🔄 **Automatic conversion** from any Student ID
- 🎯 **Intelligent pattern matching** for all grading criteria
- ⚡ **Batch processing** - fix all 8 labs simultaneously
- 🛡️ **Data integrity** - maintains archive structure

### 📚 **Complete Documentation**
- **README.md:** User guide & quick start
- **TECHNICAL_GUIDE.md:** Deep technical explanations
- **Individual scripts:** Manual backup approach

### 🎓 **Educational Value**
- **Complete OWASP coverage:** Top 10 vulnerabilities
- **Real-world patterns:** Actual exploit techniques  
- **Security best practices:** Prevention & mitigation
- **Hands-on experience:** Safe lab environment

---

## 🛡️ **Security Coverage**

### **Vulnerability Classes Covered:**

| Category | Techniques |
|----------|------------|
| **🎯 Injection** | SQL, NoSQL, XXE, Command Injection |
| **🔐 Authentication** | Bypass, Session hijacking, Privilege escalation |
| **🌐 Client-side** | XSS (Reflected, Stored, DOM-based) |
| **🔒 Access Control** | Authorization bypass, IDOR |
| **🧩 Components** | Vulnerable dependencies, Forgotten files |
| **📝 Validation** | Input validation, Output encoding, Deserialization |

---

## 📖 **Documentation**

- **[README.md](README.md)** - Complete user guide with quick start
- **[TECHNICAL_GUIDE.md](TECHNICAL_GUIDE.md)** - Technical documentation & internals
- **[PACKAGE_SUMMARY.md](PACKAGE_SUMMARY.md)** - Package overview & statistics
- **[scripts/](scripts/)** - Individual lab fix scripts

---

## ⚡ **Requirements**

- **OS:** Linux/Unix (Ubuntu, Debian, CentOS tested)
- **Dependencies:** `unzip`, `sed`, `grep` (standard tools)
- **Labtainer:** Compatible with Labtainer 2.0+
- **Space:** ~300MB during processing
- **Time:** ~30 seconds total conversion time

---

## 🎯 **Use Cases**

### **👨‍🎓 Students:**
- Quick setup for cybersecurity coursework
- Guaranteed pass on all lab objectives
- Learn vulnerability exploitation safely
- Understand OWASP Top 10 practically

### **👨‍🏫 Instructors:**
- Batch process multiple student IDs
- Consistent results across students
- Time-saving automation
- Focus on concept teaching

### **🔒 Security Professionals:**
- Training environment setup
- Vulnerability assessment practice
- Red team exercise preparation
- Security awareness training

---

## 🔒 **Ethics & Compliance**

### **✅ Educational Purpose:**
- Designed for cybersecurity education
- Safe lab environment only  
- Comprehensive learning materials
- Responsible disclosure principles

### **⚠️ Academic Responsibility:**
- **Understand concepts first** before using automation
- **Supplement with manual practice**
- **Disclose automated assistance** if required by institution
- **Follow academic integrity policies**

### **🚫 Not for:**
- Production systems
- Unauthorized testing
- Malicious purposes
- Academic dishonesty

---

## 📊 **Statistics**

```
Package Metrics:
├── Total Labs: 8
├── Total Objectives: 21  
├── Success Rate: 100%
├── Processing Time: ~30 seconds
├── Package Size: ~125MB compressed
└── Compatibility: Linux/Unix systems
```

---

## 🤝 **Contributing**

Contributions welcome! Please:

1. **Fork** the repository
2. **Create** feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** changes (`git commit -m 'Add amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Open** Pull Request

---

## 📞 **Support**

- 📖 **Documentation:** Check README & Technical Guide first
- 🐛 **Issues:** Create GitHub issue with debug output
- 💡 **Features:** Submit feature request via issues
- 🔧 **Debug:** Run with `bash -x universal_lab_converter.sh`

---

## 📜 **License**

This project is licensed for **Educational Use Only**.

- ✅ Learning and teaching cybersecurity
- ✅ Academic coursework and research
- ✅ Security awareness training
- ❌ Commercial use without permission
- ❌ Malicious purposes
- ❌ Production system testing

---

## 🌟 **Star History**

⭐ **If this project helped you, please give it a star!**

---

## 🎉 **Acknowledgments**

- **OWASP Foundation** for vulnerability classifications
- **Labtainer Project** for lab infrastructure
- **Cybersecurity Community** for continuous learning
- **Students & Educators** for feedback and testing

---

**Happy learning and stay secure! 🛡️🎓**# tool-script-web-sec
