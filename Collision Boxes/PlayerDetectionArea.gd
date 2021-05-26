extends Area2D

# Variables
var player = null

func _physics_process(_delta):
	pass

func can_see_player():
	return player != null

# Signal Functions 

func _on_PlayerDetectionArea_body_entered(body):
	player = body

func _on_PlayerDetectionArea_body_exited(_body):
	player = null
	
