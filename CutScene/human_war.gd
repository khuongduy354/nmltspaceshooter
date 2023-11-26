extends Node2D

func _ready():
	for supporter in $MarsSupporters.get_children(): 
		supporter.set_physics_process(false)
		supporter.cam.enabled = false
		supporter.gun.BulletScene = preload("res://Utility/smaller_player_bullet.tscn")
		supporter.pname.text = "Mar"
		supporter.should_look=false
	for supporter in $KeplerSupporters.get_children(): 
		supporter.set_physics_process(false)
		supporter.cam.enabled = false
		supporter.gun.BulletScene  =  preload("res://Utility/smaller_red_bullet.tscn")
		supporter.pname.text = "Kepler"
		supporter.pname.rotation_degrees+=180
		
		
		supporter.sprite.texture = preload("res://assets/Objects/enemy-PhotoRoom.png-PhotoRoom (2).png")
		supporter.sprite.rotate(PI)
		supporter.sprite.scale=Vector2(2,2)
		
		supporter.should_look=false

func _physics_process(delta):
	for supporter in $MarsSupporters.get_children(): 
		supporter.gun.shoot()
		var dir = Vector2.RIGHT
		supporter.position += dir * 0.5
		supporter.animp.play("fly")
	for supporter in $KeplerSupporters.get_children(): 
		var dir = Vector2.RIGHT
		supporter.gun.shoot()
		supporter.position += dir * 0.5
