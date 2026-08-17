#!/bin/bash
# ============================================================
# Entrypoint — Projet taaral / Odoo 19
# Fix: résout les variables d'env dans odoo.conf avant démarrage
# ============================================================
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

# ── FIX CRITIQUE : substituer les variables dans odoo.conf ──
# Les fichiers .conf ne font PAS d'interpolation shell.
# On remplace les placeholders ${...} par les vraies valeurs.
echo "🔧 Configuration de odoo.conf..."
sed -i "s|\${DB_HOST}|${DB_HOST}|g"         /etc/odoo/odoo.conf
sed -i "s|\${DB_USER}|${DB_USER}|g"         /etc/odoo/odoo.conf
sed -i "s|\${DB_PASSWORD}|${DB_PASSWORD}|g" /etc/odoo/odoo.conf

echo "🚀 Démarrage d'Odoo taaral..."
exec "$@"
