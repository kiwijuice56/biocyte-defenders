extends Node3D
class_name TowerModel
# Manages tower model combinations from different upgrade paths

@export var palette: Dictionary 
var main_model_name: String

func _ready() -> void:
	# Models are offset by certain y positions for better clarity when exporting and editing
	# The number at the end of a mesh name is its y offset to be reset when the model is loaded
	for child in get_children():
		if not child is Node3D:
			continue
		
		var str_name: String = str(child.name)
		child.position.y += (str_name.substr(str_name.find("-")+1)).to_int()

func finalize_model() -> void:
	var main_model: Node3D = get_node(NodePath(main_model_name))
	
	# Remove needless meshes
	for child in get_children():
		if not child == main_model:
			child.queue_free()
	
	# Update colors on meshes
	for child in main_model.get_child(0).get_children():
		if not child is MeshInstance3D:
			continue
		var mesh_name: String = str(child.name)
		var color_group: String = mesh_name.substr(0, mesh_name.find("-"))
		child.set_shader_instance_uniform("albedo_first", palette[color_group][0])
		child.set_shader_instance_uniform("albedo_second", palette[color_group][1])
