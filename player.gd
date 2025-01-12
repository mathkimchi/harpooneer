extends CharacterBody2D

@export
var CHARGE_RATE = 1.0

var harpoon_charge = 0.0
var is_harpoon_shot = false


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if !is_harpoon_shot:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			harpoon_charge += CHARGE_RATE * delta

	move_and_slide()
	
func shoot_harpoon() -> void:
	# reset the charge
	print("Shot with charge: ", harpoon_charge)
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
				shoot_harpoon()
