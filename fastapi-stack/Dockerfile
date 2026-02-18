FROM docker:25-dind

RUN apk add --no-cache bash curl git

# kubectl
RUN curl -LO https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && mv kubectl /usr/local/bin/

# helm
RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# k3d
RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

WORKDIR /cluster

COPY wiki-service ./wiki-service
COPY wiki-chart ./wiki-chart
COPY start.sh .

RUN chmod +x start.sh

EXPOSE 8080

CMD ["./start.sh"]
