# Dialogue.gd
class_name Dialogue
extends Control

@onready var content: RichTextLabel = $Content
@onready var type_timer: Timer = $TypeTyper
@onready var pause_timer: Timer = $PauseTimer
@onready var voice_player: DialogueVoicePlayer = $DialogueVoicePlayer
@onready var _calc: PauseCalculator = $PauseCalculator

var _playing_voice: bool = false  
signal message_completed


func _process(delta):
	if content.visible_characters == 1:
		voice_player.stop()
		
func update_message(message: String) -> void:
	content.bbcode_text = _calc.extract_pauses_from_string(message)
	content.visible_characters = 0
	type_timer.start()
	_playing_voice = true
	voice_player.play_with_random_pitch(0)

func _on_TypeTyper_timeout() -> void:
	_calc.check_at_position(content.visible_characters)
	if content.visible_characters < content.text.length():
		voice_player.play_with_random_pitch(0)
		content.visible_characters += 1
	else:
		type_timer.stop()
		emit_signal("message_completed")  


func _on_DialogueVoicePlayer_finished() -> void:
	if _playing_voice:
		voice_player.play_with_random_pitch(0)
		_playing_voice = false

func _on_PauseCalculator_pause_requested(duration: float) -> void:
	_playing_voice = false
	type_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()

func _on_PauseTimer_timeout() -> void:
	_playing_voice = true
	voice_player.play_with_random_pitch(0)
	type_timer.start()
	pause_timer.stop()  

func message_is_fully_visible() -> bool:
	return content.visible_characters >= content.text.length()

