extends CharacterBody2D



enum HarpoonState {CHARGING, SHOT, REELING}
var harpoon_state: HarpoonState = HarpoonState.CHARGING

var harpoon_locked = false

@export
var CHARGE_RATE = 1.0
var harpoon_charge = 0.0

var harpoon_position: Vector2
var harpoon_velocity: Vector2

var harpoon_revert_speed = 0.0

func init_harpoon():
	harpoon_state = HarpoonState.CHARGING
	harpoon_charge = 0.0
	harpoon_locked = false
	harpoon_position = Vector2.ZERO #whatever, this will be updated anyways
	harpoon_velocity = Vector2.ZERO
	harpoon_revert_speed = 0.0
	$Harpoon.global_position=self.global_position
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	match harpoon_state:
		HarpoonState.CHARGING:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				harpoon_charge += CHARGE_RATE * delta
		HarpoonState.SHOT:
			harpoon_physics_process(delta)
		HarpoonState.REELING:
			pass

	move_and_slide()
	
func harpoon_physics_process(delta: float) -> void:
	if harpoon_locked:
		return
	
	for body in $Harpoon/Area2D.get_overlapping_bodies():
		if body == self:
			continue
		
		print(body)
		harpoon_locked = true
	
	harpoon_velocity += get_gravity() * delta
	harpoon_position += harpoon_velocity * delta
	
	$Harpoon.global_position=harpoon_position

#func recall_harpoon() -> void:
	#var difference = harpoon_position - self.global_position
	#
	#self.velocity = calc_self_speed_on_recall(difference.length())*difference.normalized()
	#
	## revert harpoon settings to normal
	
	
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
	harpoon_state = HarpoonState.SHOT

func _input(event: InputEvent) -> void:
	if !(event is InputEventMouseButton) or event.button_index != MOUSE_BUTTON_LEFT:
		# only one button, remember?
		return
	
	
	if event.is_released():
		# the mouse was released
		match harpoon_state:
			HarpoonState.CHARGING:
				# done charging, now shoot
				shoot_harpoon(event)
			HarpoonState.REELING:
				# stop reeling and reset harpoon back to charging mode
				init_harpoon()
	elif event.is_pressed():
		match harpoon_state:
			HarpoonState.SHOT:
				# start reeling
				harpoon_state = HarpoonState.REELING
