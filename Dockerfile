FROM registry.fedoraproject.org/fedora-toolbox:39

ENV KUSTOMIZE_VERSION="v5.2.1"
ARG YQ_VERSION="v4.40.3"
ARG OKD_RELEASE="4.15.0-0.okd-2024-02-10-035534"

LABEL maintainer="Humair Khan"
# Install additional dependecies and tools
RUN dnf install -y git openssl make npm pre-commit jsonnet \
    && dnf clean all \
    && rm -rf /var/cache/yum

ENV PRE_COMMIT_HOME=/tmp

RUN \
    # Install yq
    curl -o /usr/local/bin/yq -L https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x /usr/local/bin/yq && \
    # Install kustomize
    curl -o /usr/local/bin/kutomize -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64.tar.gz && \
    chmod +x /usr/local/bin/kutomize && \
    # Install kubectl and oc
    curl -L https://github.com/openshift/okd/releases/download/${OKD_RELEASE}/openshift-client-linux-${OKD_RELEASE}.tar.gz  | tar -xzf - -C /usr/local/bin  &&\
    chmod +x /usr/local/bin/oc && chmod +x /usr/local/bin/kubectl

COPY scripts/* /usr/local/bin/

CMD /bin/bash
