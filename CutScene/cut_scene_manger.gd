extends Node2D

@onready var EarthOnly = preload("res://CutScene/EarthOnly.tscn")
@onready var KeplerMar = preload("res://CutScene/kepler_and_mars.tscn")
@onready var HumanWar = preload("res://CutScene/human_war.tscn")
@onready var KeplerRiftOpening = preload("res://CutScene/rift_opening.tscn")
@onready var KeplerAliensAttack = preload("res://CutScene/keplers_alien_attack.tscn")
@onready var KeplerWithAlien = preload("res://CutScene/kepler_with_aliens.tscn")
@onready var world1rift = preload("res://CutScene/world_1_rift.tscn")

@onready var next =$CanvasLayer/HBoxContainer/Next
@onready var prev = $CanvasLayer/HBoxContainer/Prev
@onready var trans = $SwipeTransistion

func play_sequential_cutscenes(scenes): 
	var idx = 0 
	for scene in scenes: 
		
		var node = scene.instantiate()
		add_child(node)
		trans.animp.play("open")
		await trans.opened
		
		await next.pressed
		
		trans.animp.play("close")
		await trans.closed
		node.queue_free()
		
		idx += 1 

func pregame_flow(): 
	var scenes = [EarthOnly,KeplerMar,HumanWar,KeplerRiftOpening,KeplerAliensAttack,KeplerWithAlien,world1rift]
#	var durations = [5,5,5,10,8,5,5]
	play_sequential_cutscenes(scenes)

	
func wait(t): 
	await get_tree().create_timer(t).timeout
	
	
func _ready():
	pregame_flow()


