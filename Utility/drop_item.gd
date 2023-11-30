extends CharacterBody2D

@export var item_type = "HEALTH"
var dir = Vector2.ZERO 
func _ready():
	$PickupZone.body_entered.connect(_body_entered)
	dir = Vector2(randi_range(-1,1), randi_range(-1,1)).normalized()
func _body_entered(body): 
	if body is Player:
		body.pick_up_item(self)

func _physics_process(delta):
	velocity = dir * 50
	move_and_slide()
