extends Player

# Onready
onready var specialTimer = $SpecialTimer
onready var specialCooldown = $SpecialCooldown
onready var hitbox = $HitboxPivot/Hitbox
onready var canvasModulate = $CanvasModulate

# Variables
var special = false
var cooldown = false

func _physics_process(delta):
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		hitbox.damage *= 2
		specialTimer.start(10)

func _on_SpecialTimer_timeout():
	special = false
	cooldown = true
	specialCooldown.start(20)

func _on_SpecialCooldown_timeout():
	cooldown = false
