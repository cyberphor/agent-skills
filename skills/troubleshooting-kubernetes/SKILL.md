---
name: troubleshooting-kubernetes
description: Diagnose Kubernetes workload and service failures using scoped cluster evidence. Use for unhealthy Pods, rollout failures, connectivity, storage, and access problems.
---

# Troubleshooting Kubernetes

Verify the intended cluster context and namespace before querying resources. Inspect `kubectl config current-context` and the relevant context configuration, then use explicit context and namespace options for cluster commands. Establish the failing workload, symptom, and time window. Preserve the user's operational scope.

Read and apply `writing-style` from the active skill catalog or [sibling skill](../writing-style/SKILL.md) when drafting explanations. Reuse it if already loaded.

## Collect Evidence

Start with read-only queries. Inspect workload status, owner relationships, Pod conditions, container states, restart counts, and recent events. Use `kubectl describe` on the affected resource to connect scheduling or startup failures with reported reasons.

Select Pods by their actual labels and identify the failing container. Retrieve bounded logs using the relevant container, time window, or tail limit. Use `kubectl logs --previous` for the previous instance of a restarting container when available. Distinguish init-container failure, image pull failure, application exit, readiness failure, and resource exhaustion before proposing a fix.

Do not dump secrets or unrelated workload logs. Treat absent logs and expired events as evidence limits, not proof that no failure occurred.

## Follow the Failure

**Workload.** Compare desired and observed replicas, rollout status, image identity, configuration references, probes, requests, limits, and scheduling constraints. Check terminated-container reasons and node conditions when the evidence points to resources or placement.

**Network.** Trace the failing route through Service selectors, EndpointSlices, target ports, Pod readiness, DNS, and relevant NetworkPolicies. Inspect ingress or gateway configuration only when the failed path uses it. Active probes, `exec`, and temporary debug containers require task authorization and can affect workloads.

**Storage.** Inspect PVC binding, PV and StorageClass compatibility, access modes, capacity, topology, and attach or mount events. Do not delete claims or volumes to test a hypothesis.

**Access.** Identify the denied API operation and actual user or ServiceAccount. Check scoped authorization with `kubectl auth can-i` and inspect applicable RoleBindings and ClusterRoleBindings. Do not grant broad privileges to bypass an unexplained denial.

## Fix and Verify

State the likely cause with supporting evidence and remaining uncertainty. Choose the smallest change that addresses it, respecting the repository's manifest or GitOps workflow. Diagnosis alone does not authorize restarting, scaling, deleting, patching, or creating resources. Make disruptive changes only within the task's authorization.

After an authorized fix, verify the original symptom, relevant readiness or rollout state, and fresh logs or events. A successful command is insufficient if the workload still fails. Report the cause, changes, observed outcome, and any remaining evidence gaps.

## Official References

- [Troubleshooting applications](https://kubernetes.io/docs/tasks/debug/debug-application/) for symptom-specific diagnostic paths.
- [Debug Pods](https://kubernetes.io/docs/tasks/debug/debug-application/debug-pods/) and [Debug Services](https://kubernetes.io/docs/tasks/debug/debug-application/debug-service/) for workload and connectivity evidence.
- [kubectl logs](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_logs/) for container selection and previous-instance logs.
- [kubectl auth can-i](https://kubernetes.io/docs/reference/kubectl/generated/kubectl_auth/kubectl_auth_can-i/) for scoped authorization checks.
