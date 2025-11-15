class_name Car extends CharacterBody2D

#region Variables
@export var playerDriving: bool = false;

var _accelleration: float = 0;
var _steering: float = 0;

const MAX_ACCELLERATION: float = 500;
const MIN_ACCELLERATION: float = -500;

const MAX_STEERING: float = 70;
const MIN_STEERING: float = -70;

const STEERING_TRASHOLD: float = 3;
#endregion



#region Override Functions

func _process(delta: float) -> void:
	rotation_degrees += _steering * delta;
	
	if playerDriving:
		calc_acc_player();
		calc_steer_player();

func _physics_process(delta: float) -> void:
	var forward = Vector2(cos(rotation), sin(rotation))

	velocity = velocity.move_toward(forward * _accelleration, 100 * delta)
	if _accelleration == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
		
	move_and_slide();

#endregion



#region Helper Functions

func calc_acc_player() -> void:
	if Input.is_action_pressed("acc_+"):
		_accelleration = lerp(_accelleration, MAX_ACCELLERATION, 0.5)
	elif Input.is_action_pressed("acc_-"):
		_accelleration = lerp(_accelleration, MIN_ACCELLERATION, 0.5)
	else:
		if _accelleration > STEERING_TRASHOLD or _accelleration < -STEERING_TRASHOLD:
			_accelleration = lerp(_accelleration, 0.0, 0.05)
		else:
			_accelleration = lerp(_accelleration, 0.0, 0.5)

func calc_steer_player() -> void:
	if _accelleration > STEERING_TRASHOLD or _accelleration < -STEERING_TRASHOLD:
		var target_steering: float = 0
		if Input.is_action_pressed("steer_+"):
			target_steering = MAX_STEERING
		elif Input.is_action_pressed("steer_-"):
			target_steering = MIN_STEERING
		_steering = lerp(_steering, target_steering, 0.5)
		return
	_steering = lerp(_steering, 0.0, 2)

#endregion
