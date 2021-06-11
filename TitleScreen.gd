extends Node2D

# Preload
const WORLD = preload("res://World.tscn")

# Variables
var playerClass = null

func _on_SelectFighter_pressed():
	get_tree().change_scene_to(WORLD)
	TitleScreen.playerClass = "fighter"
	

func _on_SelectWizard_pressed():
	get_tree().change_scene_to(WORLD)
	TitleScreen.playerClass = "wizard"


func _on_SelectCleric_pressed():
	get_tree().change_scene_to(WORLD)
	TitleScreen.playerClass = "cleric"
	
