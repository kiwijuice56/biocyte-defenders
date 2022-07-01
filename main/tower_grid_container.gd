extends GridContainer
class_name TowerGridContainer
# Triggers tower placement and UI updates with button clicks

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
		button.connect("mouse_exited", button_mouse_exited, [button.get_index()])

func _input(_event) -> void:
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		for button in get_children():
			button.disabled = false
			button.button_pressed = false
		if placing_tower:
			tower_placer.place_tower()
		
		placing_tower = false
		set_process_input(false)

func button_down(index: int) -> void:
	for button in get_children():
		if button.get_index() != index:
			button.disabled = true
	selected_index = index
	set_process_input(true)

func button_mouse_exited(index: int) -> void:
	if not index == selected_index:
		return
	# Create new tower only after player has started to drag the mouse
	tower_placer.create_tower(index)
	
	selected_index = -1
	placing_tower = true
