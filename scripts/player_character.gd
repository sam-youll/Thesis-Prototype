extends CharacterBody3D
class_name PlayerCharacter

@onready var cam: Camera3D = $Camera3D
@onready var cam_target: Node3D = $CameraTarget
@onready var cam_look_target: Node3D = $CamLookTarget

# MOVEMENT
@export_group("Movement Properties")
@export var max_speed: float
var speed: float
@export var jump_vel: float
@onready var you_are_here: TextureRect = $"../UI/SubViewportContainer/SubViewport/YouAreHere"
@export var music_terrain: MusicTerrain
enum State {
	stand,
	crouch,
	air,
	crash
}
var state: State = State.stand

# CAMERA
@export_group("Camera Properties")
@export var cam_speed: float

# OTHER
@export_group("Other Stuff")
@export var volume_meter: Panel
var speed_param: float
# world bounds
var pos_x: int
var pos_z: int
var zlean: float
var xlean: float
var altitude: float

func _physics_process(delta: float) -> void:
	
	# === CAMERA CONTROLLER === #
	cam.global_position = lerp(cam.global_position, cam_target.global_position, cam_speed)
	cam_look_target.global_position = lerp(cam.global_position, global_position + Vector3.UP, cam_speed)
	cam.look_at(cam_look_target.position)
	
	# === MOVEMENT CONTROLLER === #
	zlean = Input.get_axis("move_left", "move_right")
	xlean = Input.get_axis("move_backward", "move_forward")
	
	match state:
		State.stand:
			scale.y = 1
			
			speed = move_toward(speed, max_speed * (xlean + 1) * .5, .03)
			
			var target_basis := Basis.IDENTITY
			target_basis.rotated(Vector3.UP, basis.get_euler().y)
			target_basis = target_basis.rotated(Vector3.RIGHT, -xlean/2)
			target_basis = target_basis.rotated(Vector3.BACK, -zlean/2)
			target_basis = target_basis.rotated(Vector3.UP, basis.get_euler().y - zlean/3)
			basis = basis.slerp(target_basis, .1)
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_vel * .6
				state = State.air
			if Input.is_action_pressed("crouch"):
				state = State.crouch
			
			if !is_on_floor():
				state = State.air
		State.crouch:
			scale.y = 1
			
			speed = move_toward(speed, max_speed * (xlean + 1), .03)
			
			zlean = remap(zlean, -1, 1, -.5, .5)
			xlean = remap(xlean, -1, 1, -.5, .5)
			
			var target_basis := Basis.IDENTITY
			target_basis.rotated(Vector3.UP, basis.get_euler().y)
			target_basis = target_basis.rotated(Vector3.RIGHT, -xlean/2)
			target_basis = target_basis.rotated(Vector3.BACK, -zlean/2)
			target_basis = target_basis.rotated(Vector3.UP, basis.get_euler().y - zlean/4)
			basis = basis.slerp(target_basis, .1)
			
			scale.y = .7
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_vel
				state = State.air
			if !Input.is_action_pressed("crouch"):
				state = State.stand
			
			if !is_on_floor():
				state = State.air
		State.air:
			if is_on_floor():
				var player_up = basis.y
				if player_up.dot(get_floor_normal()) < .2:
					state = State.crash
				else:
					state = State.stand
			
			velocity.y -= .15
		State.crash:
			speed = lerp(speed, 0, .3)
			if speed <= 0.1:
				state = State.stand
	var direction = -basis.z
	velocity.z = direction.z * speed
	velocity.x = direction.x * speed
	move_and_slide()
	
	update_pos()
	
	volume_meter.material["shader_parameter/value"] = speed_param
	you_are_here.set_position(Vector2(pos_x - 14, pos_z - 14))
	you_are_here.set_rotation(-basis.get_euler().y)
	
	altitude = remap(position.y, 0, 20, 0, 1)
	speed_param = remap(speed, 0, max_speed, 0, 1)

func update_pos():
	var mw = music_terrain.map_width * music_terrain.map_scale * .5
	var mh = music_terrain.map_height * music_terrain.map_scale * .5
	pos_x = floor(remap(position.x, -mw, mw, 0, music_terrain.map_width - 1))
	pos_x = clamp(pos_x, 0, music_terrain.map_width - 1)
	pos_z = floor(remap(position.z, -mh, mh, 0, music_terrain.map_height - 1))
	pos_z = clamp(pos_z, 0, music_terrain.map_height - 1)
