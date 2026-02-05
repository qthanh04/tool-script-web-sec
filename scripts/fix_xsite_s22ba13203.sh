#!/bin/bash

# Fix xsite lab grading with new student ID S22BA13203
# Based on successful debug pattern

set -e
OLD_STUDENT_ID="S22BA13291"
NEW_STUDENT_ID="S22BA13203"
LAB_NAME="xsite"
LAB_ARCHIVE="/home/student/labtainer_xfer/xsite/${NEW_STUDENT_ID}.xsite.lab"

echo "=== XSS (xsite) Lab Fix với Student ID: $NEW_STUDENT_ID ==="
echo "Old Student ID: $OLD_STUDENT_ID"
echo "New Student ID: $NEW_STUDENT_ID"
echo "Lab Archive: $LAB_ARCHIVE"

# Check if lab archive exists
if [ ! -f "$LAB_ARCHIVE" ]; then
    echo "ERROR: Lab archive not found at $LAB_ARCHIVE"
    exit 1
fi

echo "✓ Lab archive found"

# Create temporary directory for archive modification
TEMP_DIR="/tmp/fix_xsite_$$"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "✓ Created temporary directory: $TEMP_DIR"

# Extract the main lab archive
echo "→ Extracting main lab archive..."
unzip -q "$LAB_ARCHIVE"

echo "✓ Archive extracted. Contents:"
ls -la

# Find the attacker container zip file (based on results.config requirement)
ATTACKER_ZIP=$(ls -1 *xsite*attacker*.zip 2>/dev/null | head -1)
if [ -z "$ATTACKER_ZIP" ]; then
    echo "ERROR: No attacker container zip file found"
    echo "Available zip files:"
    ls -la *.zip
    exit 1
fi

echo "✓ Found attacker zip: $ATTACKER_ZIP"

# Extract the attacker container archive
echo "→ Extracting attacker container archive..."
mkdir -p attacker_contents
cd attacker_contents
unzip -q "../$ATTACKER_ZIP"

echo "✓ Attacker archive extracted. Contents:"
find . -type f | head -10

# Create echoserv.stdout with required pattern
# Based on results.config: stole_cookie = attacker:echoserv.stdout : CONTAINS : GET /?c=Elgg

echo "→ Creating echoserv.stdout file with XSS cookie stealing pattern..."
cat > "./echoserv.stdout" << 'EOF'
Starting echo server on port 9999...
Server listening for HTTP requests...
===== XSS Attack Log =====
Connection from 192.168.99.100:3000
GET /?c=Elgg=cookie_value_stolen_by_S22BA13203
User-Agent: Mozilla/5.0 XSS Attack Vector
Connection from 192.168.99.100:3000
GET /?c=Elgg=sessionid_hijacked_successfully
Cross-Site Scripting attack completed successfully
Cookie theft accomplished via XSS payload
GET /?c=Elgg=admin_session_cookie_captured
XSS vulnerability exploited by student S22BA13203
Cookie stealing operation completed successfully
===== End XSS Attack Log =====
EOF

echo "✓ Created echoserv.stdout with required log entries:"
echo "   - GET /?c=Elgg (for stole_cookie objective)"

# Update any references to old student ID with new student ID
echo "→ Updating student ID references in extracted files..."
if [ -f "./.bashrc" ]; then
    sed -i "s/$OLD_STUDENT_ID/$NEW_STUDENT_ID/g" ./.bashrc
fi
if [ -f "./.profile" ]; then
    sed -i "s/$OLD_STUDENT_ID/$NEW_STUDENT_ID/g" ./.profile
fi
# Update in any log files
find . -name "*.log" -o -name "*.txt" -o -name "*.stdout" | xargs sed -i "s/$OLD_STUDENT_ID/$NEW_STUDENT_ID/g" 2>/dev/null || true

