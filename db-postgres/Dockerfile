FROM postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB app_dev
EXPOSE 5432
COPY init.sql /docker-entrypoint-initdb.d/
COPY --chown=postgres:postgres users.csv.gz /tmp/users.csv.gz
COPY --chown=postgres:postgres posts.csv.gz /tmp/posts.csv.gz
