class_name Utils extends Object

## Returns the seconds elapse between Time and start_msec
static func get_elapsed_seconds(start_msec: int) -> float:
	return (Time.get_ticks_msec() - start_msec) * 0.001
