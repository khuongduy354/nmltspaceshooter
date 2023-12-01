extends Node2D

@export var drops = { 
	"HEALTH":0
}

func drop_item(): 
	var node = null 
	for drop in drops.keys(): 
		print(drop)
		if Global.percent_pick(drops[drop]): 
			match drop: 
				"HEALTH": 
					node = preload("res://Utility/health.tscn").instantiate()
	if node == null: 
		return 
	if Global.drop_item_list: 
		Global.drop_item_list.add_child(node)	
	node.global_position = global_position
	
