extends Node


var mouse_captured : bool = true:
	set(value):
		mouse_captured = value
		if value: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready() -> void:
	mouse_captured = false    

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"): mouse_captured = !mouse_captured