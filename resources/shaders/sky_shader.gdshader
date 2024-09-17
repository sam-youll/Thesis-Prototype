shader_type sky;
uniform sampler2D noise;

void sky() {
	vec2 coords = vec2(	2.*texture(noise, SKY_COORDS + sin(.001*TIME) + .003*TIME).r, 
						.5*sin(.1*TIME)*texture(noise, SKY_COORDS).g).rg;
	vec3 warp = texture(noise, SKY_COORDS + texture(noise, coords + texture(noise, coords).rg).rg).rgb;
	
	vec3 color = vec3(.08, .01, .2);
	color = mix(color, vec3(.05, .05, .3), coords.r);
	//color = mix(color, vec3(.1), .9);
	color = mix(color, vec3(.8, .4, .02), warp.r);
	color = mix(color, vec3(.02,.01,.01), -sin(SKY_COORDS.x * PI)*.5);
	COLOR = color;
}