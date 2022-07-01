extends GridContainer
class_name TowerGridContainer

@export var mouse_catcher_path: NodePath
@export var tower_placer_path: NodePath

var mouse_catcher: MouseCatcher
var tower_placer: TowerPlacer

var placing_tower: bool = false
var selected_index: int = -1

func _ready() -> void:
	mouse_catcher = get_node(mouse_catcher_path)
	tower_placer = get_node(tower_placer_path)
	
	for button in get_children():
		button.connect("button_down", button_down, [button.get_index()])
		button.connect("button_up", button_up, [button.get_index()])
		button.connect("mouse_exited", button_mouse_exited, [button.get_index()])

func button_down(index: int) -> void:
	for button in get_children():
		if button.get_index() != index:
			button.disabled = true
	selected_index = index

func button_up(index: int) -> void:
	for button in get_children():
		button.disabled = false
	if placing_tower:
		tower_placer.place_tower()
	
	selected_index = -1
	placing_tower = false

func button_mouse_exited(index: int) -> void:
	if not index == selected_index:
		return
	tower_placer.create_tower(index)
	
	selected_index = -1
	placing_tower = true
