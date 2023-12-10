## Autoload that handles 'Stages'. Stages are mostly interfaces that dictate the flow of the game.
## Others would call them windows or screens. 
## A Main Menu is a stage. The Settings Menu is a stage. The Game HUD is a stage.
## It's what others would tie to gamestates but I think it's usually tied to some sort of interface.
extends Node
# class_name StageManager

var _stage_root: Node
var _game_root: Node


func _process(_delta: float) -> void:
	const DATA_PATH: String = "res://Resources/StageManagerData.tres"
	var data: StageManagerData = load(DATA_PATH)
	assert(data != null, "Couldn't load %s" % DATA_PATH)	
	assert(data.stage_root_name != null and !data.stage_root_name.is_empty(), "No Stage Root name specified!")
	assert(data.game_root_name != null and !data.game_root_name.is_empty(), "No Game Root name specified!")

	var root: Node = get_tree().root
	_stage_root = root.find_child(data.stage_root_name, true, false)
	assert(_stage_root != null, "No stage root with name '%s' found!" % data.stage_root_name)
	_game_root = root.find_child(data.game_root_name, true, false)
	assert(_game_root != null, "No game root with name '%s' found!" % data.game_root_name)
	
	print("Loading starting stage '%s'" % data.starting_stage)
	var sceneRef: PackedScene = load(data.starting_stage)
	var scene: Node = sceneRef.instantiate()
	_stage_root.add_child(scene)
	# Disable processing, this is used just as a way to initialize everything
	process_mode = Node.PROCESS_MODE_DISABLED
