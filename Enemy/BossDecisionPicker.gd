extends Node
class_name BossDecisionPicker

var boss:BossI = null 
var prob_table = { 
	"CIRCLE":20,
	"NONE":5, 
	"STRAIGHT":15, 
	"LASER":20,
	"SPAWN":25,
	"TRIPLE":15, # pick 3 guns, 45 degrees spread
}
func _initialize_(b:BossI): 
	boss = b
func pick_shoot_pattern(): 
	for act in prob_table.keys(): 
		var per = prob_table[act]
		if Global.percent_pick(per): 
			return str_to_enum(act)
	return boss.shoot_patterns.NONE

func str_to_enum(val): 
	return boss.shoot_patterns.get(val)
	

