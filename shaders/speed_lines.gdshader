shader_type canvas_item;

#define USE_RADIAL_MODE 1
#define USE_DRAW_SPEED_LINES 1
#define USE_DISTORTION 1

#if USE_DISTORTION
uniform sampler2D screen_tex : hint_screen_texture, repeat_disable;
#endif
uniform sampler2D noise_tex : repeat_enable;

#if USE_DRAW_SPEED_LINES
uniform vec3 line_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float line_opacity : hint_range(0.0, 1.0) = 1.0;
uniform float color_levels = 2.0;
#endif

uniform float power:hint_range(0.0, 10.0, 0.1) = 0.0;
uniform float speed_v = 0.1;

#if USE_RADIAL_MODE
uniform vec2  radial_center = vec2(0.5);
uniform float radial_zoom = 0.01;
uniform float radial_repeat = 10.0;
uniform float radial_min : hint_range(0.0, 1.0) = 0.05;
uniform float radial_max : hint_range(0.0, 1.0) = 0.75;
#endif

#if USE_DISTORTION
uniform float dist_strength = 1.0;
uniform float dist_power = 4.0;
#endif

#if USE_RADIAL_MODE
vec2 polar_coordinates(vec2 uv, vec2 center, float zoom, float repeat, float offset){
	vec2 dir = uv - center;
	float radius = length(dir) * 2.0;
	float angle = atan(dir.y, dir.x) * 1.0/TAU;
	return mod(vec2(radius * zoom - offset, angle * repeat), 1.0);
}
#endif 

vec2 rotate_uv(vec2 uv, vec2 pivot, float angle){
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),vec2(cos(angle), sin(angle)));
	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void fragment() {
	float tv = TIME * speed_v;
	
#if USE_RADIAL_MODE
	vec2 dir = -(UV - radial_center);
	vec2 src_uv = polar_coordinates(vec2(UV.x, UV.y), radial_center, radial_zoom, radial_repeat, tv);	
#endif
	float noi_val = texture(noise_tex, src_uv).r;

#if USE_RADIAL_MODE
	float vig_mask = smoothstep(radial_min, radial_max, length(dir));
	noi_val *= vig_mask;
#endif
	noi_val = pow(noi_val, 10.0-power);
	float pre_posterized_val = noi_val;
	
#if USE_DRAW_SPEED_LINES
	noi_val = floor(noi_val * color_levels) / (color_levels - 1.0);
#endif
	vec3 final_col = vec3(0.0);
	float alpha = 0.0;

#if USE_DRAW_SPEED_LINES
	final_col = line_color;
	alpha = noi_val * line_opacity;
#endif

#if USE_DISTORTION
	float dist_val = pow(pre_posterized_val, dist_power) * dist_strength;
	vec2 dist_vec = dir * dist_val;
	vec2 distorted_uvs = UV + dist_vec;
	vec4 scr = texture(screen_tex, distorted_uvs);

	final_col = scr.rgb;
	alpha = 1.0;
#endif

#if USE_DRAW_SPEED_LINES && USE_DISTORTION
	final_col = mix(final_col, line_color, noi_val * line_opacity);
#endif
	COLOR = vec4(final_col, alpha);
}
