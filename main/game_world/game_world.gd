extends Node3D
class_name GameWorld
# Root of 3D scene used during tower defense gameplay

var current_map: GameMap

func _ready() -> void:
	current_map = $CellSauna
