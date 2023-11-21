extends Node
class_name BossDecisionPicker

var boss:BossI = null 
var prob_table = { 
	"CIRCLE":20,
	"NONE":5, 
	"STRAIGHT":25, 
	"LASER":20,
	"SPAWN":15,
	"TRIPLE":15, # pick 3 guns, 45 degrees spread
}
func _initialize_(b:BossI): 
	boss = b
func pick_shoot_pattern(): 
	var act = prob_table.keys()[randi()%prob_table.size()]
	while true:
		var per = prob_table[act]
		if Global.percent_pick(per): 
			return str_to_enum(act)
		act = prob_table.keys()[randi()%prob_table.size()]
			

func str_to_enum(val): 
	return boss.shoot_patterns.get(val)
	

