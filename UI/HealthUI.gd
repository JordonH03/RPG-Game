extends Control

# Onready
onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty

# Variables
var hearts : int setget set_hearts
var maxHearts : int setget set_max_hearts

func _ready():
	self.maxHearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	# Connects signals from PlayerStats to HealthUI.gd
	PlayerStats.connect("health_changed", self, "set_hearts")
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")

func set_hearts(value):
	hearts = clamp(value, 0, maxHearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 15
	
func set_max_hearts(value):
	maxHearts = max(value, 1)
	self.hearts = min(hearts, maxHearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = maxHearts * 15
