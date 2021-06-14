extends Node2D

# Preload
const WORLD = preload("res://World.tscn")

# Variables
var playerClass = ""

func _on_SelectFighter_pressed():
	spawn_class("fighter")

func _on_SelectWizard_pressed():
	spawn_class("wizard")

func _on_SelectCleric_pressed():
	spawn_class("cleric")
	
func spawn_class(playerClass):
	get_tree().change_scene_to(WORLD)
	TitleScreen.playerClass = playerClass
