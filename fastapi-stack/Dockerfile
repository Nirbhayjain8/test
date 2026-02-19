FROM docker:25-dind

RUN apk add --no-cache \
    bash \
    curl \
    git \
    helm

# Install k3d
RUN wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | sh

WORKDIR /app

COPY wiki-service ./wiki-service
COPY wiki-chart ./wiki-chart
COPY start.sh .

RUN chmod +x start.sh

EXPOSE 8080

CMD ["./start.sh"]
