tool
extends Area

class_name Damageable
signal on_no_health
signal on_max_health
signal on_damage
signal on_heal

export(int, 0, 10000) var health: int

var currentHealth: int
var ignoreDamage: bool = false

func _ready():
	if !currentHealth: 
		self.currentHealth = self.health

func damage(damage: int):
	if ignoreDamage:
		return
	currentHealth = max(currentHealth - damage, 0)
	emit_signal("on_damage", damage)
	if currentHealth <= 0:
		emit_signal("on_no_health")
		
func heal(heal: int):
	currentHealth = min(heal+currentHealth, health)
	emit_signal("on_heal", heal)
	if currentHealth >= health:
		emit_signal("on_max_health")

func get_currentHealth() -> int:
	return currentHealth

func _get_configuration_warning():
	if !health:
		return 'Health must be > 0'
		
	return ''
