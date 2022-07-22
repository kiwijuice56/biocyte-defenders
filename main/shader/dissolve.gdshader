// Modified from https://github.com/kondelik/Godot-3.1-Dissolve-shader-with-OpenSimplexNoise
// License at bottom

shader_type spatial;
render_mode unshaded;

uniform sampler2D texure: source_color, filter_nearest;
//  noise texture (see Dissolve.material for GUI Generated one or Main.gd::_on_reseed_noise_pressed() for scripted one)
uniform sampler2D noise_tex: source_color;
// burn ramp (gradiant from some color to transparent) - see Dissolve.material for GUI generated one
uniform sampler2D burn_ramp : source_color;
// size of burning path (0 is infinitely short)
uniform float burn_size : hint_range(0.1, 1);

// position (time) of burning
instance uniform float burn_position : hint_range(-1, 1);
instance uniform float alpha : hint_range(0, 1) = 1.0;

void fragment() {
	// get texture pixel color * tint
	// thats our result without burning effect.
	// We use COLOR as final color (we can use variable and assign it to COLOR at the end, but there is no reason to care)
	// TEXTURE is Sprite.Texture from GODOT
	// UV is UV from GODOT
	// At first, COLOR is filled with tint (Sprite -> Modulate) from GODOT (and from vertex shader).
	vec4 px = texture(texure, UV);
	ALBEDO = vec3(px.r, px.g, px.b); 
	ALPHA = px.a * alpha;
	
	// get some noise minus our position in time (thats why burn_position is range(-1, 1))
	float test = texture(noise_tex, UV).r - burn_position;
	
	// if our noise is bigger then treshold
	if (test < 0.0) {
		ALPHA = 0.0;
	} else if (test < burn_size) {
	
		// get burn color from ramp
		vec4 burn = texture(burn_ramp, vec2(test * (1.0 / burn_size), 0));

		// override result rgb color with burn rgb color (NOT alpha!)
		ALBEDO.rgb = burn.rgb;
		
		// and set alpha to lower one from texture or burn.
		// that means we keep transparent sprite (COLOR.a is lower) and transparent 'burned pathes' (burn.a is lower)
		ALPHA = min(burn.a, px.a) * alpha;
	}
}

/*
MIT License

Copyright (c) 2018 Jan 'spl!te' Kondelík

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/