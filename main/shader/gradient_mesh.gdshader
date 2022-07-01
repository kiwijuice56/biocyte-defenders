shader_type spatial;

instance uniform vec4 albedo_first: source_color = vec4(1.0f);
instance uniform vec4 albedo_second: source_color = vec4(1.0f);

uniform float rim : hint_range(0,1) = 0.2;
uniform float rim_width : hint_range(0,1) = 0.35;
uniform float rim_smooth : hint_range(0,1) = 0.05;

uniform float highlight_strength: hint_range(0,1) = 0.15;

void fragment() {
	ALBEDO =  vec3(
		(albedo_first.r * (1.0 - UV.y)) + (albedo_second.r * UV.y), 
		(albedo_first.g * (1.0 - UV.y)) + (albedo_second.g * UV.y),
		(albedo_first.b * (1.0 - UV.y)) + (albedo_second.b * UV.y));
	ALPHA = (albedo_first.a * (1.0 - UV.y)) + (albedo_second.a * UV.y);
}

void light() {
	// Rim part. We use the view and normal vectors only to find out if we're looking
	// at a pixel from the edge of the object or not. We add the final value to specular
	// light values so that Godot treats it as specular.
	float rim_dot = 1.0 - dot(NORMAL, VIEW);
	float rim_threshold = pow((1.0 - rim_width), dot(LIGHT, NORMAL));
	float rim_intensity = smoothstep(rim_threshold - rim_smooth/2.0, rim_threshold + rim_smooth/2.0, rim_dot);
	SPECULAR_LIGHT = LIGHT_COLOR * rim * rim_intensity + ALBEDO * (rim_threshold);
	
	float highlight_dot = 1.0 - rim_dot;
	
	SPECULAR_LIGHT += pow(highlight_dot, 2.0) * highlight_strength;
}
