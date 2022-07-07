shader_type spatial;
render_mode unshaded, cull_back;

instance uniform vec4 outline_color: source_color = vec4(0.0,0.0,0.0,1.0);

void fragment() {
	ALBEDO = vec3(outline_color.r, outline_color.g, outline_color.b);
}
