class_name StatusMachina

# Returs the current status or null
static func find(node: Node):
	if node.has_meta("status"):
		return node.get_meta("status")
	return null

static func detach(node: Node):
	var old_status = find(node)
	if old_status:
		node.remove_child(old_status)
		node.remove_meta("status")
		old_status.queue_free()

static func attach(node: Node, status):
	status.host = node
	detach(node)
	node.set_meta("status", status)
	node.add_child(status)
