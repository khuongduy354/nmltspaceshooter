extends Camera2D

@onready var timer = $Timer

var shake_amount = 0 
var default_offset = offset



func _ready():
	set_process(false)
	randomize()

func _process(delta):
	offset = Vector2(randf_range(-1,1)*shake_amount,randf_range(-1,1)*shake_amount) 

func shake(time,amount): 
	timer.wait_time = time
	shake_amount=amount
	set_process(true)
	timer.start()

func shake_off(): 
	set_process(false)
	var tween = create_tween()
	tween.tween_property(self,"offset",default_offset,0.1)
func _on_timer_timeout():
	shake_off()
