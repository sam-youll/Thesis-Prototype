extends Node

@export var player: PlayerCharacter

var heightmap_tex: Texture2D
var heightmap_img: Image
var radius: int = 10
const BLACK_SQUARE = preload("res://assets/black square.png")
var pos_x
var pos_z
var volume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	init_heightmap()

func _physics_process(delta: float) -> void: 
	pass
	if pos_x != null:
		update_heightmap()

func init_heightmap() -> void:
	heightmap_img = Image.create_empty(512, 512, false, Image.FORMAT_L8)
	print(heightmap_img.get_width())
	for x in 512:
		for y in 512:
			heightmap_img.set_pixel(x, y, Color(0, 0, 0))
			
func update_heightmap() -> void:
	#var remapped_x: int = floor(remap(pos_x, -128, 128, 0, 512))
	#var remapped_z: int = floor(remap(pos_z, -128, 128, 0, 512))
	for x in radius * 2:
		for z in radius * 2:
			var mx: int = pos_x + x - radius
			var mz: int = pos_z + z - radius
			var dist: float = (radius - clamp(((Vector2(pos_x, pos_z) - Vector2(mx, mz)).length()), 0, radius)) / radius
			var col_val: float = volume * dist
			col_val = clamp(col_val, 0, 1)
			var col: Color = Color(col_val, col_val, col_val)
			heightmap_img.set_pixel(mx, mz, col)
	RenderingServer.global_shader_parameter_set("heightmap", heightmap_img)

func get_height(x, z) -> float:
	var size = heightmap_img.get_width()
	var amplitude : float = ProjectSettings.get_setting("shader_globals/amplitude").value
	return heightmap_img.get_pixel(fposmod(x,size), fposmod(z,size)).r * amplitude
