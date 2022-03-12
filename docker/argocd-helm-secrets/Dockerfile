ARG ARGOCD_VERSION="v2.3.1"
FROM argoproj/argocd:$ARGOCD_VERSION
ARG SOPS_VERSION="3.7.2"
ARG HELM_SECRETS_VERSION="3.8.3"

USER root
RUN apt-get update && \
	apt-get install -y \
	curl && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -fSSL https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux \
	-o /usr/local/bin/sops && chmod +x /usr/local/bin/sops

USER argocd
ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
RUN helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets
