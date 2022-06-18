ARG WODBY_BASE_IMAGE
FROM ${WODBY_BASE_IMAGE}

ARG COPY_FROM
COPY --chown=wodby:wodby ${COPY_FROM} /var/www/html

RUN mkdir -p \
        /var/www/html/tmp/assets \
        /var/www/html/tmp/cache \
        /var/www/html/tmp/cache/tracker \
        /var/www/html/tmp/climulti \
        /var/www/html/tmp/latest \
        /var/www/html/tmp/logs \
        /var/www/html/tmp/sessions \
        /var/www/html/tmp/tcpdf \
        /var/www/html/tmp/templates_c; \
    \
    chown :www-data \
        /var/www/html/misc/user \
        /var/www/html/config \
        /var/www/html/piwik.js; \
    chmod 775 \
        /var/www/html/misc/user \
        /var/www/html/config \
        /var/www/html/piwik.js; \
    \
    chown -R :www-data \
        /var/www/html/tmp \
        /var/www/html/plugins; \
    chmod -R 775 \
        /var/www/html/tmp \
        /var/www/html/plugins; \
    \
    chown www-data:www-data /var/www/html/matomo.js; \
    chown wodby:www-data /var/www/html/config/config.ini.php; \
    chmod 664 /var/www/html/config/config.ini.php
        
