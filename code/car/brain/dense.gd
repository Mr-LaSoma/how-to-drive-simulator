class_name Dense extends Object

var _neurons: Array[Neuron];

## Initializes all the neurons in the dense layer. [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [param n_neurons]: number of neurons that are in the dense layer. [br]
## For more information about the initialization of the neurons watch the [method Neuron._init] annotations. [br][br]
func _init(n_inputs: int, n_neurons: int, should_rand: bool) -> void:
	for i in range(n_neurons):
		_neurons.append(Neuron.new(n_inputs, should_rand));

## Creates a new dense layer with the mutated neurons. [br][br]
## For more information about the mutation watch the
## [method Dense._mutate_neurons] annotations.
func new_dense() -> Dense:
	var _new_dense: Dense = Dense.new(_neurons[0]._weights.size(), _neurons.size(), false);
	_new_dense._neurons = self._mutate_neurons();
	return _new_dense;

## Calculates the output of the dense layer. [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [b]Note:[/b] the inputs size must be the same as the [param n_inputs] [br][br]
## For more information about the calculation watch the [method Neuron.forward] annotations.
func forward(inputs: Array[float]) -> Array[float]:
	var result: Array[float];
	
	for neuron in _neurons:
		result.append(neuron.forward(inputs, GUtils.tanh));
	return result

## Creates a new array of mutated neurons. [br][br]
## For more information about the creation of the new neurons watch
## the [method Neuron.new_neuron] annotations.
func _mutate_neurons() -> Array[Neuron]:
	var new_neurons: Array[Neuron];
	
	for neuron in _neurons:
		new_neurons.append(neuron.new_neuron());
	
	return new_neurons;
