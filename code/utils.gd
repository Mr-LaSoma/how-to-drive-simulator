extends Object


func super_randf() -> float:
	return randf() * randf();


#region ==================== Activation Functions ====================
func than(value: float) -> float:
	return (exp(value) - exp(-value)) / (exp(value) + exp(-value))

#endregion ==============================================================

#region ====================== CarBrain Functions ====================
func normalize_than_output(output: float) -> float:
	if output < -0.33:
		return -1;
	elif output > 0.33:
		return 1
	return 0
#endregion ==============================================================
