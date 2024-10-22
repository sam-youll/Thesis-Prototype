@icon("res://assets/textures/node icons/playlist.svg")
extends Node3D
class_name AudioManager
#declaring event variables
#constant
#ambiences
@onready var amb_mountain : FmodEvent = null
@onready var amb_wind: FmodEvent = null
#char sound
@onready var character_sound: FmodEvent = null
#melody
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
	amb_mountain = FmodServer.create_event_instance("event:/amb_mountain")
	amb_wind = FmodServer.create_event_instance("event:/amb_wind")
	character_sound = FmodServer.create_event_instance("event:/Character Sounds")
	melody = FmodServer.create_event_instance("event:/mus_lead")
	#oneshot
	bass = FmodServer.create_event_instance("event:/mus_bass")
	chime = FmodServer.create_event_instance("event:/mus_chime")
	
	#playing events
	amb_mountain.start()
	amb_wind.start()
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
	
	
	if Input.is_action_just_pressed("jump"):
		FmodServer.play_one_shot("event:/jump sfx")

func _on_event_emitter_character_started() -> void:
	print("character sound started")
