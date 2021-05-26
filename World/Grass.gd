extends Node2D
		
const GrassEffect = preload("res://Effects/GrassEffect.tscn")# Saves the scene as variable 

func create_grass_effect():
	var grassEffect = GrassEffect.instance()                 # Create instance/copy of scene
	get_parent().add_child(grassEffect)                      # Add scene instance to grass node
	grassEffect.global_position = global_position            # Set scene position

# Signal Functions

func _on_Hurtbox_area_entered(_area):
	create_grass_effect()
	queue_free()
	
