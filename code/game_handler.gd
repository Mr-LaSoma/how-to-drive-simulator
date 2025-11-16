extends Node2D

var alive_cars: Array[Car];
var dead_cars: Array[Car];

@export var CAR_SCENE: PackedScene;
const N_INITIAL_CARS: int = 10;

func _ready() -> void:
	randomize()
	for i in range(N_INITIAL_CARS):
		var temp: Car = CAR_SCENE.instantiate()
		alive_cars.append(temp);
		
		temp.died.connect(_on_car_died);
		temp.is_child = false;
		
		add_child(temp);

func _on_car_died(dead_car: Car) -> void:
	var car_index: int = alive_cars.find(dead_car);
	if car_index != -1:
		dead_cars.append(alive_cars.pop_at(car_index));
