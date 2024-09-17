shader_type canvas_item;
global uniform sampler2D heightmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(heightmap, UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
