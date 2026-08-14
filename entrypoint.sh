#!/bin/bash
# Entrypoint : attend PostgreSQL avant de démarrer Odoo

set -e

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_USER="${DB_USER:-odoo_taaral}"

echo "⏳ Attente de PostgreSQL sur ${DB_HOST}:${DB_PORT}..."
until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -q 2>/dev/null; do
    echo "   non disponible, nouvelle tentative dans 3s..."
    sleep 3
done
echo "✅ PostgreSQL prêt — démarrage d'Odoo taaral..."

exec "$@"
