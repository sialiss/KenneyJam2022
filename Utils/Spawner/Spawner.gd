extends Node


func get_container():
	return get_tree().get_nodes_in_group("stuff_container")[0]


func spawn(node: Node):
	get_container().add_child(node)