FROM ubuntu:22.04 as builder

RUN apt-get update \
 && apt-get install -y curl make \
 && curl -LO "https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl" \
 && chmod +x ./kubectl \
 && mv ./kubectl /usr/local/bin/kubectl \
 && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

FROM ubuntu:22.04

COPY --from=builder /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=builder /usr/local/bin/helm /usr/local/bin/helm
COPY --from=builder /usr/bin/make /usr/bin/make

CMD ["bash"]
