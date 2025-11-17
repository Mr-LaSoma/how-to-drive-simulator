class_name Neuron extends Object

var _weights: Array[float];
var _bias: float;

## Initialize the neuron. [br][br]
## [param n_inputs]: number of inputs that will be passed in the neuron
## [codeblock]
##	for i in range(n_inputs):
##		_weights.append(randf());
##	_bias = randf();
## [/codeblock]
func _init(n_inputs: int) -> void:
	for i in range(n_inputs):
		_weights.append(randf());
	
	_bias = randf();

## Calculate the summation for the moltiplications (weight * input). [br][br]
## [img width=200]res://assets//docs_img//weighted_sum.png[/img] [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [b]Note:[/b] the inputs size must be the same as the [param n_inputs]
## [codeblock] assert(inputs.size() == _weights.size()) [/codeblock]
func _calc_z(inputs: Array[float]) -> float:
	assert(inputs.size() == _weights.size(), "[Forward] -> inputs size should be the same as the weigths");
	
	var sum: float = 0;
	for i in range(inputs.size()):
		sum += inputs[i] * _weights[i];
	
	return sum + _bias;

## Calculate the output of the neuron. [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [param activation_func]: Callable of the activation function. [br]
## [b]Note:[/b] the inputs size must be the same as the [param n_inputs] [br][br]
##  For more information about the calculation watch the [method Neuron._calc_z] annotations.
func forward(inputs: Array[float], activation_func: Callable) -> float:
	var z: float = _calc_z(inputs);
	return activation_func.call(z);

## Mutate all the weights. [br][br]
## Returs the mutated weights
## For the specific watch the [method Utils.mutate_value] annotations.
func mutate_weigths() -> Array[float]:
	var new_weigths: Array[float];
	
	for weight in _weights:
		new_weigths.append(Utils.mutate_value(weight));
	
	return new_weigths
