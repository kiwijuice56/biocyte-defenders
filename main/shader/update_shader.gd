@tool
extends EditorScript
# Creates outline meshes for all MeshInstance3Ds in a scene

var outline_color: Color = Color("#132452")
var outline_width: float = 0.13

var outline_mat: ShaderMaterial = load("res://main/shader/outline_material.tres")
var toon_mat: ShaderMaterial = load("res://main/shader/toon_material.tres")
var toon_clip_mat: ShaderMaterial = load("res://main/shader/toon_clip_material.tres")

func _run() -> void:
	var stack: Array[Node] = [get_scene()]
	var new_outline: ShaderMaterial = outline_mat.duplicate()
	
	while len(stack) > 0:
		var node: Node = stack.pop_back()
		if node is MeshInstance3D and not str(node.name).begins_with("OutlineMeshInstance"):
			# Apply materials
			if str(node.name).ends_with("-pri"):
				node.material_override = toon_clip_mat
			else:
				node.material_override =  toon_mat
			# Apply outlines
			if str(node.name).ends_with("-out"):
				for child in node.get_children():
					if str(child.name).begins_with("OutlineMeshInstance"):
						child.queue_free()
				
				var outline_mesh: MeshInstance3D = MeshInstance3D.new()
				outline_mesh.mesh = node.mesh.create_outline(outline_width)
				node.add_child(outline_mesh)
				
				outline_mesh.owner = get_scene()
				outline_mesh.skeleton = NodePath("../" + str(node.skeleton))
				outline_mesh.name = "OutlineMeshInstance"
				outline_mesh.material_override = new_outline
				outline_mesh.set_shader_instance_uniform("outline_color", outline_color)
		for child in node.get_children():
			stack.append(child)
	property_list_changed
	emit_signal("property_list_changed")
