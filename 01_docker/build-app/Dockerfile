FROM python:3.6

ENV ODOO_URL="odoo.com"
ENV PGADMIN_URL="pgadmin.org"

WORKDIR /opt

RUN apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install --no-install-recommends -y git curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/eazytraining/projet-fils-rouge /opt/ \
    && rm -rf jenkins-tools releases.txt README.md *.pdf .git \
    && pip3 install flask

EXPOSE 8080

ENTRYPOINT ["python", "app.py"]
