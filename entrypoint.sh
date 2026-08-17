#!/bin/bash
set -e

DB_HOST="${HOST:-${DB_HOST:-localhost}}"
DB_PORT="${PORT:-${DB_PORT:-5432}}"
DB_USER="${USER:-${DB_USER:-odoo_taaral}}"
DB_PASSWORD="${PASSWORD:-${DB_PASSWORD}}"

echo "⏳ Attente de PostgreSQL sur ${DB_HOST}:${DB_PORT}..."
until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -q 2>/dev/null; do
    echo "   non disponible, nouvelle tentative dans 3s..."
    sleep 3
done
echo "✅ PostgreSQL prêt."

echo "🔧 Génération de odoo.conf..."
CONF_FILE="/var/lib/odoo/odoo.conf"
sed \
  -e "s|\${DB_HOST}|${DB_HOST}|g" \
  -e "s|\${DB_USER}|${DB_USER}|g" \
  -e "s|\${DB_PASSWORD}|${DB_PASSWORD}|g" \
  /etc/odoo/odoo.conf > "${CONF_FILE}"

echo "🚀 Démarrage d'Odoo taaral..."
exec odoo --config="${CONF_FILE}"