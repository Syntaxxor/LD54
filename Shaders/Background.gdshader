shader_type canvas_item;
#include "Common.gdshaderinc"

uniform vec4 top_color: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 bottom_color: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float bottom_point = 0.5;

void fragment() {
	float target_weight = UV.y * bottom_point;
	
	if(get_dither_weight(ivec2(FRAGCOORD.xy)) > target_weight){
		COLOR = top_color;
	} else{
		COLOR = bottom_color;
	}
}
