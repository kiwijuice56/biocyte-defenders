extends Node3D
class_name GameWorld
# Root of 3D scene used during tower defense gameplay

@onready var current_map: GameMap = $CellSauna
@onready var cam: Camera3D = $Camera3D
