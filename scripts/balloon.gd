extends MeshInstance3D

@export var amplitude: float = 5
@export var frequency: float = 150 
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	time += delta
	position.y = sin(time * frequency) * amplitude
	print(position.y)
	
