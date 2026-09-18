#!/bin/bash

# ==========================================================
# UDOM ONLINE QUIZ SYSTEM
# AUTOMATIC SETUP SCRIPT
# ==========================================================

set -e

# ==========================================================
# CONFIGURATION
# ==========================================================

DB_NAME="online_quiz_db"
DB_USER="admin"
DB_PASSWORD="admin"
DB_HOST="localhost"
DB_PORT="5432"

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

DATABASE_DUMP="$PROJECT_DIR/database/online_quiz_full.sql"

TOMCAT_DIR="/opt/tomcat"
WAR_NAME="online-quiz-system.war"

echo ""
echo "=========================================================="
echo "        UDOM ONLINE QUIZ SYSTEM SETUP"
echo "=========================================================="
echo ""

echo "Project directory:"
echo "$PROJECT_DIR"
echo ""

# ==========================================================
# ROOT CHECK
# ==========================================================

if [ "$EUID" -ne 0 ]; then

    echo "ERROR: This script must be run with sudo."
    echo ""
    echo "Use:"
    echo ""
    echo "sudo ./setup/setup.sh"
    echo ""

    exit 1
fi

# ==========================================================
# CHECK POSTGRESQL
# ==========================================================

echo "[1/7] Checking PostgreSQL..."

if ! command -v psql >/dev/null 2>&1; then

    echo ""
    echo "PostgreSQL is not installed."
    echo ""
    echo "Install it using:"
    echo ""
    echo "apt update"
    echo "apt install postgresql postgresql-contrib"
    echo ""

    exit 1
fi

if ! systemctl is-active --quiet postgresql; then

    echo "PostgreSQL is not running."
    echo "Starting PostgreSQL..."

    systemctl start postgresql

fi

echo "PostgreSQL is running."
echo ""

# ==========================================================
# CREATE DATABASE USER
# ==========================================================

echo "[2/7] Creating/checking PostgreSQL user..."

sudo -u postgres psql <<EOF
DO \$\$
BEGIN

    IF NOT EXISTS (
        SELECT FROM pg_roles
        WHERE rolname = '$DB_USER'
    ) THEN

        CREATE ROLE $DB_USER
        LOGIN
        PASSWORD '$DB_PASSWORD';

    ELSE

        ALTER ROLE $DB_USER
        WITH LOGIN
        PASSWORD '$DB_PASSWORD';

    END IF;

END
\$\$;
EOF

echo "PostgreSQL user '$DB_USER' is ready."
echo ""

# ==========================================================
# CREATE DATABASE
# ==========================================================

echo "[3/7] Creating/checking database..."

DB_EXISTS=$(sudo -u postgres psql -tAc \
    "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'")

if [ "$DB_EXISTS" != "1" ]; then

    echo "Creating database '$DB_NAME'..."

    sudo -u postgres createdb \
        -O "$DB_USER" \
        "$DB_NAME"

else

    echo "Database '$DB_NAME' already exists."

fi

echo ""

# ==========================================================
# DATABASE OWNER
# ==========================================================

echo "Setting database owner..."

sudo -u postgres psql -c \
    "ALTER DATABASE $DB_NAME OWNER TO $DB_USER;"

echo ""

# ==========================================================
# CHECK DATABASE DUMP
# ==========================================================

echo "[4/7] Checking database dump..."

if [ ! -f "$DATABASE_DUMP" ]; then

    echo ""
    echo "ERROR: Database dump not found:"
    echo "$DATABASE_DUMP"
    echo ""

    exit 1
fi

echo "Database dump found:"
echo "$DATABASE_DUMP"
echo ""

# ==========================================================
# RESTORE DATABASE
# ==========================================================

echo "[5/7] Restoring database..."

echo ""
echo "WARNING:"
echo "The database will be restored from:"
echo "$DATABASE_DUMP"
echo ""

# ----------------------------------------------------------
# Determine whether database already contains tables
# ----------------------------------------------------------

TABLE_COUNT=$(sudo -u postgres psql \
    -d "$DB_NAME" \
    -tAc \
    "SELECT COUNT(*) FROM information_schema.tables
     WHERE table_schema='public'")

if [ "$TABLE_COUNT" -gt 0 ]; then

    echo "Existing public tables detected: $TABLE_COUNT"

    echo "Skipping database restore."

    echo "Existing database will not be overwritten."

else

    echo "Database is empty."
    echo "Importing database dump..."

    sudo -u postgres psql \
        -d "$DB_NAME" \
        -f "$DATABASE_DUMP"

    echo ""
    echo "Database restored successfully."

fi

echo ""

# ==========================================================
# VERIFY TABLES
# ==========================================================

echo "Verifying database..."

FINAL_TABLE_COUNT=$(sudo -u postgres psql \
    -d "$DB_NAME" \
    -tAc \
    "SELECT COUNT(*) FROM information_schema.tables
     WHERE table_schema='public'")

echo ""
echo "Public tables found: $FINAL_TABLE_COUNT"
echo ""

if [ "$FINAL_TABLE_COUNT" -ne 12 ]; then

    echo "WARNING:"
    echo "Expected 12 tables."
    echo "Found $FINAL_TABLE_COUNT tables."

else

    echo "All 12 project tables are available."

fi

echo ""

# ==========================================================
# BUILD MAVEN PROJECT
# ==========================================================

echo "[6/7] Building Java application..."

cd "$PROJECT_DIR"

if ! command -v mvn >/dev/null 2>&1; then

    echo ""
    echo "Maven is not installed."
    echo ""
    echo "Install it using:"
    echo ""
    echo "apt install maven"
    echo ""

    exit 1
fi

mvn clean package

echo ""
echo "Maven build completed."
echo ""

# ==========================================================
# DEPLOY TO TOMCAT
# ==========================================================

echo "[7/7] Deploying application to Tomcat..."

if [ ! -d "$TOMCAT_DIR" ]; then

    echo ""
    echo "ERROR: Tomcat was not found at:"
    echo "$TOMCAT_DIR"
    echo ""

    exit 1
fi

WAR_FILE="$PROJECT_DIR/target/$WAR_NAME"

if [ ! -f "$WAR_FILE" ]; then

    echo ""
    echo "ERROR: WAR file was not generated:"
    echo "$WAR_FILE"
    echo ""

    exit 1
fi

echo "Stopping Tomcat..."

"$TOMCAT_DIR/bin/shutdown.sh" \
    >/dev/null 2>&1 || true

sleep 3

echo "Removing previous deployment..."

rm -rf \
    "$TOMCAT_DIR/webapps/online-quiz-system"

rm -f \
    "$TOMCAT_DIR/webapps/online-quiz-system.war"

echo "Installing new WAR..."

cp "$WAR_FILE" \
   "$TOMCAT_DIR/webapps/$WAR_NAME"

echo "Starting Tomcat..."

"$TOMCAT_DIR/bin/startup.sh"

echo ""
echo "=========================================================="
echo "             SETUP COMPLETED"
echo "=========================================================="
echo ""

echo "Database"
echo "--------------------------------"
echo "Name:     $DB_NAME"
echo "User:     $DB_USER"
echo "Host:     $DB_HOST"
echo "Port:     $DB_PORT"
echo ""

echo "Application"
echo "--------------------------------"
echo "http://localhost:8080/online-quiz-system/"
echo ""

echo "=========================================================="
echo ""
