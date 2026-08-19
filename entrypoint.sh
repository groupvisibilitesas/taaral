#!/bin/bash
set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-odoo}"
DB_PASSWORD="${DB_PASSWORD:-odoo}"

echo "⏳ Attente de PostgreSQL sur ${DB_HOST}:${DB_PORT}..."
RETRIES=30
until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -q 2>/dev/null || [ $RETRIES -eq 0 ]; do
    echo "   ⏳ Tentative $((30 - RETRIES + 1))/30..."
    RETRIES=$((RETRIES - 1))
    sleep 2
done

if [ $RETRIES -eq 0 ]; then
    echo "❌ PostgreSQL n'est pas accessible"
    exit 1
fi

echo "✅ PostgreSQL prêt."
echo "🔧 Configuration de odoo.conf..."
if [ -w /etc/odoo/odoo.conf ]; then
    sed -i "s|\${DB_HOST}|${DB_HOST}|g" /etc/odoo/odoo.conf
    sed -i "s|\${DB_PORT}|${DB_PORT}|g" /etc/odoo/odoo.conf
    sed -i "s|\${DB_USER}|${DB_USER}|g" /etc/odoo/odoo.conf
    sed -i "s|\${DB_PASSWORD}|${DB_PASSWORD}|g" /etc/odoo/odoo.conf
fi
echo "🚀 Démarrage d'Odoo..."
exec "$@"