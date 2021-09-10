FROM python:3.9-alpine

LABEL "maintainer"="Patrick Jahns <github@patrickjahns.de>" \
      "repository"="https://github.com/patrickjahns/ansible-later-action" \
      "homepage"="https://github.com/patrickjahns/ansible-later-action" \
      "com.github.actions.name"="ansible-later" \
      "com.github.actions.description"="Run ansible-later" \
      "com.github.actions.icon"="check-circle" \
      "com.github.actions.color"="orange"
COPY requirements.txt /tmp/requirements.txt
RUN apk --no-cache add --virtual .build-deps build-base libffi-dev libressl-dev && \
    apk --no-cache add git bash && \
    pip install --upgrade --no-cache-dir pip && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache/

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]