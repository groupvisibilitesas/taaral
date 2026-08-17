# ============================================================
# Projet : taaral — Odoo 19 Community
# Ports internes : 8401 (web) / 8402 (longpolling)
# ============================================================

FROM odoo:19.0

USER root

# Copier les addons custom du repo vers le conteneur
COPY --chown=odoo:odoo . /mnt/extra-addons/

# Supprimer les fichiers de déploiement du dossier addons
RUN rm -rf /mnt/extra-addons/Dockerfile \
           /mnt/extra-addons/docker-compose.yml \
           /mnt/extra-addons/odoo.conf \
           /mnt/extra-addons/entrypoint.sh \
           /mnt/extra-addons/.env.example \
           /mnt/extra-addons/.env \
           /mnt/extra-addons/.gitignore \
           /mnt/extra-addons/README.md \
           /mnt/extra-addons/.git

# Configuration Odoo
COPY --chown=odoo:odoo odoo.conf /etc/odoo/odoo.conf

# Entrypoint personnalisé
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8601
EXPOSE 8602

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