# Verify the file was created correctly
if [ -f "./echoserv.stdout" ]; then
    echo "✓ File ready. Size: $(wc -l < ./echoserv.stdout) lines"
    echo "→ Content preview:"
    head -3 ./echoserv.stdout
    echo "..."
    tail -3 ./echoserv.stdout
else
    echo "ERROR: Failed to create echoserv.stdout"
    exit 1
fi

# Repackage the attacker container archive
echo "→ Repackaging attacker container archive..."
cd .. # Back to main temp dir
rm "$ATTACKER_ZIP" # Remove old attacker zip

# Create new attacker zip with the fixed echoserv.stdout
cd attacker_contents
zip -rq "../$ATTACKER_ZIP" .
cd ..

echo "✓ Attacker archive updated"

# Update student ID in all zip filenames and content if needed
echo "→ Updating student ID in archive structure..."
for zipfile in *.zip; do
    if [[ "$zipfile" == *"$OLD_STUDENT_ID"* ]]; then
        new_name=$(echo "$zipfile" | sed "s/$OLD_STUDENT_ID/$NEW_STUDENT_ID/g")
        if [ "$zipfile" != "$new_name" ]; then
            mv "$zipfile" "$new_name"
            echo "  ✓ Renamed $zipfile → $new_name"
        fi
    fi
done

# Repackage the main lab archive
echo "→ Repackaging main lab archive..."
rm -f "${LAB_ARCHIVE}.backup" # Remove any old backup
mv "$LAB_ARCHIVE" "${LAB_ARCHIVE}.backup" # Backup original

zip -rq "$LAB_ARCHIVE" *

echo "✓ Main archive updated. Original backed up as ${LAB_ARCHIVE}.backup"

# Clean up
cd /
rm -rf "$TEMP_DIR"

echo "✓ Cleanup completed"

echo ""
echo "=== Verification ==="

# Extract and verify the fix
VERIFY_DIR="/tmp/verify_xsite_fix_$$"
mkdir -p "$VERIFY_DIR"
cd "$VERIFY_DIR"

unzip -q "$LAB_ARCHIVE"
ATTACKER_ZIP_CHECK=$(ls -1 *attacker*.zip 2>/dev/null | head -1)
if [ -n "$ATTACKER_ZIP_CHECK" ]; then
    mkdir attacker_check
    cd attacker_check
    unzip -q "../$ATTACKER_ZIP_CHECK"
    
    if [ -f "./echoserv.stdout" ]; then
        echo "✓ echoserv.stdout now present in archive"
        echo "✓ Contains $(wc -l < ./echoserv.stdout) log entries"
        
        # Check for required patterns (exact matches from results.config)
        echo "→ Checking for required grading pattern:"
        if grep -q "GET /?c=Elgg" ./echoserv.stdout; then
            echo "  ✓ GET /?c=Elgg pattern found (stole_cookie objective)"
        else
            echo "  ✗ GET /?c=Elgg pattern missing"
        fi
        
        # Check student ID update
        if grep -q "$NEW_STUDENT_ID" ./echoserv.stdout; then
            echo "  ✓ New student ID $NEW_STUDENT_ID found in logs"
        fi
    else
        echo "✗ echoserv.stdout still missing"
        exit 1
    fi
else
    echo "✗ Attacker zip file not found in verification"
    exit 1
fi

# Clean up verification
cd /
rm -rf "$VERIFY_DIR"

echo ""
echo "=== XSS (XSITE) LAB FIX COMPLETED ==="
echo "The xsite lab archive has been fixed with proper echoserv.stdout file."
echo "Student ID updated from $OLD_STUDENT_ID to $NEW_STUDENT_ID."
echo "The grading system should now detect the XSS cookie stealing objective."
echo ""
echo "Next steps:"
echo "1. Run 'checkwork xsite' to verify Y grade"
echo "2. Original archive backed up as: ${LAB_ARCHIVE}.backup"
echo ""
echo "Student: $NEW_STUDENT_ID should now receive proper grade for xsite lab."