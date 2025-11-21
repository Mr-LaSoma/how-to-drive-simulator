extends Area2D

@onready var car: Car = $".."

func _on_body_entered(_body: Node2D) -> void:
	if car and not car.done:
		car.done = true
		car.kill();
