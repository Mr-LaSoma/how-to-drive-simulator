class_name Neuron extends Object

var _weigths: Array[float];
var _bias: float;

func _init(n_inputs: int) -> void:
	for i in range(n_inputs):
		_weigths.append(randf());
	
	_bias = randf();

func _calc_z(inputs: Array[float]) -> float:
	assert(inputs.size() == _weigths.size(), "[Forward] -> inputs size should be the same as the weigths");
	
	var sum: float = 0;
	for i in range(inputs.size()):
		sum += inputs[i] * _weigths[i];
	
	return sum + _bias;

func forward(inputs: Array[float], activation_func: Callable) -> float:
	var z: float = _calc_z(inputs);
	return activation_func.call(z);
