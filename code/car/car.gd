class_name Car extends CharacterBody2D

signal died(car: Car);

# ================ VARIABLES ================
@export var playerDriving: bool = false;
@export var _should_rand: bool = false;

var _brain: CarBrain;

var _is_alive: bool = true;
var _score: float = 0.0;
@warning_ignore("unused_private_class_variable")
var _checkpoints: Array[int];

var _acceleration: float = 0;
var _steering: float = 0;

const MAX_ACCELERATION: float = 500;
const MIN_ACCELERATION: float = -500;

const MAX_STEERING: float = 70;
const MIN_STEERING: float = -70;

const STEERING_TRASHOLD: float = 3;

@onready var sprite: Sprite2D = $Sprite;
@onready var ray1: RayCast2D = $Distance_1;
@onready var ray2: RayCast2D = $Distance_2;
@onready var ray3: RayCast2D = $Distance_3;
# ===========================================

# =========== Override Functions ============

func _ready() -> void:
	sprite.material = sprite.material.duplicate(true);
	
	if _should_rand:
		_brain = CarBrain.new(self, true);

func _process(delta: float) -> void:
	if !_is_alive:
		return;

	rotation_degrees += _steering * delta;
	
	if playerDriving:
		if !did_player_accelerated():
			slow_down();
		if is_acceleration_in_thrashold():
			steer_player();
		else:
			straighten();
		return
	
	var dist1 = ray1.get_collision_point().distance_to(global_position) if ray1.is_colliding() else 100.0;
	var dist2 = ray2.get_collision_point().distance_to(global_position) if ray2.is_colliding() else 100.0;
	var dist3 = ray3.get_collision_point().distance_to(global_position) if ray3.is_colliding() else 100.0;
	
	_brain.play([_acceleration, _steering, global_position.x, global_position.y, dist1, dist2, dist3]);

func _physics_process(delta: float) -> void:
	if !_is_alive:
		return;
	
	var forward = Vector2(cos(rotation), sin(rotation))

	velocity = velocity.move_toward(forward * _acceleration, 100 * delta)
	if _acceleration == 0:
		velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)

	move_and_slide();
# ===========================================

# ============ Player Functions =============
func did_player_accelerated() -> bool:
	if Input.is_action_pressed("acc_+"):
		accelerate_forward();
	elif Input.is_action_pressed("acc_-"):
		accelerate_backward();
	else:
		return false;
	return true;

func steer_player() -> void:
	if Input.is_action_pressed("steer_+"):
		steer_left()
	elif Input.is_action_pressed("steer_-"):
		steer_right();
	else:
		straigten_slowly();
# ===========================================

# ============= Brain Functions =============
func do_brain_choice(brain_choice: Array[float]) -> void:
	if brain_choice[1] == 1:
		accelerate_forward();
	elif brain_choice[1] == -1:
		accelerate_backward();
	else:
		slow_down();
	
	if !is_acceleration_in_thrashold():
		straighten();
		return
	
	if brain_choice[0] == 1:
		steer_left();
	elif brain_choice[0] == -1:
		steer_right();
	else:
		_steering = lerp(_steering, 0.0, 0.02)
# ===========================================


func kill() -> void:
	_is_alive = false;
	_acceleration = 0.0;
	_steering = 0.0;
	died.emit(self)
	add_score(GUtils.DEATH_PENALTY)
	var temp: ShaderMaterial = sprite.material;
	temp.set_shader_parameter("is_dead", true)

func add_score(value: float) -> void:
	_score += value;

# =========== Car Movement Functions ========
func accelerate_forward() -> void:
	_acceleration = lerp(_acceleration, MAX_ACCELERATION, 0.5);
func accelerate_backward() -> void:
	_acceleration = lerp(_acceleration, MIN_ACCELERATION, 0.5)

func slow_down() -> void:
	if is_acceleration_in_thrashold():
		_acceleration = lerp(_acceleration, 0.0, 0.05);
	else:
		_acceleration = lerp(_acceleration, 0.0, 0.5);

func is_acceleration_in_thrashold() -> bool:
	return _acceleration > STEERING_TRASHOLD or _acceleration < -STEERING_TRASHOLD

func steer_left() -> void:
	_steering = lerp(_steering, MAX_STEERING, 0.5);
func steer_right() -> void:
	_steering = lerp(_steering, MIN_STEERING, 0.5);

func straigten_slowly() -> void:
	_steering = lerp(_steering, 0.0, 0.02);

func straighten() -> void:
	_steering = lerp(_steering, 0.0, 1)
# ===========================================

func print_weights() -> void:
	print("Car: ", self.name, " | Data: [")
	for layer in _brain._layers:
		print("	[")
		for dense in layer._neurons:
			printraw("		[")
			for weight in dense._weights:
				print("			", weight)
			print("		] | [ Bias: ", dense._bias, " ]")
		print("	]")
	print("]")
