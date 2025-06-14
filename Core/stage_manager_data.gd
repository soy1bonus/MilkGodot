class_name StageManagerData
extends Resource

## The 'real' starting scene. We use an intermediate scene (main_scene) to setup root nodes for UI and the Game 
@export var _starting_stage_uid: String

@export_group("Main Scene Properties")
## Stage scenes (interfaces/screens) will be parented to this node
@export var stage_root_name: String = "CanvasLayer"
## Game scenes will be parented to this node
@export var game_root_name: String = "SubViewport"

func get_starting_stage_uid() -> int:
    return ResourceUID.text_to_id(_starting_stage_uid)