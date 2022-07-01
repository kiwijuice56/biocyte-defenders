extends Node3D
class_name GameMap

@export var cell_count_dimension: Vector2 = Vector2(20, 14)
var grid_data: Array[Array]

func _ready() -> void:
	reset_grid()

func reset_grid() -> void:
	grid_data = []
	for y in range(cell_count_dimension.y):
		var row: Array[Tower] = []
		for x in range(cell_count_dimension.x):
			row.append(Tower.new())
		grid_data.append(row)
