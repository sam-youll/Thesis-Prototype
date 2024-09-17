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

void vertex(){
	//vec3 world_vertex = VERTEX + MODEL_MATRIX[3].xyz;
	//texture_position = (VERTEX.xz * vec2(2) + 0.5);
	VERTEX.y = texture(heightmap, UV).r * amplitude;

}

void fragment() {
	//NORMAL_MAP = mix(texture(normal, texture_position * UV_scale).rgb, texture(normalmap,texture_position).rgb, .9);
	//ALBEDO = mix(texture(albedo, texture_position * UV_scale).rgb, vec3(.15,.1,.4), .9);
	ALBEDO = texture(heightmap, UV).rgb;
	//SPECULAR = texture(specular, texture_position * UV_scale).r;
	//ROUGHNESS = texture(roughness, texture_position * UV_scale).r;
}
