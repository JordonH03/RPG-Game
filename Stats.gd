extends Node

# Export
## Health
export(int) var max_health = 1 setget set_max_health

# Variables
var health = max_health setget set_health
	
# Signals
signal no_health # Creates a signal for 0 health
signal health_changed(value)
signal max_health_changed(value)

func _ready():
	self.health = max_health
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
