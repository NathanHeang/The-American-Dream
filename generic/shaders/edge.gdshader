shader_type canvas_item; 
 
const float SQRT3 = 1.7320508; 
 
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap; 
 
uniform float hex_size : hint_range(0.02, 0.6) = 0.16;
uniform int mirror_segments : hint_range(3, 12) = 6;
uniform float rotation_speed : hint_range(-4.0, 4.0) = 0.2;
uniform float source_zoom : hint_range(0.2, 3.0) = 1.0;
 
uniform vec2 center = vec2(0.5, 0.5); 
 
uniform float vignette_start : hint_range(0.0, 1.0) = 0.3;
uniform float vignette_end : hint_range(0.0, 1.5) = 0.8;
 
uniform float darken_amount : hint_range(0.0, 1.0) = 0.35; 
 
vec2 rotate(vec2 p, float ang) { 
	float s = sin(ang); 
	float c = cos(ang); 
	return vec2(p.x * c - p.y * s, p.x * s + p.y * c); 
} 
 
vec2 hex_axial(vec2 p, float size) { 
	float q = (SQRT3 / 3.0 * p.x - 1.0 / 3.0 * p.y) / size; 
	float r = (2.0 / 3.0 * p.y) / size; 
	return vec2(q, r); 
} 
 
vec2 hex_round(vec2 axial) { 
	float x = axial.x; 
	float z = axial.y; 
	float y = -x - z; 
 
	float rx = round(x); 
	float ry = round(y); 
	float rz = round(z); 
 
	float x_diff = abs(rx - x); 
	float y_diff = abs(ry - y); 
	float z_diff = abs(rz - z); 
 
	if (x_diff > y_diff && x_diff > z_diff) { 
		rx = -ry - rz; 
	} else if (y_diff > z_diff) { 
		ry = -rx - rz; 
	} else { 
		rz = -rx - ry; 
	} 
	return vec2(rx, rz); 
} 
 
vec2 hex_to_point(vec2 axial, float size) { 
	float x = size * (SQRT3 * axial.x + SQRT3 / 2.0 * axial.y); 
	float y = size * (3.0 / 2.0 * axial.y); 
	return vec2(x, y); 
} 
 
void fragment() { 
	vec2 uv = SCREEN_UV; 
	vec2 aspect_fix = vec2(1.0, SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y); 
 
	vec2 p = (uv - center) * aspect_fix; 
	float dist_from_center = length(p); 
 
	float k = smoothstep(vignette_start, vignette_end, dist_from_center); 
 
	vec2 pr = rotate(p, TIME * rotation_speed); 
 
	vec2 axial = hex_axial(pr, hex_size); 
	vec2 cell = hex_round(axial); 
	vec2 cell_center = hex_to_point(cell, hex_size); 
	vec2 local = pr - cell_center; 
 
	float local_dist = length(local); 
	float local_ang = atan(local.y, local.x); 
	float seg_angle = TAU / float(mirror_segments); 
	float a = mod(local_ang, seg_angle); 
	a = abs(a - seg_angle * 0.5); 
	vec2 folded = vec2(cos(a), sin(a)) * local_dist; 
 
	vec2 kal_p = folded * source_zoom; 
	vec2 kal_uv = center + kal_p / aspect_fix; 
	kal_uv = clamp(kal_uv, vec2(0.001), vec2(0.999)); 
 
	vec4 normal_color = texture(SCREEN_TEXTURE, uv); 
	vec4 kal_color = texture(SCREEN_TEXTURE, kal_uv); 
 
	vec4 result = mix(normal_color, kal_color, k); 
	result.rgb *= 1.0 - darken_amount * k; 
	COLOR = result; 
}
