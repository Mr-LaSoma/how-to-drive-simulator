extends Node2D

var counter = 0;
var alive_cars: Array[Car];
var dead_cars: Array[Car];

func _ready() -> void:
	randomize()
	
	for i in range(GUtils.N_INITIAL_CARS):
		var temp_car: Car = GUtils.CAR_SCENE.instantiate();
		
		temp_car.global_position = global_position * GUtils.super_randf();
		temp_car.name = str(counter);
		counter+=1;
		
		temp_car._should_rand = true;
		temp_car.died.connect(_on_car_died);
		alive_cars.append(temp_car);
		add_child(temp_car);

func _process(_delta: float) -> void:
	for car in alive_cars:
		car.add_score(GUtils.TIME_PENALTY)

func _on_car_died(dead_car: Car) -> void:
	dead_cars.append(dead_car);
	alive_cars.erase(dead_car);
	if alive_cars.size() == 0:
		reset_game();


func reset_game() -> void:
	# Sposta tutte le auto da alive_cars a dead_cars
	for car in dead_cars:
		car.score_dist_checkpoint()
	
	# Ordina le auto morte per punteggio decrescente
	dead_cars.sort_custom(_sort_by_score_desc)
	for i in range(5):
		print("Car: ", dead_cars[i].name, " | Points: ", dead_cars[i]._score)
		pass
	print()
	
	# Prendi le top 5 (o meno se ce ne sono meno)
	var top_cars = dead_cars.slice(0, min(GUtils.N_PARENTS_CARS, dead_cars.size()))
	
	# Genera nuove auto mutando casualmente dalle top 5
	for i in dead_cars.size():
		var parent_car: Car = top_cars[randi() % top_cars.size()]
		var parent_car2: Car = top_cars[randi() % top_cars.size()]
		var new_car: Car = parent_car._brain.mutate(parent_car2._brain)
		
		new_car.name = str(counter)
		counter += 1
		new_car.global_position = global_position * GUtils.super_randf()
		new_car.died.connect(_on_car_died)
		
		alive_cars.append(new_car)
		call_deferred("add_child", new_car)
	
	for i in range(dead_cars.size()-1, -1, -1):
		var car: Car = dead_cars[i];
		if car and car.is_inside_tree():
			dead_cars.remove_at(i)
			call_deferred("remove_child", car)
			car.call_deferred("queue_free")

	dead_cars.clear()
	GUtils.MAX_POINTS += GUtils.MAX_POINTS_INCRESE;

# Funzione per ordinare in base al punteggio decrescente
func _sort_by_score_desc(a: Car, b: Car) -> int:
	return a._score > b._score;
