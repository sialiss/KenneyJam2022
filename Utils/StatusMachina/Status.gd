extends Node
class_name Status

# The node this status belongs to
var host: Node

# Attaches itself to the node
# Also detaches the old status
func attach(node: Node):
	StatusMachina.attach(node, self)