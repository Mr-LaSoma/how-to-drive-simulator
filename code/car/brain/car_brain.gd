class_name CarBrain extends Object

var _layers: Array[Dense];

var _owned_car: Car;

## Initialize the CarBrain [br][br]
## [param car]: the car moved by the brain. [br]
## [b] Note: [/b] all the dense layers are manualy initialized in the [CarBrain] class
func _init(car: Car, should_rand: bool) -> void:
	_owned_car = car;
	
	if should_rand:
		_layers = [
			Dense.new(7, 2, true),						# Inputs -> [acceleration, steering, posX, posY, ray1_dist, ray2_dist, ray3_dist]
			Dense.new(2, 2, true)						# Inputs -> [neuron1, neuron2]  |  Outputs -> [acceleration, steering]
		]

## Calculate the output of the layers [code] [acceleration, steering] [/code]. [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [b]Note:[/b] the inputs size must be the same as the [param n_inputs] of the first dense layer. [br][br]
## For more information about the calculation watch the [method Dense.forward] annotations.
func _forward(inputs: Array[float]) -> Array[float]:
	var current_inputs: Array[float] = inputs.duplicate(true);
	
	for dense in _layers:
		current_inputs = dense.forward(current_inputs).duplicate();

	return current_inputs;

## Function used to play the actual game from the brain. [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [b]Note:[/b] the inputs size must be the same as the [param n_inputs] of the first dense layer. [br][br]
## For more information about the calculation watch the [method CarBrain._forward] annotations and all the [Car] class API methods.
func play(inputs: Array[float]) -> void:
	var decisions: Array[float] = _forward(inputs);
	
	var acceleration = GUtils.normalize_than_output(decisions[0]);
	var steering = GUtils.normalize_than_output(decisions[1]);
	
	if acceleration == 1:
		_owned_car.accelerate_forward();
	elif acceleration == -1:
		_owned_car.accelerate_backward();
	else:
		_owned_car.slow_down();
	
	if !_owned_car.is_acceleration_in_thrashold():
		_owned_car.straighten();
		return
	
	if steering == 1:
		_owned_car.steer_left();
	elif steering == -1:
		_owned_car.steer_right();
	else:
		_owned_car.straigten_slowly();

func mutate(other_car: CarBrain) -> Car:
	var child_brain_layers: Array[Dense]
	var lsize: int = _layers.size();
	var lhalf_size: int = _layers.size()/2;
	
	if lsize % 2 != 0:
		child_brain_layers.append(_layers[lsize - lhalf_size])
	
	for i in range(lhalf_size):
		child_brain_layers.append(_layers[i])
		child_brain_layers.append(other_car._layers[(lsize-1)-i])
	
	var child_car: Car = GUtils.CAR_SCENE.instantiate();
	var child_brain: CarBrain = CarBrain.new(child_car, false)
	child_brain._layers = child_brain_layers;
	child_car._brain = child_brain;
	return child_car;
