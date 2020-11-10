tool
extends Spatial

export var attackAreaPath: NodePath
export var defaultDamage: int

var attackArea: Area

func _ready():
	attackArea = get_node(attackAreaPath)

func attack():
	var areas = attackArea.get_overlapping_areas()
	for area in areas:
		if area.has_method('damage'):
			area.damage(defaultDamage)

func _get_configuration_warning():
	if !defaultDamage:
		return "Need set property: defaultDamage"
	
	if !attackAreaPath:
		return "Need set property: attackAreaPath"
	
	var check = get_node(attackAreaPath)
	if !(check is Area):
		return "Property attachArea must be path to 'Area'"
		
	return ''
