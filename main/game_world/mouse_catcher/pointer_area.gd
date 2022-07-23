extends Area3D
class_name PointerArea

signal tower_clicked(tower: Tower)
signal focus_lost

var colliding_tower_area: Area3D
var selected_tower: Tower

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", area_entered)
	connect("area_exited", area_exited)

func area_entered(area: Area3D) -> void:
	colliding_tower_area = area

func area_exited(_area: Area3D) -> void:
	colliding_tower_area = null

func _input(event) -> void:
	if not event.is_action_pressed("tap"):
		return
	if colliding_tower_area != null:
		var tower: Tower = colliding_tower_area.get_parent()
		if tower != selected_tower:
			emit_signal("focus_lost")
		if tower.active:
			selected_tower = tower
			emit_signal("tower_clicked", tower)
	else:
		emit_signal("focus_lost")
