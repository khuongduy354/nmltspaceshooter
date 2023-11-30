extends MarginContainer

enum Scripts { 
	EarthIntro, 
	KeplerMarsIntro, 
	HumanWar,
	KeplerRiftOpening,
	KeplerAlienAttack, 
	KeplerWithAliens, 
	WorldOnePregame,
	NONE
}
@export var prescripts: Scripts = Scripts.NONE
@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@export var initial_text = ""

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.05
var space_time = 0.1
var punctuation_time = 0.5
signal finished_displaying()
var	finished = false
var is_playing = false

func load_premade_scripts(): 
	var result = ""
	match prescripts: 
		Scripts.EarthIntro:
			result = "In 2050, our civilization is able to travel to outer space, colonize, and explore many planets with the lastest AeroSpace technology."
		Scripts.KeplerMarsIntro:
			result = "Two groups of Scientists, propose migrating people to 2 other planets: Mars and Kepler B52 to cope with the situation.......but these 2 don't seems get along with each other,"
		Scripts.HumanWar:
			result = "As the two striving for the permission, (along with Funding)  to implement their projects...A galactic  war between human broke out."
		Scripts.KeplerRiftOpening:
			result = ""
		Scripts.KeplerAlienAttack: 
			result = ""
		Scripts.KeplerWithAliens:
			result = ""
		Scripts.WorldOnePregame:
			result = ""
	return result
	
func clear_text(): 
	letter_index = 0 
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and !is_playing: 
		display_text()

func display_text(text_to_display: String = ""):
#	if text_to_display == "" and initial_text != "": 
#		text_to_display = initial_text
	if prescripts != Scripts.NONE and text_to_display == "": 
		text_to_display = load_premade_scripts()
		
	if !is_playing: 
		clear_text()
		is_playing = true 
	
	text = text_to_display
	label.text = text_to_display
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		custom_minimum_size.y = size.y

	label.text = ""
	print("hi")
	_display_letter()

func _display_letter():
	$SoundQueue.play()
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished = true
		is_playing = false 
		finished_displaying.emit()
		return
	
	match text[letter_index]:
		"!", ".", ",", "?",":":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_letter_display_timer_timeout():
	_display_letter()

