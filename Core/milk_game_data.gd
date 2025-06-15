class_name MilkGameData
extends Resource

## The 'real' starting scene. We use an intermediate scene (main_scene) to setup root nodes for UI and the Game 
@export var _starting_section_uid: String

@export_group("Main Scene Properties")
## Section scenes (interfaces/screens) will be parented to this node
@export var section_root_name: String = "CanvasLayer"
## Stage scenes (gameplay/entities) will be parented to this node
@export var stage_root_name: String = "SubViewport"

func get_starting_section_uid() -> int:
    return ResourceUID.text_to_id(_starting_section_uid)