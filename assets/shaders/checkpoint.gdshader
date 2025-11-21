shader_type canvas_item;

uniform float opacity: hint_range(0.0, 1.0, 0.1) = 0.6;
uniform bool is_transparent = true;

void fragment() {
	vec4 text_color = texture(TEXTURE, UV);
	
    if (is_transparent) { text_color.a = clamp(text_color.a - opacity, 0.0, 1.0); }
	
    COLOR = text_color;
}

