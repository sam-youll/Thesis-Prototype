extends Node3D
class_name AudioManager
#declaringevent variables
<<<<<<< Updated upstream
@onready var ambience : FmodEvent = null
@onready var character_sound: FmodEvent = null
@onready var player: PlayerCharacter = %PlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player = get_parent()
	#initializing events
	ambience = FmodServer.create_event_instance("event:/Ambience")
	character_sound = FmodServer.create_event_instance("event:/Character Sounds")
	#playing events
	ambience.start()
	character_sound.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#connecting FMOD parameters to player variables
	character_sound.set_parameter_by_name("PlayerSpeed", player.speed_param)
	
	#uncomment below when lean variables are done
	#character_sound.set_parameter_by_name("PlayerLean", player.zlean)
	#character_sound.set_parameter_by_name("PlayerGravity", player.xlean)
	
	#uncomment below when the raycast altitude variable is done
	#character_sound["event_parameter/PlayerAltitude/value"] = player.altitude

func _on_event_emitter_character_started() -> void:
	print("character sound started")
=======
#@onready var ambience : FmodEvent = null
#@onready var character_sound: FmodEvent = null
#
#@onready var player: PlayerCharacter = %PlayerCharacter
#
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#player = get_parent()
	##initializing events
	#ambience = FmodServer.create_event_instance("event:/Ambience")
	##character_sound = FmodServer.create_event_instance("event:/Character Sound")
	##playing events
	#ambience.start()
	##character_sound.start()
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#character_sound["event_parameter/PlayerSpeed/value"] = player.volume
#
#func _on_event_emitter_character_started() -> void:
	#print("character sound started")
>>>>>>> Stashed changes
