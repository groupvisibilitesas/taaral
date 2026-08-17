#!/bin/bash
# ============================================================
# Entrypoint — Projet taaral / Odoo 19
# Attente PostgreSQL + lancement Odoo
# ============================================================
set -e

DB_HOST="${HOST:-${DB_HOST:-localhost}}"
DB_PORT="${PORT:-${DB_PORT:-5432}}"
DB_USER="${USER:-${DB_USER:-odoo_taaral}}"

echo "⏳ Attente de PostgreSQL sur ${DB_HOST}:${DB_PORT}..."
until pg_isready -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -q 2>/dev/null; do
    echo "   non disponible, nouvelle tentative dans 3s..."
    sleep 3
done
echo "✅ PostgreSQL prêt."

echo "🚀 Démarrage d'Odoo taaral..."
exec "$@"