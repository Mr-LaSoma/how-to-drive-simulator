shader_type canvas_item;

const vec4 CONST_COLOR = vec4(0.349, 0.129, 0.129, 1.0);
const float TOLERANCE = 0.01;
const vec4 DEATH_COLOR = vec4(0.0, 0.0, 0.0, 1.0);
const float OPACITY = 0.6;

uniform vec4 color_start: source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color_end : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float color_change : hint_range(0.0, 255, 0.1);
uniform bool is_transparent = true;
uniform bool is_dead = false;

void fragment() {
    vec4 text_color = texture(TEXTURE, UV);
    float change = clamp(color_change / 255.0, 0.0, 1.0);
	float dist = distance(text_color, CONST_COLOR);
	
	if (dist > TOLERANCE) {
    	vec3 new_rgb = mix(color_start.rgb, color_end.rgb, change);
    	text_color.rgb = new_rgb;
		
		if (is_dead) { text_color.rgb = mix(color_start.rgb, DEATH_COLOR.rgb, 255.0);}
	}

    if (is_transparent) { text_color.a = clamp(text_color.a - OPACITY, 0.0, 1.0); }
	

    COLOR = text_color;
}