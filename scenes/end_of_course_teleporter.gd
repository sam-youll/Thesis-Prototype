extends Area3D

@onready var spawn_pos: Node3D = $SpawnPos
@onready var music_terrain: MusicTerrain = $"../MusicTerrain"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_overlapping_bodies():
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if body is PlayerCharacter:
				var mx = spawn_pos.global_position.x
				var mz = spawn_pos.global_position.z
				var my = music_terrain.get_height(spawn_pos.global_position.x * 2 + 256, spawn_pos.global_position.z * 2 + 256)
				body.position = Vector3(mx, my + 3, mz)
				
