shader_type sky;

group_uniforms sky_colors;
uniform vec3 top_color : source_color = vec3(0.15, 0.4, 0.75);
uniform vec3 bottom_color : source_color = vec3(0.55, 0.7, 0.85);

group_uniforms clouds;
uniform vec4 cloud_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float cloud_speed : hint_range(0.0, 5.0) = 0.8;
uniform float cloud_coverage : hint_range(0.0, 1.0) = 0.7;
uniform float cloud_scale : hint_range(0.1, 5.0) = 2.5;
uniform float cloud_brightness : hint_range(0.5, 3.0) = 1.0;
uniform float cloud_sharpness : hint_range(0.05, 0.5) = 0.3;
uniform float horizon_glow : hint_range(0.0, 2.0) = 0.5;

group_uniforms stars;
uniform bool enable_stars = false;
uniform float stars_intensity : hint_range(0.0, 5.0, 0.1) = 1.0;
uniform vec4 star_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float twinkle_speed : hint_range(0.1, 5.0, 0.1) = 2.0;

float hash(vec2 p) {
	p = fract(p * vec2(123.34, 456.21));
	p += dot(p, p + 45.32);
	return fract(p.x * p.y);
}

vec3 hash3( vec3 x ){
	x = vec3( dot(x,vec3(127.1,311.7, 74.7)),
			  dot(x,vec3(269.5,183.3,246.1)),
			  dot(x,vec3(113.5,271.9,124.6)));
	return fract(sin(x)*43758.5453123);
}

vec3 voronoi( in vec3 x ){
	vec3 p = floor( x );
	vec3 f = fract( x );
	
	float id = 0.0;
	vec2 res = vec2( 100.0 );
	for( int k=-1; k<=1; k++ )
	for( int j=-1; j<=1; j++ )
	for( int i=-1; i<=1; i++ ) {
		vec3 b = vec3( float(i), float(j), float(k) );
		vec3 r = vec3( b ) - f + hash3( p + b );
		float d = dot( r, r );
		if( d < res.x ) {
			id = dot( p+b, vec3(1.0,57.0,113.0 ) );
			res = vec2( d, res.x );
		} else if( d < res.y ) {
			res.y = d;
		}
	}
	return vec3( sqrt( res ), abs(id) );
}

float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash(i);
	float b = hash(i + vec2(1.0, 0.0));
	float c = hash(i + vec2(0.0, 1.0));
	float d = hash(i + vec2(1.0, 1.0));
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
	float total = 0.0;
	float amp = 0.5;
	for (int i = 0; i < 4; i++) {
		total += amp * noise(p);
		p *= 2.0;
		amp *= 0.5;
	}
	return total;
}

void sky() {
	float ed = EYEDIR.y;
	
	float gradient_fac = clamp(ed * 1.3, 0.0, 1.0);
	vec3 final_color = mix(bottom_color, top_color, gradient_fac);
	
	float h_glow = exp(-abs(ed) * 6.0) * horizon_glow;
	final_color += bottom_color * h_glow;
	
	float cloud_shape = 0.0;
	if (ed > -0.05) {
		vec2 time_offset = vec2(mod(TIME * cloud_speed * 0.6, 200.0), mod(TIME * cloud_speed * 0.2, 200.0));
		vec2 uv = (EYEDIR.xz / (abs(ed) + 0.2)) * cloud_scale + time_offset;
		
		float n1 = fbm(uv);
		float n2 = fbm(uv * 1.8 + vec2(2.1, 3.4));
		float combined_clouds = n1 * 0.65 + n2 * 0.35;
		
		cloud_shape = smoothstep(1.0 - cloud_coverage, (1.0 - cloud_coverage) + cloud_sharpness, combined_clouds);
		
		float horizon_fade = smoothstep(-0.02, 0.15, ed);
		cloud_shape *= horizon_fade;
	}
	
	if (enable_stars && stars_intensity > 0.0 && ed > 0.02 && cloud_shape < 0.05) {
		vec3 star_dir = EYEDIR;
		vec2 stars = voronoi(star_dir * 30.0).xz;
		
		float size_rand = hash3(vec3(stars.y)).x;
		float thickness = mix(0.015, 0.04, size_rand);
		
		float twinkle = smoothstep(thickness + ((1.0 + sin(TIME * twinkle_speed + stars.y * 10.0)) / 2.0) * 0.02, 0.0, stars.x);
		
		float view_mask = smoothstep(0.02, 0.2, ed);
		final_color += star_color.rgb * (twinkle * stars_intensity * view_mask * (0.5 + size_rand * 0.5));
	}
	
	if (ed > -0.05 && cloud_shape > 0.0) {
		vec3 final_cloud_col = cloud_color.rgb * cloud_brightness;
		final_color = mix(final_color, final_cloud_col, cloud_shape * 0.9);
	}
	
	COLOR = final_color;
}
