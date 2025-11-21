extends Node2D

@export var car_max_time: float = 10.0;

var counter = 0;
var alive_cars: Array[Car];
var dead_cars: Array[Car];

@onready var car_death_timer: Timer = $CarDeathTimer;

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
	
	reset_game(true);

func _process(delta: float) -> void:
	for car in alive_cars:
		car.add_score(GUtils.TIME_PENALTY)

func _on_car_died(dead_car: Car) -> void:
	dead_cars.append(dead_car);
	var temp = alive_cars.find(dead_car);
	alive_cars.remove_at(temp);
	if alive_cars.size() == 0:
		reset_game(false);


func reset_game(first_time: bool) -> void:
	car_death_timer.stop()
	
	if first_time:
		dead_cars.clear()
		car_death_timer.start(car_max_time)
		return
	
	# Sposta tutte le auto da alive_cars a dead_cars
	while alive_cars.size() > 0:
		var car = alive_cars.pop_back()
		dead_cars.append(car)
	
	# Ordina le auto morte per punteggio decrescente
	dead_cars.sort_custom(_sort_by_score_desc)
	for car in dead_cars:
		car.print_weights()
	
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
		
		alive_cars.append(new_car)
		add_child(new_car)
	
	for car in dead_cars:
		if car.is_inside_tree():
			car.get_parent().remove_child(car)
			car.queue_free()
	dead_cars.clear()
	
	car_death_timer.start(car_max_time)


# Funzione per ordinare in base al punteggio decrescente
func _sort_by_score_desc(a: Car, b: Car) -> int:
	return a._score > b._score;




func _on_car_death_timer_timeout() -> void:
	reset_game(false);
