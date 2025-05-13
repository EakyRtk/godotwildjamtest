extends Area3D





func _on_body_entered(body:Node3D) -> void:
    print(body.name)
    body.global_position.y += 100