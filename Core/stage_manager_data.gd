class_name StageManagerData
extends Resource

## The 'real' starting scene. We use an intermediate scene (main_scene) to setup root nodes for UI and the Game 
@export_file("*.tscn") var starting_stage: String = "res://Scenes/Stages/intro_stage.tscn"

@export_group("Main Scene Properties")
## Stage scenes (interfaces/screens) will be parented to this node
@export var stage_root_name: String = "CanvasLayer"
## Game scenes will be parented to this node
@export var game_root_name: String = "SubViewport"
