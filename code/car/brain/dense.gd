class_name Dense extends Object

var _neurons: Array[Neuron];

## Initialize all the neurons in the dense layer. [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [param n_neurons]: number of neurons that are in the dense layer. [br]
## For more information about the initialization of the neurons watch the [method Neuron._init] annotations. [br][br]
func _init(n_inputs, n_neurons) -> void:
	for i in range(n_neurons):
		_neurons.append(Neuron.new(n_inputs));

## Calculate the output of the dense layer. [br][br]
## [param inputs]: inputs passed in for the calculation. [br]
## [b]Note:[/b] the inputs size must be the same as the [param n_inputs] [br][br]
## For more information about the calculation watch the [method Neuron.forward] annotations.
func forward(inputs: Array[float]) -> Array[float]:
	var result: Array[float];
	
	for neuron in _neurons:
		result.append(neuron.forward(inputs, Utils.tanh));
	return result
