extends Node2D

# Preload player class scenes
const PLAYER_FIGHTER = preload("res://Player/PlayerFighter.tscn")
const PLAYER_WIZARD = preload("res://Player/PlayerWizard.tscn")
const PLAYER_CLERIC = preload("res://Player/PlayerCleric.tscn")
const HEALTH_UI = preload("res://UI/HealthUI.tscn")

# Onready
onready var worldYsort = $YSort
onready var uiLayer = $CanvasLayer


func _ready():
	# Create a new instance of player's health
	var healthUI = HEALTH_UI.instance()
	uiLayer.add_child(healthUI)
	healthUI.margin_left = 8
	healthUI.margin_top = 8
	healthUI.margin_right = 40
	healthUI.margin_bottom = 40
	if TitleScreen.playerClass == "fighter":
		spawn_player(PLAYER_FIGHTER, 10)
	elif TitleScreen.playerClass == "wizard":
		spawn_player(PLAYER_WIZARD, 4)
	elif TitleScreen.playerClass == "cleric":
		spawn_player(PLAYER_CLERIC, 7)
	
func spawn_player(scene, max_health):
	var player = scene.instance()               # Save instance of player
	worldYsort.add_child(player)                # Add player to world
	player.global_position = Vector2.ZERO   # Set player position
	var cameraLink = player.get_node("CameraLink")
	cameraLink.set_remote_node("/root/World/Camera2D")
	PlayerStats.set_max_health(max_health)
