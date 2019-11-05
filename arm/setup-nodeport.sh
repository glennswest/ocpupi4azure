cat > gw/manifests/ingress-controller-01-crd.yaml <<EOF
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
cat > gw/manifests/ingress-controller-02-namespace.yaml <<EOF
kind: Namespace
apiVersion: v1
metadata:
  annotations:
    openshift.io/node-selector: ""
  name: openshift-ingress-operator
EOF
cat > gw/manifests/ingress-controller-03-default.yaml <<EOF
apiVersion: operator.openshift.io/v1
kind: IngressController
metadata:
  name: default
  namespace: openshift-ingress-operator
spec:
  endpointPublishingStrategy:
    type: Private
EOF
cat > gw/manifests/ingress-controller-04-default.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: router-default
  namespace: openshift-ingress
  annotations:
    operator.openshift.io/node-port-service-for: default
spec:
  type: NodePort
  externalTrafficPolicy: Local
  ports:
  - name: http
    nodePort: 30932
    port: 80
    protocol: TCP
    targetPort: http
  - name: https
    nodePort: 31613
    port: 443
    protocol: TCP
    targetPort: https
  selector:
    ingresscontroller.operator.openshift.io/deployment-ingresscontroller: default
EOF

