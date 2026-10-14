extends CharacterBody2D

@export var stats: Stats
@export var velocity_component: Velocity
@export var jump_buffer := 6
@export var coyote_time := 5
@export var gravity_mult := 0.5
@export var wall_jump_timer_val := 200

@onready var right: ShapeCast2D = $right
@onready var left: ShapeCast2D = $left
@onready var anim_controller: AnimController = $AnimController
@onready var inv: InvNode = $Camera2D/CanvasLayer/inv
@onready var camera: Camera2D = $Camera2D
@onready var status_effects: StatusEffects = $StatusEffects
@onready var item_dropper: ItemDropper = $ItemDropper

enum States {IDLE, WALKING, SPRINTING, FALLING}

var jump_buffer_timer = null
var coyote_time_timer = null
var gravity_mult_timer = 1
var grav_timer = 0
var jump_strenght := 0.6
var jump_timer := 0
var wall_jump_timer := 0.0

var state := States.IDLE

func change_state(new_state: States):
	# used for triggering stuff on specific states
	match new_state:
		States.IDLE:
			anim_controller.play_all("idle")
		States.WALKING:
			anim_controller.play_all("walk")
		States.FALLING:
			anim_controller.play_all("fall")

	# check for previous state
	match state:
		States.FALLING:
			gravity_mult_timer = 1

	state = new_state

func _ready() -> void:
	TimeManager.play()
	var slot = Slot.new()
	slot.amount = 2
	slot.item = load("resources/items/bomb.tres")
	item_dropper.drop([slot])

func _process(delta):
	# midair funcs
	if not is_on_floor():
		# timers
		if not jump_buffer_timer == null:
			if jump_buffer_timer - 1 >= 0:
				jump_buffer_timer -= 1
			else:
				jump_buffer_timer = null

		if not coyote_time_timer == null:
			if coyote_time_timer - 1 >= 0:
				coyote_time_timer -= 1
			else:
				coyote_time_timer = 0

		if wall_jump_timer > 0:
			if wall_jump_timer - 1 >= 0:
				wall_jump_timer -= 1
			else:
				wall_jump_timer = 0

		# Add the gravity.
		if is_on_wall():
			velocity_component.add_velocity(get_gravity() * delta / 2)
		else:
			velocity_component.add_velocity(get_gravity() * delta * gravity_mult_timer)
		change_state(States.FALLING)

		if coyote_time_timer == null:
			coyote_time_timer = coyote_time

			# Handle jump.
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer = jump_buffer
			coyote_time_timer = null

	else:
		#handle jump
		if Input.is_action_just_pressed("jump"):
			jump(stats.jump_velo)
			coyote_time_timer = 0

		if jump_buffer_timer != null:
			jump(stats.jump_velo)

		jump_buffer_timer = null
		coyote_time_timer = null

	if state == States.FALLING:
		grav_timer += 1
		if grav_timer == 1000:
			gravity_mult_timer += gravity_mult
			grav_timer = 0

	# wall jump
	if wall_jump_timer == 0:
		if right.is_colliding() and Input.is_action_just_pressed("jump") and not is_on_floor():
			jump(stats.jump_velo)
			velocity_component.set_velocity_x(stats.jump_velo)
			wall_jump_timer = wall_jump_timer_val
			
		elif left.is_colliding() and Input.is_action_just_pressed("jump") and not is_on_floor():
			jump(stats.jump_velo)
			velocity_component.set_velocity_x(-stats.jump_velo)
			wall_jump_timer = wall_jump_timer_val

	# handle left/right movement
	var direction := Input.get_axis("left", "right")
	if direction:
		if not is_on_wall() and (not right.is_colliding() and not left.is_colliding()) or is_on_floor():
			velocity_component.set_velocity_x(direction * stats.current_speed)
		change_state(States.WALKING)
			
		# sets direction of sprite
		if direction < 0:
			anim_controller.set_direction_for_all(Vector2(-1, 1))
		else:
			anim_controller.set_direction_for_all(Vector2(1, 1))


	elif not direction:
		if not is_on_floor():
			velocity_component.reset_velocity_x(1)
		elif is_on_floor():
			velocity_component.reset_velocity_x(stats.current_speed)
			change_state(States.IDLE)
	move_and_slide()

func jump(value: float):
	velocity_component.set_velocity_y(value)
	anim_controller.play_all("jump", true)

func save():
	print("player save")
	var save_data = {
		"filename": get_scene_file_path(),
		"pos_x": position.x,
		"pos_y": position.y,
		"stats": {
			"health": stats.health,
			"max_health": stats.max_health,
			"current_speed": stats.current_speed,
			"speed": stats.speed,
			"damage_factor": stats.damage_factor,
			"shield_factor": stats.shield_factor,
			"jump_velo": stats.jump_velo,
			"effect_factors": stats.effect_factors,
			"capacity": stats.capacity,
			"cooldown_factor": stats.cooldown_factor,
		},
		"inv": inv.save(),
		"effects": status_effects.save()
	}

	return save_data
	
func load_data(data):
	inv.load_inv(data["inv"])
	status_effects.load(data["effects"])
	position.x = data["pos_x"]
	position.y = data["pos_y"]
	for key in data["stats"].keys():
		stats.set(key, data["stats"][key])
