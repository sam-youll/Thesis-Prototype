extends Node3D

#event variables
var ambience: FmodEvent = null
var music: FmodEvent = null
var characterSound: FmodEvent = null
#parameter variable - should be continuous 0-1
var speedVolume: float = .5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#initializing FMOD events
	ambience = FmodServer.create_event_instance("event:/Ambience")
	music = FmodServer.create_event_instance("event:/Music")
	characterSound = FmodServer.create_event_instance("event:/Character Sound")
	#setting parameters
	characterSound.set_parameter_by_name("SpeedVolume", speedVolume)
	#playing the sounds at the start of the scene
	ambience.play()
	music.play()
	characterSound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass#speedVolume = 0
