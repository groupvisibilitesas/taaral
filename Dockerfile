# ============================================================
# Projet : Odoo Community
# Ports internes : 8204 (web) / 8204 (longpolling)
# ============================================================

FROM odoo:19.0

USER root

# Copier tous les addons custom du repo
COPY --chown=odoo:odoo . /mnt/extra-addons/

# Nettoyer les fichiers de déploiement du dossier addons
RUN rm -rf /mnt/extra-addons/Dockerfile            /mnt/extra-addons/docker-compose.yml            /mnt/extra-addons/odoo.conf            /mnt/extra-addons/entrypoint.sh            /mnt/extra-addons/.env.example            /mnt/extra-addons/.env            /mnt/extra-addons/.gitignore            /mnt/extra-addons/README.md            /mnt/extra-addons/.git

# Configuration Odoo
COPY --chown=odoo:odoo odoo.conf /etc/odoo/odoo.conf

# Entrypoint personnalisé (attend PostgreSQL)
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8401
EXPOSE 8402

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
