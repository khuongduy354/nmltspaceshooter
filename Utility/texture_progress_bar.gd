extends TextureProgressBar

var entity = null
func _ready(): 
	entity = owner
	entity.hp_changed.connect(_on_hp_changed)
	max_value = entity.max_hp
	value = max_value
func _on_hp_changed(val): 
	value = val
