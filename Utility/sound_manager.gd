extends Node2D

func play_sound(val): 
	find_child(val).play()
	
func stop_sound(val): 
	find_child(val).stop() 
