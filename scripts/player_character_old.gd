extends CharacterBody3D
class_name PlayerCharacterOld

@onready var hover_raycast: RayCast3D = $HoverRayCast
@onready var cam: Camera3D = $Camera3D
@onready var cam_target: Node3D = $CameraTarget
@onready var cam_look_target: Node3D = $CamLookTarget

# MOVEMENT
@export_group("Movement Properties")
@export var default_speed: float
@export var max_speed: float
@export var ride_height: float = .5
var ride_spring_strength: float = 1.5
var ride_spring_damper: float = .15
var speed: float
@export var jump_vel: float
var is_jumping: bool = false
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
var crouching: bool

signal pos_updated(pos_x, pos_z)

func _ready() -> void:
	hover_raycast.target_position = Vector3(0, -100, 0)
	speed = default_speed


func _physics_process(delta: float) -> void:
	# === CAMERA CONTROLLER === #
	cam.global_position = lerp(cam.global_position, cam_target.global_position, cam_speed)
	cam_look_target.global_position = lerp(cam.global_position, global_position + Vector3.UP, cam_speed)
	cam.look_at(cam_look_target.position)
	
	# === MOVEMENT CONTROLLER === #
	zlean = Input.get_axis("move_left", "move_right")
	xlean = Input.get_axis("move_backward", "move_forward")
	crouching = Input.is_action_pressed("crouch")
	
	match state:
		State.stand:
			scale.y = 1
			
			speed = move_toward(speed, max_speed * (xlean + 1) * .5, .1)
			
			var target_basis := Basis.IDENTITY
			target_basis.rotated(Vector3.UP, basis.get_euler().y)
			target_basis = target_basis.rotated(Vector3.RIGHT, xlean/2)
			target_basis = target_basis.rotated(Vector3.BACK, zlean/2)
			var input_turn := Input.get_axis("turn_right", "turn_left")
			target_basis = target_basis.rotated(Vector3.UP, basis.get_euler().y + input_turn/2)
			basis = basis.slerp(target_basis, .1)
			
			if basis.y.dot(Vector3.UP) < .3:
				var bas = Basis.IDENTITY
				bas.y = basis.y
				basis.slerp(bas, .3)
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_vel * .6
				state = State.air
			if Input.is_action_pressed("crouch"):
				state = State.crouch
		State.crouch:
			scale.y = .7
			
			speed = move_toward(speed, max_speed * (xlean + 1), .1)
			
			zlean = remap(zlean, -1, 1, -.5, .5)
			
			var target_basis := Basis.IDENTITY
			target_basis.rotated(Vector3.UP, basis.get_euler().y)
			target_basis = target_basis.rotated(Vector3.RIGHT, xlean/2)
			target_basis = target_basis.rotated(Vector3.BACK, zlean/2)
			var input_turn := Input.get_axis("turn_right", "turn_left")
			target_basis = target_basis.rotated(Vector3.UP, basis.get_euler().y + input_turn/2)
			basis = basis.slerp(target_basis, .1)
			
			if basis.y.dot(Vector3.UP) < .3:
				var bas = Basis.IDENTITY
				bas.y = basis.y
				basis.slerp(bas, .3)
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = jump_vel
				state = State.air
			if !Input.is_action_pressed("crouch"):
				state = State.stand
		State.air:
			if is_on_floor:
				var player_up = basis.y
				if player_up.dot(get_floor_normal()) < .2:
					state = State.crash
				else:
					state = State.stand
			
			velocity.y += get_gravity().y
		State.crash:
			speed = lerp(speed, 0, .3)
			if speed <= 0.1:
				state = State.stand
	
	move_and_slide()
	
	update_pos()
		
	volume_meter.material["shader_parameter/value"] = speed_param
	you_are_here.set_position(Vector2(pos_x - 14, pos_z - 14))
	you_are_here.set_rotation(-basis.get_euler().y)
	
func update_pos() -> void:
	var mw = music_terrain.map_width * music_terrain.map_scale * .5
	var mh = music_terrain.map_height * music_terrain.map_scale * .5
	pos_x = floor(remap(position.x, -mw, mw, 0, music_terrain.map_width - 1))
	pos_x = clamp(pos_x, 0, music_terrain.map_width - 1)
	pos_z = floor(remap(position.z, -mh, mh, 0, music_terrain.map_height - 1))
	pos_z = clamp(pos_z, 0, music_terrain.map_height - 1)
	pos_updated.emit(pos_x, pos_z, speed_param)
