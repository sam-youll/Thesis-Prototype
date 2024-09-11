extends Node3D
class_name AudioManager

@onready var ambience  := $EventEmitterAmbience
@onready var music  := $EventEmitterMusic
@onready var character_sound  := $EventEmitterCharacter
@onready var player: PlayerCharacter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	character_sound["event_parameter/SpeedVolume/value"] = player.volume

func _on_event_emitter_character_started() -> void:
	print("character sound started")
