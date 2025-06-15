## Autoload that handles the game. Games are divided into Sections and Stages.
## Sections are mostly interfaces that dictate the flow of the game: main menu, settings, game, etc.
## Stages are game world that hold entities. Like the game with enemies or bullets, or a background scene in the main menu.
extends Node
# class_name MilkGame

var _section_root: Node
var _stage_root: Node

const DATA_PATH: String = "res://Resources/MilkGameData.tres"

enum SectionHandlerState { IDLE, INIT, LOAD }
var _section_state : SectionHandlerState = SectionHandlerState.INIT

var _next_section_uid: int

#region Stage Functions
func load_stage_url(_stage_uid_uri: String) -> void:
	load_stage(ResourceUID.text_to_id(_stage_uid_uri))

func load_stage(_stage_uid: int) -> void:
	if (!ResourceUID.has_id(_stage_uid)):
		MilkLog.error("Trying to load invalid UID '%s'" % _stage_uid)
		return
	
	# Remove previous section
	MilkUtils.clear_all_chilren(_stage_root)

	MilkLog.msg("Loading Stage '%s'" % ResourceUID.get_id_path(_stage_uid))
	var sceneRef: PackedScene = load(ResourceUID.id_to_text(_stage_uid))
	var scene: Node = sceneRef.instantiate()
	_stage_root.add_child(scene)

#endregion

#region Section Functions
# TODO push_section and pop_section

## Loads the section specified in the URL, usually "uid://some-hash-thing"
func load_section_url(_section_uid_uri: String) -> void:
	load_section(ResourceUID.text_to_id(_section_uid_uri))

## Loads the stage specified in the path in the next frame (clearing the previous ones)
func load_section(_section_uid: int) -> void:
	_next_section_uid = _section_uid
	_section_state = SectionHandlerState.LOAD
	process_mode = Node.PROCESS_MODE_INHERIT

#endregion

#region Internal Functions
func _initialize() -> void:
	MilkLog.init()
	# Load the config resource
	var data: MilkGameData = load(DATA_PATH)
	
	if data == null:
		MilkLog.error("Couldn't load %s" % DATA_PATH)
		return
	if data.section_root_name == null or data.section_root_name.is_empty():
		MilkLog.error("No Stage Root name specified!")
		return
	if data.stage_root_name == null or data.stage_root_name.is_empty():
		MilkLog.error("No Game Root name specified!")
		return

	# Get Section and Section root nodes
	var root: Node = get_tree().root
	_section_root = root.find_child(data.section_root_name, true, false)
	if _section_root == null:
		MilkLog.error("No section root with name '%s' found!" % data.section_root_name)
		return

	_stage_root = root.find_child(data.stage_root_name, true, false)
	if _stage_root == null:
		MilkLog.error("No stage root with name '%s' found!" % data.stage_root_name)
		return

	# Load the starting section
	_load_section(data.get_starting_section_uid())


func _load_section(_section_uid: int) -> void:
	if (!ResourceUID.has_id(_section_uid)):
		MilkLog.error("Trying to load invalid UID '%s'" % _section_uid)
		return
	
	# Remove previous section
	MilkUtils.clear_all_chilren(_section_root)
	
	# Load next section
	MilkLog.msg("Loading Section '%s'" % ResourceUID.get_id_path(_section_uid))
	var sceneRef: PackedScene = load(ResourceUID.id_to_text(_section_uid))
	var scene: Node = sceneRef.instantiate()
	_section_root.add_child(scene)


func _process(_delta: float) -> void:
	match(_section_state):
		SectionHandlerState.INIT:
			_initialize()
		SectionHandlerState.LOAD:
			_load_section(_next_section_uid)
	_section_state = SectionHandlerState.IDLE
	# Disable processing, this is used just as a way to initialize everything
	process_mode = Node.PROCESS_MODE_DISABLED
#endregion
