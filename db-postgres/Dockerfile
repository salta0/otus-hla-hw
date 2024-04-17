FROM postgres
ENV POSTGRES_PASSWORD password
ENV POSTGRES_DB app_dev
EXPOSE 5432
COPY init.sql /docker-entrypoint-initdb.d/
