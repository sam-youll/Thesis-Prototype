shader_type spatial;
global uniform sampler2D heightmap;
global uniform sampler2D normalmap;
global uniform float amplitude;

uniform sampler2D albedo;
uniform sampler2D normal;
uniform sampler2D roughness;
uniform sampler2D specular;

uniform float UV_scale = 1;

varying vec2 texture_position;

void vertex(){
	vec3 world_vertex = VERTEX + MODEL_MATRIX[3].xyz;
	texture_position = (world_vertex.xz + 0.5)/float(textureSize(heightmap,0).x);
	VERTEX.y = texture(heightmap,texture_position).r * amplitude;

}

void fragment() {
	NORMAL_MAP = mix(texture(normal, texture_position * UV_scale).rgb, texture(normalmap,texture_position).rgb, .9);
	ALBEDO = mix(texture(albedo, texture_position * UV_scale).rgb, vec3(.15,.1,.4), .9);
	SPECULAR = texture(specular, texture_position * UV_scale).r;
	ROUGHNESS = texture(roughness, texture_position * UV_scale).r;
}
