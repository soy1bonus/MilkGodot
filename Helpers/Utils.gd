class_name Utils extends Object

## Returns the seconds elapsed between Time and start_msec
static func get_elapsed_seconds(start_msec: int) -> float:
	return (Time.get_ticks_msec() - start_msec) * 0.001

static func clear_all_chilren(_node: Node) -> void:
	var child_count: int = _node.get_child_count()
	for child_index in range(0, child_count):
		var child: Node = _node.get_child(child_index)
		child.queue_free()
