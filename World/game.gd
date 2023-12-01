extends Node2D

var StoryWorldScene = preload("res://World/story_world.tscn")
var EndlessWorldScene = preload("res://World/endless_world.tscn")

func _ready():
	run_game()
	
func run_game(): 
	Global.drop_item_list = $DropItemsList
	if Global.is_story: 
		setup_story()
	else: 
		setup_endless()

func setup_story(): 
	var CSManager = preload("res://CutScene/cut_scene_manger.tscn").instantiate()
	add_child(CSManager)
	CSManager.pregame_flow()
	await CSManager.finished
	CSManager.queue_free()
	
	Global.cam = null
	add_child(StoryWorldScene.instantiate())
	
func setup_endless(): 
	Global.cam = null
	add_child(EndlessWorldScene.instantiate())
