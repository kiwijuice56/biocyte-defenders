@tool
extends EditorScript

var color: Color = Color("#132452")
var width: float = 0.13
var outline_mat: ShaderMaterial = load("res://main/shader/outline_material.tres")

func _run():
	var stack: Array[Node] = [get_scene()]
	var new_outline: ShaderMaterial = outline_mat.duplicate()
	
	while len(stack) > 0:
		var node: Node = stack.pop_back()
		if node is MeshInstance3D and str(node.name).ends_with("-out"):
			for child in node.get_children():
				if str(child.name).begins_with("OutlineMeshInstance"):
					child.queue_free()
			
			var outline_mesh: MeshInstance3D = MeshInstance3D.new()
			outline_mesh.mesh = node.mesh.create_outline(width)
			node.add_child(outline_mesh)
			
			outline_mesh.owner = get_scene()
			outline_mesh.skeleton = node.get_parent().get_path()
			outline_mesh.name = "OutlineMeshInstance"
			outline_mesh.material_override = new_outline
			outline_mesh.set_shader_instance_uniform("outline_color", color)
		for child in node.get_children():
			stack.append(child)
