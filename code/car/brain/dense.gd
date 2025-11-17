class_name Dense extends Object

var _neurons: Array[Neuron];

func _init(n_inputs, n_neurons) -> void:
	for i in range(n_neurons):
		_neurons.append(Neuron.new(n_inputs));

func forward(inputs: Array[float]) -> Array[float]:
	var result: Array[float];
	
	for neuron in _neurons:
		result.append(neuron.forward(inputs, Utils.than));
	
	return result
