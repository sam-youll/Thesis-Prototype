extends RigidBody3D

var repulsors := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 4:
		repulsors.append(get_child(i))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
	
func _physics_process(_delta: float) -> void:
#	print(str(position))
	
	for r in repulsors:
		var raycast: RayCast3D = r.get_child(0)
		if not raycast.is_colliding():
			continue
		var x := raycast.target_position.y - (position - raycast.get_collision_point()).y
		var repulsor_strength := 1
		var damper := 1
		var repulsor_force: float = (x * repulsor_strength) - (get_linear_velocity().y * damper)
		repulsor_force = clamp(repulsor_force, 0, 10)
		print(repulsor_force)
		var force := transform.basis.y * repulsor_force
		apply_force(force, r.position)
		
	if transform.basis.y.dot(Vector3.UP) < 0:
		add_constant_torque(Vector3.UP - transform.basis.y)
	else:
		set_constant_torque(Vector3.ZERO)
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		apply_central_force(Vector3(input_dir.x, 0, input_dir.y))

	var input_turn := Input.get_axis("turn_right", "turn_left")
	if input_turn:
		apply_torque(Vector3(input_turn, 0, 0))
