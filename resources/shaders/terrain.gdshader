shader_type spatial;
uniform sampler2D heightmap;
//global uniform sampler2D normalmap;
uniform float amplitude;

uniform sampler2D albedo;
uniform sampler2D normal;
uniform sampler2D roughness;
uniform sampler2D specular;

uniform float UV_scale = 1;

varying vec2 texture_position;

float get_height(vec3 vert){
	vec2 tex_pos = (vert.xz + vec2(.5))/float(textureSize(heightmap, 0).x);
	return (texture(heightmap, tex_pos).r - .5) * amplitude;
}

vec3 get_normal(vec3 vert, float adjacent_dist){
	vec3 west_vert = vert + vec3(adjacent_dist, 0, 0);
	west_vert.y = get_height(west_vert);
	vec3 north_vert = vert + vec3(0, 0, adjacent_dist);
	north_vert.y = get_height(north_vert);
	return normalize(
		cross(
			north_vert - vert,
			west_vert - vert
		)
	);
}

void vertex(){
	vec3 world_vertex = VERTEX + MODEL_MATRIX[3].xyz;
	//texture_position = (VERTEX.xz * vec2(2) + 0.5);
	VERTEX.y = texture(heightmap, UV).r * amplitude;

}

void fragment() {
	//NORMAL_MAP = mix(texture(normal, texture_position * UV_scale).rgb, texture(normalmap,texture_position).rgb, .9);
	//ALBEDO = mix(texture(albedo, texture_position * UV_scale).rgb, vec3(.15,.1,.4), .9);
	ALBEDO = texture(heightmap, UV).rgb;
	//ALBEDO = vec3(0);
	//SPECULAR = texture(specular, texture_position * UV_scale).r;
	//ROUGHNESS = texture(roughness, texture_position * UV_scale).r;
}
