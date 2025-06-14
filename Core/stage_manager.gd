## Autoload that handles 'Stages'. Stages are mostly interfaces that dictate the flow of the game.
## Others would call them windows or screens. 
## A Main Menu is a stage. The Settings Menu is a stage. The Game HUD is a stage.
## It's what others would tie to gamestates but I think it's usually tied to some sort of interface.
extends Node
# class_name StageManager

var _stage_root: Node
var _game_root: Node

const DATA_PATH: String = "res://Resources/StageManagerData.tres"

enum StageManagerState { IDLE, INIT, LOAD }
var _state : StageManagerState = StageManagerState.INIT

var _next_stage_uid: int

# TODO push_stage and pop_stage

## Loads the stage specified in the path in the next frame (clearing the previous ones)
func load_stage(_stage_uid: int) -> void:
	_next_stage_uid = _stage_uid
	_state = StageManagerState.LOAD
	process_mode = Node.PROCESS_MODE_INHERIT

#region Internal Methods
func _initialize() -> void:
	Log.init()
	# Load the config resource
	var data: StageManagerData = load(DATA_PATH)
	
	if data == null:
		Log.error("Couldn't load %s" % DATA_PATH)
		return
	if data.stage_root_name == null or data.stage_root_name.is_empty():
		Log.error("No Stage Root name specified!")
		return
	if data.game_root_name == null or data.game_root_name.is_empty():
		Log.error("No Game Root name specified!")
		return

	# Get Stage and Game root nodes
	var root: Node = get_tree().root
	_stage_root = root.find_child(data.stage_root_name, true, false)
	if _stage_root == null:
		Log.error("No stage root with name '%s' found!" % data.stage_root_name)
		return

	_game_root = root.find_child(data.game_root_name, true, false)
	if _game_root == null:
		Log.error("No game root with name '%s' found!" % data.game_root_name)
		return

	# Load the starting stage
	_load_stage(data.starting_stage_uid)


func _load_stage(_stage_uid: int) -> void:

	if (!ResourceUID.has_id(_stage_uid)):
		Log.error("Trying to load invalid UID '%s'" % _stage_uid)
		return
	
	# Remove previous stage
	Utils.clear_all_chilren(_stage_root)
	
	# Load next stage
	Log.msg("Loading stage '%s'" % ResourceUID.get_id_path(_stage_uid))
	var sceneRef: PackedScene = load(ResourceUID.id_to_text(_stage_uid))
	var scene: Node = sceneRef.instantiate()
	_stage_root.add_child(scene)


func _process(_delta: float) -> void:
	match(_state):
		StageManagerState.INIT:
			_initialize()
		StageManagerState.LOAD:
			_load_stage(_next_stage_uid)
	_state = StageManagerState.IDLE
	# Disable processing, this is used just as a way to initialize everything
	process_mode = Node.PROCESS_MODE_DISABLED
#endregion
