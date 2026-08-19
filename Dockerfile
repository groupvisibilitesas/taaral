# ============================================================
# Projet : taaral — Odoo 19 Community
# Ports internes : 8601 (web) / 8602 (longpolling)
# ============================================================

FROM odoo:19.0

USER root

# Copier les addons custom du repo
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

# Entrypoint corrigé
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Créer le répertoire de logs (absent dans certaines images Odoo 19)
RUN mkdir -p /var/log/odoo && chown odoo:odoo /var/log/odoo

EXPOSE 8601
EXPOSE 8602

VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]


ENTRYPOINT ["/entrypoint.sh"]
# CMD ["odoo", "--config=/etc/odoo/odoo.conf"]
CMD []