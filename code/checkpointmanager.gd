class_name PointsManager extends Node2D

var checkpoint: Array[Area2D];

func _ready() -> void:
	for child in get_children(false):
		var checkpoint_hitbox: Area2D = child.get_child(0)
		checkpoint_hitbox.area_entered.connect(on_checkpoint_hitbox_area_entered.bind(checkpoint.size()))
		checkpoint.append(checkpoint_hitbox)

func on_checkpoint_hitbox_area_entered(area: Area2D, sender_indx: int) -> void:
	var car: Car = area.get_parent()
	var checksum: int = (sender_indx * (sender_indx+1))/2
	var checksum_car: int = (car._checkpoints.size() - 1 * (car._checkpoints.size()))/2
	
	if checksum == checksum_car:
		car.add_score(GUtils.CHECKPOINT_POINTS)
		car._checkpoints.append(sender_indx);
	else:
		car.add_score(GUtils.DEATH_PENALTY)
