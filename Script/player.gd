extends CharacterBody2D

@export var move_speed : float = 100
@export var acceleration : float = 50
@export var breaking : float = 20

@export var health : int = 3

@export var max_stamina : float = 100
@export var stamina : float = 100

@export var stamina_drain : float = 15
@export var max_recover_speed : float = 12
@export var min_recover_speed : float = 5

var move_input_x : float
var move_input_y : float
var is_climbing = false

var visited_tiles = {}
var last_tile = Vector2i.ZERO

var time_left : int =100

var respawn_point : Vector2

var max_health = 3

@onready var sprite : Sprite2D = $Sprite
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	respawn_point = global_position

	if time_left <= 0:
		game_over()

func _physics_process(delta):
	move_input_x = Input.get_axis("move_left", "move_right")
	move_input_y = Input.get_axis("move_up", "move_down")
	if move_input_x != 0:
		velocity.x = lerp(
			velocity.x,
			move_input_x * move_speed,
			acceleration * delta
		)
	else:
		velocity.x = lerp(
			velocity.x,
			0.0,
			breaking * delta
		)
	if move_input_y != 0:
		velocity.y = lerp(
			velocity.y,
			move_input_y * move_speed,
			acceleration * delta
		)
	else:
		velocity.y = lerp(
			velocity.y,
			0.0,
			breaking * delta
		)
	
	move_and_slide()

func _process(delta): 
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
	
	_manage_animation()

func _manage_animation():
	if move_input_x != 0 and move_input_y != 0:
		anim.play("move")
	else:
		anim.play("idle")

'func take_damage(amount : int):
	health -= amount
	OnUpDateHealth.emit(health)
	Damaged.emit()
	_damage_flash()
	play_sound(take_damgage_sfx)
	
	if health <= 0:
		respawn()'

func game_over():
	audio.stop()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

'func increase_score(amount: int):
	Playerstats.score += amount
	OnUpDateScore.emit(Playerstats.score)
	play_sound(coin_sfx)'

func _damage_flash():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE


func set_respawn_point(pos : Vector2):
	respawn_point = pos

func respawn():
	global_position = respawn_point
	velocity = Vector2.ZERO
	
	health = max_health

func play_sound (sound : AudioStream):
	audio.stream = sound
	audio.play()
