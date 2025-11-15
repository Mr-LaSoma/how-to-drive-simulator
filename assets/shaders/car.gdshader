shader_type canvas_item;

uniform vec4 const_color: source_color = vec4(0.349, 0.129, 0.129, 1.0);
uniform float tolerance: hint_range(0.0, 1.0) = 0.01;

uniform vec4 color_start: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color_end : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float color_change : hint_range(0.0, 255, 0.1);
uniform bool is_transparent;

void fragment() {
    vec4 text_color = texture(TEXTURE, UV);
    float change = clamp(color_change / 255.0, 0.0, 1.0);
	float dist = distance(text_color, const_color);
	
	if (dist > tolerance) {
    	vec3 new_rgb = mix(color_start.rgb, color_end.rgb, change);
    	text_color.rgb = new_rgb;
	}

    if (is_transparent) {
        text_color.a = clamp(text_color.a - 0.4, 0.0, 1.0);
    }

    COLOR = text_color;
}