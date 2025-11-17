extends Object


func super_randf() -> float:
	return randf() * randf();


#region ==================== Activation Functions ====================
## Applys the than activation function to the [param value]. [br][br]
## [img width=200]res://assets//docs_img//tanh.png[/img]
## [codeblock] 	return (exp(value) - exp(-value)) / (exp(value) + exp(-value)) [/codeblock]
func tanh(value: float) -> float:
	return (exp(value) - exp(-value)) / (exp(value) + exp(-value))

#endregion ==============================================================

#region ====================== CarBrain Functions ====================
## Normalize the [param output] passed.
## [codeblock] 
## 	if output < -0.33:
## 		return -1;
##	elif output > 0.33:
##		return 1
##	return 0 
## [/codeblock] [br]
## [b]Note:[/b] only works if [method than] is used as the activation function,
## For more informations watch the [method Neuron.forward] annotations.
func normalize_than_output(output: float) -> float:
	if output < -0.33:
		return -1;
	elif output > 0.33:
		return 1
	return 0

## Mutate [param value] passed. [br][br]
## The mutation is just adding to the [param value] a random [code] float [/code]. [br]
## The float is a random R value from 0 to 1
func mutate_value(value: float) -> float:
	return value + randf();
#endregion ==============================================================
