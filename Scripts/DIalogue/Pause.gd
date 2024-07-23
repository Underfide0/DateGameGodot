class_name Pause
extends RefCounted

const FLOAT_PATTERN := r"\d+\.\d+"  # Raw string for correct pattern
var pause_pos: int
var duration: float

func _init(_position: int, _tag_string: String) -> void:
	var _duration_regex = RegEx.new()
	_duration_regex.compile(FLOAT_PATTERN)

	var match = _duration_regex.search(_tag_string)
	if match:
		duration = float(match.get_string())
	else:
		duration = 0.0

	pause_pos = clamp(_position - 1, 0, abs(_position))
