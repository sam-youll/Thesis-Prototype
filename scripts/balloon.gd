extends Node3D

# Movement variables
@export var amplitude: float = 5
@export var frequency: float = 150 
@export var balloon_body: Node3D
@export var balloon_knot: Node3D
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Sine wave movement
	time += delta
	position.y = sin(time * frequency) * amplitude

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "PlayerCharacter":
		# Balloon exploding
		balloon_body.visible = false
		balloon_knot.visible = false
		
		# knocks u over? 
		
		# set a timer for like one second before it resets 
		
		# resets level 
		
