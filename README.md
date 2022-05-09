# demo-local-gatekeeper
Setup Gatekeeper on k3d to test policies and constraints

# Overview

This repository starts up a local multinode Kubernetes cluster using [k3d](https://k3d.io/) in order to test Gatekeeper policies that provide rules around which pods are allowed to be scheduled to certain nodes.

# Prerequisites
- Install kubectl, docker, k3d
- Install the [Konstraint CLI](https://github.com/plexsystems/konstraint) to autogenerate constraints and templates from rego policies.
- Install [Taskfile](https://taskfile.dev/#/).

# Getting Started

1. Run `task k3d:cluster:create` to start up a local multinode k3d cluster.
2. Run `task k8s:gatekeeper-install` to install gatekeeper on the k3d cluster.
3. Run `task opa:policies` to create `ConstraintTemplate` manifests from the corresponding `.rego` policies in the `policies` folder.
4. Run `task opa:constraints` to create `Constraint` manifests in the `constraints` folder.
5. Run `task opa:test` to ensure the unit tests pass
6. Run `task opa:apply:policies` to apply `ConstraintTemplates`to the cluster
7. Run `task opa:apply:constraints` to apply the `Constrants` to the cluster
8. Verify that the Gatekeeper constraint works by running `kubectl apply -f examples/user_pod_system_node.yaml` and ensure that a Gatekeeper error response is received.

# Gatekeeper and Kubernetes Admission Webhooks

![Kubernetes Admission Controllers Diagram](https://d33wubrfki0l68.cloudfront.net/af21ecd38ec67b3d81c1b762221b4ac777fcf02d/7c60e/images/blog/2019-03-21-a-guide-to-kubernetes-admission-controllers/admission-controller-phases.png)

Recall that there are two kinds of admission control webhooks in Kubernetes: (1) mutating admission webhooks, and (2) validating admission webhooks.[^1] [Gatekeeper](https://kubernetes.io/blog/2019/08/06/opa-gatekeeper-policy-and-governance-for-kubernetes/) is a **validating admission webhook** that enforces policies executed by [Open Policy Agent (OPA)](https://www.openpolicyagent.org).

[^1] Diagram borrowed from [Kubernetes Admission Controllers Documentation](https://kubernetes.io/blog/2019/03/21/a-guide-to-kubernetes-admission-controllers/)

For more information about how Gatekeeper works, refer to this [two part tutorial](https://itnext.io/running-gatekeeper-in-kubernetes-and-writing-policies-part-1-fcc83eba93e3).

# Further Reading

- [Kubernetes Admission Controllers](https://kubernetes.io/blog/2019/03/21/a-guide-to-kubernetes-admission-controllers/)
- [Kubernetes Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)
- [OPA Policy Language Reference](https://www.openpolicyagent.org/docs/latest/policy-language/)

- [Install Gatekeeper](https://open-policy-agent.github.io/gatekeeper/website/docs/install/)
- [Gatekeepr in Kubernetes Tutorial - Part 1](https://itnext.io/running-gatekeeper-in-kubernetes-and-writing-policies-part-1-fcc83eba93e3)
- [Gatekeepr in Kubernetes Tutorial - Part 2](https://itnext.io/running-and-writing-gatekeeper-policies-in-kubernetes-part-2-1c49c1c683b2)