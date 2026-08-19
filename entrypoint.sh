#!/bin/bash
# ============================================================
# Entrypoint — Projet taaral / Odoo 19
# FIX DÉFINITIF : la config finale est générée dans
# /var/lib/odoo/odoo.conf (volume writable par 'odoo'),
# jamais via `sed -i` sur /etc/odoo (source du 502 précédent).
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

# ── Génération de la config finale ───────────────────────────
# On échappe les caractères spéciaux (/, &, #) pour que sed ne
# casse pas si le mot de passe ou le host en contient.
escape_sed() {
    printf '%s' "$1" | sed -e 's/[\/&#]/\\&/g'
}

DB_HOST_ESC="$(escape_sed "${DB_HOST}")"
DB_USER_ESC="$(escape_sed "${DB_USER}")"
DB_PASSWORD_ESC="$(escape_sed "${DB_PASSWORD}")"

CONF_FILE="/var/lib/odoo/odoo.conf"

echo "🔧 Génération de ${CONF_FILE} depuis le template..."
sed \
    -e "s#\${DB_HOST}#${DB_HOST_ESC}#g" \
    -e "s#\${DB_USER}#${DB_USER_ESC}#g" \
    -e "s#\${DB_PASSWORD}#${DB_PASSWORD_ESC}#g" \
    /etc/odoo/odoo.conf.template > "${CONF_FILE}"

# Le fichier contient le mot de passe DB en clair : on restreint l'accès.
chmod 600 "${CONF_FILE}"

echo "🚀 Démarrage d'Odoo taaral..."
exec odoo --config="${CONF_FILE}" "$@"
