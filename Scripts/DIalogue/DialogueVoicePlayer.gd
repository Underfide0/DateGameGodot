# DialogueVoicePlayer.gd
class_name DialogueVoicePlayer
extends AudioStreamPlayer

var _random_number_gen : RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	_random_number_gen.randomize()

# Método personalizado para reproducir el sonido con un tono aleatorio
func play_with_random_pitch(from_position : float = 0.0) -> void:
	pitch_scale = _random_number_gen.randf_range(0.95, 1.08)
	# Llamar al método play() de la clase base
	super.play(from_position)
