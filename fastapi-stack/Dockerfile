FROM docker:25-dind

RUN apk add --no-cache bash curl

RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

WORKDIR /cluster

COPY wiki-service ./wiki-service
COPY wiki-chart ./wiki-chart
COPY start.sh .

RUN chmod +x start.sh

EXPOSE 8080

ENTRYPOINT ["./start.sh"]
