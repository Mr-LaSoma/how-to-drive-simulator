class_name CarBrain extends Node

# accel
# steer          neuron          steering
# rotat
# dist1
# dist2          neuron          acceleration
# dist3

# ================ VARIABLES ================
var _init_inputs: Array[float] = [];
var _weights: Array[Array];
var _biases: Array[float];

## Numero di variabili iniziali prese in considerazioni
## per il calcolo del risultato
const _N_INPUTS: int = 6;

## Numero dei neuroni totali (anche i neuroni finali)
const _N_NEURONS: int = 4;

# ===========================================

# ============= Brain Functions =============

func init() -> void:
	# Init weights
	_weights = [
		[], [], [], []
	];
	for i in range(_N_INPUTS):
		_weights[0].append(randf()*randf());
		_weights[1].append(randf()*randf());
	for i in range(2):
		_weights[2].append(randf()*randf());
		_weights[3].append(randf()*randf());

	_biases.clear();
	for i in range(_N_NEURONS):
		_biases.append(randf()*randf());


func get_initial_inputs_data(external_inputs: Array[float]) -> void:
	assert(external_inputs.size() == _N_INPUTS, "[Car Brain] -> Input size must be equal to n_inputs")
	
	_init_inputs = external_inputs.duplicate();


func _calc_neuron_input(inputs: Array[float], neuron_indx: int, activation_func: Callable) -> float:
	return activation_func.call(_dot_product(inputs, _weights, neuron_indx) + _biases[neuron_indx])


func calc_output() -> Array[float]:
	var neuron0 = _calc_neuron_input(_init_inputs, 0, Callable(self, "_tanh"))
	var neuron1 = _calc_neuron_input(_init_inputs, 1, Callable(self, "_tanh"))
	
	var neuron2 = _calc_neuron_input([neuron0, neuron1], 2, Callable(self, "_tanh"))
	var neuron3 = _calc_neuron_input([neuron0, neuron1], 3, Callable(self, "_tanh"))

	return [_discretize_tanh(neuron2), _discretize_tanh(neuron3)];

# ===========================================

# ============= Math Functions ==============

func _dot_product(arr1 : Array[float], arr2: Array[Array], array2_indx: int) -> float:
	assert(arr1.size() == arr2[array2_indx].size(), "[Car Brain] -> Arrays must be the same size");
	var dot: float = 0.0;
	for i in range(arr1.size()):
		dot += arr1[i] * arr2[array2_indx][i]
	return dot;

func _tanh(value: float) -> float:
	return (exp(value) - exp(-value)) / (exp(value) + exp(-value))

func _discretize_tanh(value: float) -> int:
	if value > 0.33:
		return 1
	elif value < -0.33:
		return -1
	else:
		return 0
# ===========================================
