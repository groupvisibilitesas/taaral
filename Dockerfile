FROM odoo:19.0

LABEL maintainer="your@email.com"
LABEL odoo.version="19.0"

# ── Passage en root pour les modifications système ─────────
USER root

# ── Répertoire pour les modules custom ────────────────────
RUN mkdir -p /mnt/extra-addons \
    && chown -R odoo:odoo /mnt/extra-addons

# ── Configuration Odoo ────────────────────────────────────
COPY --chown=odoo:odoo odoo.conf /etc/odoo/odoo.conf
RUN chmod 644 /etc/odoo/odoo.conf

# ── Entrypoint personnalisé (attend PostgreSQL) ───────────
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# ── Ports internes uniquement ─────────────────────────────
EXPOSE 8069
EXPOSE 8072

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# ✅ PAS DE "USER odoo" ICI !
# L'entrypoint s'exécute en tant que root (nécessaire pour sed)

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo", "--config=/etc/odoo/odoo.conf"]