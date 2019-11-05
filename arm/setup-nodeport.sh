cat > ./clusters/gcp-mmasters-5/manifests/ingress-controller-01-crd.yaml <<EOF
---
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: ingresscontrollers.operator.openshift.io
spec:
  group: operator.openshift.io
  names:
    kind: IngressController
    plural: ingresscontrollers
  scope: Namespaced
  subresources:
    scale:
      labelSelectorPath: .status.labelSelector
      specReplicasPath: .spec.replicas
      statusReplicasPath: .status.availableReplicas
    status: {}
  versions:
  - name: v1
    served: true
    storage: true
EOF
cat > ./clusters/gcp-mmasters-5/manifests/ingress-controller-02-namespace.yaml <<EOF                                          kind: Namespace
apiVersion: v1
metadata:
  annotations:
    openshift.io/node-selector: ""
  name: openshift-ingress-operator
EOF
cat > ./clusters/gcp-mmasters-5/manifests/ingress-controller-03-default.yaml <<EOF
apiVersion: operator.openshift.io/v1
kind: IngressController
metadata:
  name: default
  namespace: openshift-ingress-operator
spec:
  endpointPublishingStrategy:
    type: Private
EOF

