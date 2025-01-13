extends CharacterBody2D

const SPAWN_COOLDOWN = 10.0
var can_spawn = true

@onready
var player: CharacterBody2D = get_node("/root/MainLevel/Player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if can_spawn and player_in_range():
		const BAT = preload("res://bat.tscn")
		var bat = BAT.instantiate()
		bat.global_position = self.global_position + Vector2(randf_range(-100, 100), randf_range(-200, -100))
		add_sibling(bat)
		can_spawn = false
		get_tree().create_timer(SPAWN_COOLDOWN).timeout.connect(func (): can_spawn=true)

	move_and_slide()
	
func player_in_range() -> bool:
	for body in $ActiveArea.get_overlapping_bodies():
		if body == player:
			return true
	return false

func enemy_damage() -> void:
	self.queue_free()
