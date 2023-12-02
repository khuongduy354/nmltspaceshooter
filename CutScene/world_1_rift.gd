extends Node2D

func _ready():
	$Player.pname.text = "You here"
	$Player.pname.scale = Vector2(6,6)
	$Player.pname.position += Vector2(0,300)
	$Player.cam.enabled = false
	$Player.set_physics_process(false)
	$Player/CollisionPolygon2D.set_deferred("disabled",true)
	
