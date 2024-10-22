extends CharacterBody3D
class_name PlayerCharacter

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

#GRIND RAIL
@export var grindrail: PackedScene
var current_rail: Node3D

var state: State = State.stand

# CAMERA
@onready var cam_spring: SpringArm3D = $SpringArm3D
@onready var cam: Camera3D = $SpringArm3D/Camera3D
var min_yaw: float = 0
var max_yaw: float = 360
var min_pitch: float = -80
var max_pitch: float = 50
@export_group("Camera Properties")
@export_range(.05, 1) var cam_speed: float = .3

# OTHER
@export_group("Other Stuff")
@export var volume_meter: Panel
var speed_param: float
var height_param: float
var pos_x: int
var pos_z: int
var zlean: float
var xlean: float
var altitude: float

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	floor_max_angle = 1
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rot = cam_spring.rotation_degrees
		rot.y -= event.relative.x * cam_speed
		rot.y = wrapf(rot.y, min_yaw, max_yaw)
		rot.x -= event.relative.y * cam_speed
		rot.x = clampf(rot.x, min_pitch, max_pitch)
		cam_spring.rotation_degrees = rot

func _physics_process(delta: float) -> void:
	cam_spring.position = position + Vector3(0, .5, 0)
	
	# === MOVEMENT CONTROLLER === #
	zlean = Input.get_axis("move_left", "move_right")
	xlean = Input.get_axis("move_backward", "move_forward")
	
	match state:
		State.stand:
			scale.y = 1
			
			speed = move_toward(speed, max_speed * (xlean + 1) * .5, .03)
			
			zlean = remap(zlean, -1, 1, -.7, .7)
			xlean = remap(xlean, -1, 1, -.7, .7)
			
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
				
			var direction = -basis.z
			velocity.z = direction.z * speed
			velocity.x = direction.x * speed
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
			
			var direction = -basis.z
			velocity.z = direction.z * speed
			velocity.x = direction.x * speed
		State.air:
			scale.y = 1
			
			if is_on_floor():
				var player_up = basis.y
				if player_up.dot(get_floor_normal()) < 0:
					state = State.crash
				else:
					state = State.stand
			
			var target_transform := transform
			target_transform = target_transform.rotated_local(Vector3.BACK, -zlean/20)
			target_transform = target_transform.rotated_local(Vector3.RIGHT, -xlean/20)
			transform = target_transform
			
			velocity.y -= .15
		State.crash:
			speed = lerp(speed, float(0), .3)
			if speed <= 0.1:
				state = State.stand
	
	#if music_terrain != null:
		#music_terrain.update_shape()
	move_and_slide()
	update_pos()
	
	
	volume_meter.material["shader_parameter/value"] = speed_param
	you_are_here.set_position(Vector2(pos_x - 14, pos_z - 14))
	you_are_here.set_rotation(-basis.get_euler().y)
	
	altitude = remap(position.y, 0, 20, 0, 1)
	speed_param = remap(speed, 0, max_speed, 0, 1)
	
	height_param = remap(music_terrain.get_height(pos_x, pos_z), 0, 1, 0, 12)
	
	if Input.is_action_just_pressed("spawn_grind_rail"):
		spawn_grind_rail()
	
	if Input.is_action_pressed("spawn_grind_rail"):
		current_rail.extend_rail(global_position)

func update_pos():
	var mw = music_terrain.map_width * music_terrain.map_scale * .5
	var mh = music_terrain.map_height * music_terrain.map_scale * .5
	pos_x = floor(remap(position.x, -mw, mw, 0, music_terrain.map_width - 1))
	pos_x = clamp(pos_x, 0, music_terrain.map_width - 1)
	pos_z = floor(remap(position.z, -mh, mh, 0, music_terrain.map_height - 1))
	pos_z = clamp(pos_z, 0, music_terrain.map_height - 1)
	
func spawn_grind_rail():
	var new_rail = grindrail.instantiate()
	get_parent().add_child(new_rail)
	current_rail = new_rail
