shader_type canvas_item;
render_mode light_only, blend_mul;


uniform float threshold = 32.0;

void fragment() {
	// Place fragment code here.
}

void light() {
	float sdf_val = clamp(texture_sdf(screen_uv_to_sdf(SCREEN_UV)) / threshold, -0.7, 1.0);
	vec3 sdf_scale = vec3(sdf_val);
	LIGHT = vec4(sdf_scale, 1.0);
}
