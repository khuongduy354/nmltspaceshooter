extends Node

var curr = 0 
func play():
	var node = get_child(curr)
	if node.playing: 
		curr+=1
		curr = curr % get_child_count()
		get_child(curr).play()
	else: 
		node.play()
