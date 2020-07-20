#!/usr/bin/env bash
set -e
set -o pipefail

HOME="/root"
if [[ -z "${HELM_VERSION}" ]]; then HELM_VERSION="${INPUT_HELMVERSION}"; fi
if [[ -z "${KUBECTL_VERSION}" ]]; then KUBECTL_VERSION="${INPUT_KUBECTLVERSION}"; fi
if [[ -z "${AWS_ACCESS_KEY_ID}" ]]; then AWS_ACCESS_KEY_ID="${INPUT_AWSACCESSKEYID}"; fi
if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]; then AWS_SECRET_ACCESS_KEY="${INPUT_AWSSECRETACCESSKEY}"; fi
if [[ -z "${AWS_DEFAULT_REGION}" ]]; then AWS_DEFAULT_REGION="${INPUT_AWSDEFAULTREGION}"; fi
if [[ -z "${EKS_CLUSTER_NAME}" ]]; then EKS_CLUSTER_NAME="${INPUT_EKSCLUSTERNAME}"; fi

echo -e "\n\nhelm-eks: installing helm..."
wget -qO helm-v${HELM_VERSION}-linux-amd64.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz &&
    tar xzf helm-v${HELM_VERSION}-linux-amd64.tar.gz &&
    mv linux-amd64/helm /usr/local/bin/helm &&
    chmod +x /usr/local/bin/helm &&
    rm -Rf linux-amd64/ helm-v${HELM_VERSION}-linux-amd64.tar.gz
helm init --client-only 1>/dev/null 2>&1

wget -qO /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl &&
    chmod +x /usr/local/bin/kubectl

aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
aws configure set default.region "${AWS_DEFAULT_REGION}"
aws eks update-kubeconfig --name "${EKS_CLUSTER_NAME}"

echo -e "\n\nhelm-eks: executing command..."
bash -c "set -e; set -o pipefail; $1"
