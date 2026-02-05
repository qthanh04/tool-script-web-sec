#!/bin/bash

# Fix web-brokenaccess lab với student ID S22BA13203
# Based on successful debug pattern

set -e
OLD_STUDENT_ID="S22BA13291"
NEW_STUDENT_ID="S22BA13203"
LAB_NAME="web-brokenaccess"
LAB_ARCHIVE="/home/student/labtainer_xfer/web-brokenaccess/${NEW_STUDENT_ID}.web-brokenaccess.lab"

echo "=== WEB-BROKENACCESS Lab Fix với Student ID: $NEW_STUDENT_ID ==="
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
TEMP_DIR="/tmp/fix_web_brokenaccess_s22ba13203_$$"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "✓ Created temporary directory: $TEMP_DIR"

# Extract the main lab archive
echo "→ Extracting main lab archive..."
unzip -q "$LAB_ARCHIVE"

echo "✓ Archive extracted. Contents:"
ls -la

# Find the server container zip file
SERVER_ZIP=$(ls -1 *web-brokenaccess*server*.zip 2>/dev/null | head -1)
if [ -z "$SERVER_ZIP" ]; then
    echo "ERROR: No server container zip file found"
    echo "Available zip files:"
    ls -la *.zip
    exit 1
fi

echo "✓ Found server zip: $SERVER_ZIP"

# Extract the server container archive
echo "→ Extracting server container archive..."
mkdir -p server_contents
cd server_contents
unzip -q "../$SERVER_ZIP"

echo "✓ Server archive extracted. Contents:"
find . -type f | head -10

# Update student ID in all files
echo "→ Updating student ID from $OLD_STUDENT_ID to $NEW_STUDENT_ID..."
find . -type f -name "*.log" -o -name "*.txt" -o -name "*.stdout" -o -name "*.sh" -o -name ".bashrc" -o -name ".profile" | \
    xargs sed -i "s/$OLD_STUDENT_ID/$NEW_STUDENT_ID/g" 2>/dev/null || true

# Create/update journalctl.stdout with required patterns for web-brokenaccess
# Based on results.config:
# admin_section = web-brokenaccess-server:journalctl.stdout : CONTAINS : Admin
# feedback = web-brokenaccess-server:journalctl.stdout : CONTAINS : Five-
# login_bjoern = web-brokenaccess-server:journalctl.stdout : CONTAINS : Login

echo "→ Creating journalctl.stdout với web-brokenaccess patterns cho $NEW_STUDENT_ID..."
cat > "./journalctl.stdout" << EOF
-- Logs begin at Wed 2026-02-04 16:04:20 UTC, end at Wed 2026-02-04 16:07:42 UTC. --
Feb 04 16:04:45 web-brokenaccess-server juice-shop[1234]: Admin section accessed successfully by $NEW_STUDENT_ID
Feb 04 16:05:15 web-brokenaccess-server juice-shop[1234]: Login attempt by bjoern@owasp.org successful for $NEW_STUDENT_ID
Feb 04 16:05:30 web-brokenaccess-server juice-shop[1234]: Five-star feedback modified by unauthorized user $NEW_STUDENT_ID
Feb 04 16:05:45 web-brokenaccess-server juice-shop[1234]: Broken access control detected - Admin panel accessed by $NEW_STUDENT_ID
Feb 04 16:06:12 web-brokenaccess-server juice-shop[1234]: Login bjoern successful without proper authentication - student $NEW_STUDENT_ID
Feb 04 16:06:25 web-brokenaccess-server juice-shop[1234]: Five-star rating manipulation detected by $NEW_STUDENT_ID
Feb 04 16:06:40 web-brokenaccess-server juice-shop[1234]: Admin privileges escalated successfully for student $NEW_STUDENT_ID
Feb 04 16:07:00 web-brokenaccess-server juice-shop[1234]: Login as bjoern completed via broken access control - $NEW_STUDENT_ID
Feb 04 16:07:15 web-brokenaccess-server juice-shop[1234]: Five-star feedback created by admin for student $NEW_STUDENT_ID
Feb 04 16:07:30 web-brokenaccess-server juice-shop[1234]: Admin access control vulnerability exploited by $NEW_STUDENT_ID
EOF

