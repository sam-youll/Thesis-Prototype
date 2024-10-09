extends Node3D
class_name AudioManager
#declaring event variables

@onready var ambience : FmodEvent = null
@onready var character_sound: FmodEvent = null
@onready var melody : FmodEvent = null
@onready var player: PlayerCharacter = %PlayerCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player = get_parent()
	
	#initializing events
	ambience = FmodServer.create_event_instance("event:/Ambience")
	character_sound = FmodServer.create_event_instance("event:/Character Sounds")
	melody = FmodServer.create_event_instance("event:/mus_lead")
	
	#playing events
	ambience.start()
	character_sound.start()
	melody.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#connecting FMOD parameters to player variables
	character_sound.set_parameter_by_name("PlayerSpeed", player.speed_param)
	character_sound.set_parameter_by_name("PlayerLean", player.zlean)
	character_sound.set_parameter_by_name("PlayerGravity", player.xlean)
	character_sound.set_parameter_by_name("PlayerAltitude", player.altitude)
	
	#change variable name and uncomment this out when height variable is set 
	#character_sound.set_parameter_by_name("Terrain Height", player.variablename)
	
	if Input.is_action_just_pressed("jump"):
		FmodServer.play_one_shot("event:/jump sfx")

func _on_event_emitter_character_started() -> void:
	print("character sound started")
