extends CharacterBody2D

@export
var CHARGE_RATE = 1.0

var harpoon_charge = 0.0
var is_harpoon_shot = false

var harpoon_position: Vector2
var harpoon_velocity: Vector2

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_harpoon_shot:
		harpoon_physics_process(delta)
	else:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			harpoon_charge += CHARGE_RATE * delta

	move_and_slide()
	
func harpoon_physics_process(delta: float) -> void:
	harpoon_velocity += get_gravity() * delta
	harpoon_position += harpoon_velocity * delta
	
	$Harpoon.global_position=harpoon_position
	
func calc_initial_harpoon_speed() -> float:
	return clampf(1000*harpoon_charge**2, 500, 4000)
	
# Uses event to calculate direction from player to mouse
func shoot_harpoon(event) -> void:
	print("Shot with charge: ", harpoon_charge, " and speed: ", calc_initial_harpoon_speed())
	
	harpoon_position = self.global_position
	var harpoon_initial_direction = self.get_global_transform_with_canvas().get_origin().direction_to(event.position)
	harpoon_velocity = calc_initial_harpoon_speed() * harpoon_initial_direction
	
	# reset the charge
	harpoon_charge = 0.0
	is_harpoon_shot = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_released():
		if event.button_index == MOUSE_BUTTON_LEFT:
			# the mouse was released
			if is_harpoon_shot:
				pass # TODO
			else:
				# was not shot, so shoot
				shoot_harpoon(event)
