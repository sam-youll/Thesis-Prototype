extends Node3D
class_name AudioManager
#declaringevent variables
@onready var ambience : FmodEvent = null
@onready var character_sound: FmodEvent = null

@onready var player: PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	#initializing events
	ambience = FmodServer.create_event_instance("event:/Ambience")
	#character_sound = FmodServer.create_event_instance("event:/Character Sound")
	#playing events
	ambience.start()
	#character_sound.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character_sound["event_parameter/PlayerSpeed/value"] = player.volume

func _on_event_emitter_character_started() -> void:
	print("character sound started")
