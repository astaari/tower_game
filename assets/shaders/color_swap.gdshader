shader_type canvas_item;

// Might be cool to
global uniform vec4 black;
global uniform vec4 white;

uniform vec4 new_black: source_color;
uniform vec4 new_white: source_color;

uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

const float precision = 0.1;
const int count = 2;


vec4 swap_color(vec4 color) {
	vec4 original[count] = vec4[count] (black, white);
	vec4 new_colors[count] = vec4[count] (new_black, new_white);
	for (int i = 0; i < count; i ++) {
		if (distance(color, original[i]) <= precision) {
			return new_colors[i];
		}
	}
	return color;
}


void fragment() {
	COLOR = swap_color(texture(screen_texture, SCREEN_UV, 0.0));
}