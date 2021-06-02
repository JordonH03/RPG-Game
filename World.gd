extends Node2D

# Preload player class scenes
const playerFighter = preload("res://Player/PlayerFighter.tscn")
const playerWizard = preload("res://Player/PlayerWizard.tscn")
const playerCleric = preload("res://Player/PlayerCleric.tscn")
const healthUI = preload("res://UI/HealthUI.tscn")

# Onready
onready var worldYsort = $YSort
onready var uiLayer = $CanvasLayer

func _ready():
	# Create a new instance of player's health
	var HealthUI = healthUI.instance()
	uiLayer.add_child(HealthUI)
	HealthUI.margin_left = 8
	HealthUI.margin_top = 8
	HealthUI.margin_right = 40
	HealthUI.margin_bottom = 40
	if TitleScreen.playerClass == "fighter":
		spawn_player(playerFighter, 10)
	elif TitleScreen.playerClass == "wizard":
		spawn_player(playerWizard, 4)
	elif TitleScreen.playerClass == "cleric":
		spawn_player(playerCleric, 7)
	
func spawn_player(scene, max_health):
	var player = scene.instance()               # Save instance of player
	worldYsort.add_child(player)                # Add player to world
	player.global_position = Vector2(160, 80)   # Set player position
	var cameraLink = player.get_node("CameraLink")
	cameraLink.set_remote_node("/root/World/Camera2D")
	PlayerStats.set_max_health(max_health)
