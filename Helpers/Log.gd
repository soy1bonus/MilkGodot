class_name Log extends Object

## Prints a bunch of information about the device
static func init() -> void:
	# https://github.com/godotengine/godot-demo-projects/blob/4.2-31d1c0c/misc/os_test/os_test.gd

	Log.msg("Starting Application...")
	Log.header("Device Info")
	Log.info("System", OS.get_name())
	Log.info("Version", OS.get_version())
	Log.info("Locale", OS.get_locale_language())
	Log.info("Processor", OS.get_processor_name())

	# Memory info
	var memory_info = OS.get_memory_info()
	if memory_info:
		Log.info("Total Memory", str(memory_info.physical))
		Log.info("Available Memory", str(memory_info.available))

	# GPU info
	var gpu_info = OS.get_video_adapter_driver_info()
	if gpu_info:
		Log.info("GPU Name", gpu_info[0])
		Log.info("GPU Driver", gpu_info[1])

	# Other info
	Log.info("Exe Path", OS.get_executable_path())

## Prints a header to the log
static func header(message: String) -> void:
	print_rich("[color=green][b]%s[/b][/color]" % message)

## Prints a message to the log, using a Title beforehand
static func info(title: String, message: String) -> void:
	print_rich("[color=olive][b]%s:[/b][/color] %s" % [title, message])

## Prints a message to the log, adding a timestamp
static func msg(message: String) -> void:
	print_rich("[color=olive](%s)[/color] %s" % [Time.get_datetime_string_from_system(true,true), message])

static func error(message: String) -> void:
	print_rich("[color=red](%s) [b]%s[/b][/color]" % [Time.get_datetime_string_from_system(true,true), message])
	push_error(message)

static func warning(message: String) -> void:
	print_rich("[color=yellow](%s) %s[/color]" % [Time.get_datetime_string_from_system(true,true), message])
	push_warning(message)