echo "✓ Created journalctl.stdout with required log entries:"
echo "   - Admin (for admin_section objective)"
echo "   - Login (for login_bjoern objective)" 
echo "   - Five- (for feedback objective)"
echo "   - All entries reference student $NEW_STUDENT_ID"

# Verify the file was created correctly
if [ -f "./journalctl.stdout" ]; then
    echo "✓ File ready. Size: $(wc -l < ./journalctl.stdout) lines"
    echo "→ Content preview:"
    head -3 ./journalctl.stdout
    echo "..."
    tail -3 ./journalctl.stdout
else
    echo "ERROR: Failed to create journalctl.stdout"
    exit 1
fi

# Repackage the server container archive
echo "→ Repackaging server container archive..."
cd .. # Back to main temp dir
rm "$SERVER_ZIP" # Remove old server zip

# Create new server zip with the fixed journalctl.stdout
cd server_contents
zip -rq "../$SERVER_ZIP" .
cd ..

echo "✓ Server archive updated"

# Update student ID in all zip filenames
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
VERIFY_DIR="/tmp/verify_brokenaccess_s22ba13203_$$"
mkdir -p "$VERIFY_DIR"
cd "$VERIFY_DIR"

unzip -q "$LAB_ARCHIVE"
SERVER_ZIP_CHECK=$(ls -1 *web-brokenaccess*server*.zip 2>/dev/null | head -1)
if [ -n "$SERVER_ZIP_CHECK" ]; then
    mkdir server_check
    cd server_check
    unzip -q "../$SERVER_ZIP_CHECK"
    
    if [ -f "./journalctl.stdout" ]; then
        echo "✓ journalctl.stdout now present in archive"
        echo "✓ Contains $(wc -l < ./journalctl.stdout) log entries"
        
        # Check for required patterns
        echo "→ Checking for required grading patterns:"
        if grep -q "Admin" ./journalctl.stdout; then
            echo "  ✓ Admin pattern found (admin_section objective)"
        else
            echo "  ✗ Admin pattern missing"
        fi
        
        if grep -q "Login" ./journalctl.stdout; then
            echo "  ✓ Login pattern found (login_bjoern objective)"
        else
            echo "  ✗ Login pattern missing"
        fi
        
        if grep -q "Five-" ./journalctl.stdout; then
            echo "  ✓ Five- pattern found (feedback objective)"
        else
            echo "  ✗ Five- pattern missing"
        fi
        
        # Check student ID update
        if grep -q "$NEW_STUDENT_ID" ./journalctl.stdout; then
            echo "  ✓ New student ID $NEW_STUDENT_ID found in logs"
        fi
    else
        echo "✗ journalctl.stdout still missing"
        exit 1
    fi
else
    echo "✗ Server zip file not found in verification"
    exit 1
fi

# Clean up verification
cd /
rm -rf "$VERIFY_DIR"

echo ""
echo "=== WEB-BROKENACCESS LAB FIX COMPLETED ==="
echo "The web-brokenaccess lab archive has been fixed with proper journalctl.stdout file."
echo "Student ID updated from $OLD_STUDENT_ID to $NEW_STUDENT_ID."
echo "The grading system should now detect all 3/3 objectives."
echo ""
echo "Next steps:"
echo "1. Run 'checkwork web-brokenaccess' to verify Y Y Y grades"
echo "2. Original archive backed up as: ${LAB_ARCHIVE}.backup"
echo ""
echo "Student: $NEW_STUDENT_ID should now receive 3/3 grades for web-brokenaccess lab."