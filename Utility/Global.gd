extends Node

func percent_pick(val): 
	if randi()%100+1 <=  val: 
		return true 
	return false
