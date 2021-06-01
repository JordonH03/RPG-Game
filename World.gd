extends Node2D

# Preload player class scenes
const playerFighter = preload("res://Player/PlayerFighter.tscn")
const playerWizard = preload("res://Player/PlayerWizard.tscn")
const playerCleric = preload("res://Player/PlayerCleric.tscn")

# Onready
onready var worldYsort = $YSort

func _ready():
	var player
	if TitleScreen.playerClass == "fighter":
		PlayerStats.set_max_health(10)
		player = playerFighter.instance()
		worldYsort.add_child(player)
		player.global_position = Vector2(160, 80)
	elif TitleScreen.playerClass == "wizard":
		PlayerStats.set_max_health(4)
		player = playerWizard.instance()
		worldYsort.add_child(player)
		player.global_position = Vector2(160, 80)
	elif TitleScreen.playerClass == "cleric":
		PlayerStats.set_max_health(6)
		player = playerCleric.instance()
		worldYsort.add_child(player)
		player.global_position = Vector2(160, 80)
	var cameraLink = player.get_node("CameraLink")
	cameraLink.set_remote_node("/root/World/Camera2D")
	print(cameraLink.remote_path)
