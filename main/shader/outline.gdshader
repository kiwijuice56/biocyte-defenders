shader_type spatial;
render_mode unshaded, cull_front;

instance uniform vec4 color: source_color;

void fragment() {
	ALBEDO = vec3(color.r, color.g, color.b);
}
