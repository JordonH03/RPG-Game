extends Player

# Onready 
onready var sprite = $Sprite

func _ready():
	# Sets width of special outline to 0
	sprite.get_material().set_shader_param("size", 0.0)

func _physics_process(delta):
	if Input.is_action_just_pressed("special") and special == false and cooldown == false:
		hitbox.damage = 6
		special = true
		# Sets the outline to a visible width
		sprite.get_material().set_shader_param("size", 0.5)
		specialDuration.start()

func _on_SpecialDuration_timeout():
	special = false
	cooldown = true
	hitbox.damage = 3
	sprite.get_material().set_shader_param("size", 0.0) # Turn off outline
	specialCooldown.start()

func _on_SpecialCooldown_timeout():
	cooldown = false
