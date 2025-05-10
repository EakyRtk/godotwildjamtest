extends Control

const GAME : PackedScene = preload("res://Test/test.tscn")

func _on_button_pressed() -> void:
    get_tree().change_scene_to_packed(GAME)
    Globals.mouse_captured = true