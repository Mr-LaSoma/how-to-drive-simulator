class_name CarBrain extends Object

var _layers: Array[Dense] = [
		Dense.new(6, 2),						# Inputs -> [acceleration, steering, global_rotation, ray1_dist, ray2_dist, ray3_dist]
		Dense.new(2, 2)							# Inputs -> [neuron1, neuron2]  |  Outputs -> [acceleration, steering]
	]

var _owned_car: Car;

func _init(car: Car) -> void:
	_owned_car = car;

func _forward(inputs: Array[float]) -> Array[float]:
	var current_inputs: Array[float] = inputs.duplicate(true);
	
	for dense in _layers:
		current_inputs = dense.forward(current_inputs).duplicate();
	
	return current_inputs;

func play(inputs: Array[float]) -> void:
	var decisions: Array[float] = _forward(inputs);
	
	var acceleration = Utils.normalize_than_output(decisions[0]);
	var steering = Utils.normalize_than_output(decisions[1]);
	
	if acceleration == 1:
		_owned_car.accelerate_forward();
	elif acceleration == -1:
		_owned_car.accelerate_backward();
	else:
		_owned_car.slow_down();
	
	if !_owned_car.can_steer():
		_owned_car.straighten();
		return
	
	if steering == 1:
		_owned_car.steer_left();
	elif steering == -1:
		_owned_car.steer_right();
	else:
		_owned_car.straigten_slowly();
