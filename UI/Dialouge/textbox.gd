extends MarginContainer

enum Scripts { 
	EarthIntro, 
	OverPopulation,
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
var initial_text = "Press Space to run dialouge."

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.05 
var punctuation_time = 0.5
signal finished_displaying()
var	finished = false
var is_playing = false

func  _ready():
	if initial_text != "": 
		label.text = initial_text

func load_premade_scripts(): 
	var result = ""
	match prescripts: 
		Scripts.EarthIntro:
			result = "Năm 2061, Trái đất đã đạt đuợc tiến bộ vượt bậc trong ngành Hàng Không Vũ Trụ, cho phép con người có thể di chuyển đến các hành tinh khác."
		Scripts.OverPopulation: 
			result = "Tuy nhiên Trái Đất đã quá tải về dân số, vấn đề thiếu đất sinh sống ngày một trầm trọng, dẫn đến nhu cầu di cư ngoài vũ trụ tăng cao."
		Scripts.KeplerMarsIntro:
			result = "Các nhà khoa học đã đề xuất hai hành tinh để di cư: Sao Hoả và Kepler B52. Tuy nhiên việc quyết định hành tinh nào để di cư vẫn gây tranh cãi quyết liệt, lúc này thế giới chia làm hai nửa, xung đột xảy ra gay gắt đến nỗi chỉ còn có thể giải quyết bằng vũ lực!"
		Scripts.HumanWar:
			result = "Trận chiến vô nghĩa ấy đã nổ ra, chưa kể đến thiệt hại chung cho nhân loại, con người đã tự kéo bản thân vào đại thảm hoạ với quy mô vũ trụ…"
		Scripts.KeplerRiftOpening:
			result = "Đó là khi họ nhận ra Kepler B52 có sự sống! Thậm chí Kepler còn là một nền văn minh cao hơn loài người rất nhiều. Kepler nhận ra sự tồn tại của con người qua trận 'nội chiến vô nghĩa' của họ và nảy sinh ý định chiếm lấy Hệ mặt trời"
		Scripts.KeplerAlienAttack: 
			result = "Họ kéo lực lượng đến đánh chúng ta trong tình thế mà chúng ta không thể phản kháng. Con người bị áp đảo, Trái đất bị xâm lược. Chúng ta phải liên tục lẫn trốn và chuẩn bị vũ trang phản công đòi lại Trái đất!"
		Scripts.KeplerWithAliens:
			result = "Và rồi mãi đến tận đầu thế kỉ 24, con người đã chuẩn bị sẵn sàng cho đợt phản công đòi lại Trái đất. Bạn là một trong những phi công điều khiển chiến hạm, nhiệm vụ của bạn là tiêu diệt tàu mẹ của Kepler! Tuy nhiên đồng đội của bạn đều đã hi sinh, nhưng bằng mọi giá…Hãy hoàn thành nhiệm vụ!!"
		Scripts.WorldOnePregame:
			result = "Hãy phá huỷ 4 cổng dịch chuyển! Lưu ý: Bạn chỉ có thể gây sát thuơng khi cổng đang mở, và việc bạn bắn cổng sẽ làm lộ vị trí và báo động toàn bộ tàu trên bản đồ tấn công bạn! B
Hãy cẩn thận!"
	return result
	
func clear_text(): 
	letter_index = 0 
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept") and !is_playing: 
		display_text()

func display_text(text_to_display: String = ""):
#	if text_to_display == "" and initial_text != "": 
#		text_to_display = initial_text
	label.text = ""
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

