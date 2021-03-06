# @title Deny user pod from being scheduled to system nodes
#
# User pod with a toleration allowing it to be scheduled to a system node should be rejected.
# Specifically, if the pod is not in the system namespace AND the forbidden toleration is present,
# then the pod is in violation of this policy and should be denied.
#
# @enforcement deny
# @kinds core/Pod
package deny_user_pod_system_node

system_namespace := "system"

violation[{"msg": msg, "details": {}}] {
	resource := input.review.object

	# Tolerate scheduling user pod to system node is forbidden
	forbidden_toleration := {
		"effect": "NoSchedule",
		"key": "purpose",
		"operator": "Equal",
		"value": "system",
	}

	# If the namespace is "system", then this policy does not apply.
	resource.metadata.namespace != "system"

	# If the forbidden toleration is not present, then this policy does not apply.
	tolerations := [toleration | resource.spec.tolerations[i] == forbidden_toleration; toleration := resource.spec.tolerations[i]]
	count(tolerations) > 0

	# Get pod name and namespace
	pod_name := resource.metadata.name
	namespace := resource.metadata.namespace
	msg := sprintf("Forbidden: Pod %s in namespace %s has toleration %v, which would allow it to be scheduled to a system node.", [pod_name, namespace, forbidden_toleration])
}
