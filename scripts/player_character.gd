extends CharacterBody3D
class_name PlayerCharacter

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
var ride_spring_damper: float = .1
var speed: float
@export var jump_vel: float
var is_jumping: bool = false
@onready var you_are_here: TextureRect = $"../UI/SubViewportContainer/SubViewport/YouAreHere"
@export var music_terrain: MusicTerrain

# CAMERA
@export_group("Camera Properties")
@export var cam_speed: float

# OTHER
@export_group("Other Stuff")
@export var volume_meter: Panel
var volume: float
# world bounds
var pos_x: int
var pos_z: int

signal pos_updated(pos_x, pos_z)

func _ready() -> void:
	hover_raycast.target_position = Vector3(0, -100, 0)
	speed = default_speed
	
func _physics_process(delta: float) -> void:
#	print(pos_x)
	#if position.y < music_terrain.get_height(pos_x, pos_z) * music_terrain.amplitude:
		#position.y = music_terrain.get_height(pos_x, pos_z) * music_terrain.amplitude
	
	# === CAMERA CONTROLLER === #
	cam.global_position = lerp(cam.global_position, cam_target.global_position, cam_speed)
	cam_look_target.global_position = lerp(cam.global_position, global_position, cam_speed)
	cam.look_at(cam_look_target.position)
	
	# === MOVEMENT CONTROLLER === #
	# Hover off ground.
	# hover raycast is top level, so it won't rotate with parent, but we still want it to move with parent
	hover_raycast.position = position
	if hover_raycast.is_colliding():
		# ray_length is generally between .02 and .5
		var ray_length = hover_raycast.position.y - hover_raycast.get_collision_point().y
		var ray_dir_vel = velocity.dot(Vector3(0, -1, 0))
		var x = ray_length - ride_height
		var spring_force
		if ray_length > ride_height * 2:
			spring_force = .2
		else:
			spring_force = (x * ride_spring_strength) - (ray_dir_vel * ride_spring_damper)
		velocity.y += -1 * spring_force
	
	
	var pitch_scalar := Input.get_axis("move_backward", "move_forward")
	## Add the gravity.
	#if not hover_raycast.is_colliding():
		#velocity += get_gravity() * .5*(pitch_scalar+2) * delta
		#
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and !is_jumping:
		velocity.y += jump_vel
		is_jumping = true
	
	if is_jumping:
		if velocity.y < 0 and hover_raycast.position.y - hover_raycast.get_collision_point().y < ride_height:
			is_jumping = false
	
	if Input.is_action_pressed("speed_up"):
		speed = move_toward(speed, max_speed, .2)
	elif Input.is_action_pressed("speed_down"):
		speed = move_toward(speed, -2, .1)
	else:
		speed = move_toward(speed, 0, .05)
	
	volume = remap(speed, 0, 10, 0, 1)
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
#	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var direction := -basis.z
#	if direction:
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
#	else:
#		velocity.x = move_toward(velocity.x, 0, speed/4)
#		velocity.z = move_toward(velocity.z, 0, speed/4)
	
	var target_basis := Basis.IDENTITY
	target_basis.rotated(Vector3.UP, basis.get_euler().y)
	target_basis = target_basis.rotated(Vector3.RIGHT, input_dir.y/2)
	target_basis = target_basis.rotated(Vector3.BACK, -input_dir.x/2)
	var input_turn := Input.get_axis("turn_right", "turn_left")
	target_basis = target_basis.rotated(Vector3.UP, basis.get_euler().y + input_turn/2)
	basis = basis.slerp(target_basis, .1)
	
	
	update_pos()
	
	move_and_slide()
	
	# === POSITION WRAP === #
	if position.x > 128:
		position.x = -128
	if position.x < -128:
		position.x = 128
	if position.z > 128:
		position.z = -128
	if position.z < -128:
		position.z = 128
		
	volume_meter.material["shader_parameter/value"] = volume
	you_are_here.set_position(Vector2(pos_x - 14, pos_z - 14))
	you_are_here.set_rotation(-basis.get_euler().y)
	
func update_pos() -> void:
	pos_x = floor(remap(position.x, -128, 128, 0, 511))
	pos_x = clamp(pos_x, 0, 511)
	pos_z = floor(remap(position.z, -128, 128, 0, 511))
	pos_z = clamp(pos_z, 0, 511)
	pos_updated.emit(pos_x, pos_z, volume)
	
