#!/bin/bash

# Longhorn Namespace
RELEASE_NAMESPACE=longhorn-system

# Detect Release Name
RELEASE_NAME=`kubectl get ds longhorn-manager -n ${RELEASE_NAMESPACE} -ojsonpath="{.metadata.labels['app\.kubernetes\.io/instance']}"`

## Namespace-Wide Resources

### CRD

kubectl get crd -l longhorn-manager -o name -n ${RELEASE_NAMESPACE} | xargs -I % kubectl annotate --overwrite -n ${RELEASE_NAMESPACE} % helm.sh/resource-policy=keep
kubectl get crd -l longhorn-manager -o name -n ${RELEASE_NAMESPACE} | xargs -I % kubectl annotate --overwrite -n ${RELEASE_NAMESPACE} % meta.helm.sh/release-name=longhorn-crd
kubectl get crd -l longhorn-manager -o name -n ${RELEASE_NAMESPACE} | xargs -I % kubectl annotate --overwrite -n ${RELEASE_NAMESPACE} % meta.helm.sh/release-namespace=${RELEASE_NAMESPACE}
kubectl get crd -l longhorn-manager -o name -n ${RELEASE_NAMESPACE} | xargs -I % kubectl label --overwrite -n ${RELEASE_NAMESPACE} % app.kubernetes.io/managed-by=Helm

### Other Resources
kubectl get cm,svc,ds,deploy,sa,role,rolebinding -o name -n ${RELEASE_NAMESPACE} | xargs -I % kubectl annotate --overwrite -n ${RELEASE_NAMESPACE} % meta.helm.sh/release-name=${RELEASE_NAME}
kubectl get cm,svc,ds,deploy,sa,role,rolebinding -o name -n ${RELEASE_NAMESPACE} | xargs -I % kubectl annotate --overwrite -n ${RELEASE_NAMESPACE} % meta.helm.sh/release-namespace=${RELEASE_NAMESPACE}
kubectl get cm,svc,ds,deploy,sa,role,rolebinding -o name -n ${RELEASE_NAMESPACE} | xargs -I % kubectl label --overwrite -n ${RELEASE_NAMESPACE} % app.kubernetes.io/managed-by=Helm

## Cluster-Wide Resources

## PSP
kubectl get psp longhorn-psp -o name | xargs -I % kubectl annotate --overwrite % meta.helm.sh/release-name=${RELEASE_NAME}
kubectl get psp longhorn-psp -o name | xargs -I % kubectl annotate --overwrite % meta.helm.sh/release-namespace=${RELEASE_NAMESPACE}
kubectl get psp longhorn-psp -o name | xargs -I % kubectl label --overwrite % app.kubernetes.io/managed-by=Helm

### ClusterRole
kubectl get clusterrole longhorn-role -o name | xargs -I % kubectl annotate --overwrite % meta.helm.sh/release-name=${RELEASE_NAME}
kubectl get clusterrole longhorn-role -o name | xargs -I % kubectl annotate --overwrite % meta.helm.sh/release-namespace=${RELEASE_NAMESPACE}
kubectl get clusterrole longhorn-role -o name | xargs -I % kubectl label --overwrite % app.kubernetes.io/managed-by=Helm

## ClusterRoleBinding
kubectl get clusterrolebinding longhorn-bind -o name | xargs -I % kubectl annotate --overwrite % meta.helm.sh/release-name=${RELEASE_NAME}
kubectl get clusterrolebinding longhorn-bind -o name | xargs -I % kubectl annotate --overwrite % meta.helm.sh/release-namespace=${RELEASE_NAMESPACE}
kubectl get clusterrolebinding longhorn-bind -o name | xargs -I % kubectl label --overwrite % app.kubernetes.io/managed-by=Helm
