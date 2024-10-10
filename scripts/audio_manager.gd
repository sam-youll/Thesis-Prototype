@icon("res://assets/textures/node icons/playlist.svg")
extends Node3D
class_name AudioManager
#declaring event variables
#constant
@onready var ambience : FmodEvent = null
@onready var character_sound: FmodEvent = null
@onready var melody : FmodEvent = null
@onready var player: PlayerCharacter = %PlayerCharacter

#oneshot
@onready var bass : FmodEvent = null
@onready var chime : FmodEvent = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player = get_parent()
	
	#initializing events
	#constant
	ambience = FmodServer.create_event_instance("event:/Ambience")
	character_sound = FmodServer.create_event_instance("event:/Character Sounds")
	melody = FmodServer.create_event_instance("event:/mus_lead")
	#oneshot
	bass = FmodServer.create_event_instance("event:/mus_bass")
	chime = FmodServer.create_event_instance("event:/mus_chime")
	
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
	
	chime.set_parameter_by_name("PlayerLean", player.zlean)
	chime.set_parameter_by_name("PlayerGravity", player.xlean)
	
	bass.set_parameter_by_name("PlayerLean", player.zlean)
	bass.set_parameter_by_name("PlayerGravity", player.xlean)
	
	melody.set_parameter_by_name("TerrainHeight", player.height_param)
	melody.set_parameter_by_name("PlayerLean", player.zlean)
	melody.set_parameter_by_name("PlayerGravity", player.xlean)
	
	ambience.set_parameter_by_name("PlayerLean", player.zlean)
	ambience.set_parameter_by_name("PlayerGravity", player.xlean)
	
	if Input.is_action_just_pressed("jump"):
		FmodServer.play_one_shot("event:/jump sfx")

func _on_event_emitter_character_started() -> void:
	print("character sound started")
