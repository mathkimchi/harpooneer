extends CharacterBody2D


const SPEED = 150.0
const FLAP_VELOCITY = -300.0
const BAT_FLAP_COOLDOWN = 1.0

var can_flap = true

@onready
var player: CharacterBody2D = get_node("/root/MainLevel/Player")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		#velocity += Vector2.DOWN * delta * 100
		velocity += get_gravity() * delta * 0.4

	# Handle jump.
	if can_flap and (-player.global_position.y >= -self.global_position.y): # up is negative
		velocity.y = FLAP_VELOCITY
		can_flap = false
		# handle flap time out, thanks to: https://www.reddit.com/r/godot/comments/17xdzcq/im_trying_to_make_a_cooldown_so_the_player_doesnt/
		get_tree().create_timer(BAT_FLAP_COOLDOWN, true, true).timeout.connect(func (): can_flap=true)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var x_direction := self.global_position.direction_to(player.global_position).x	
	velocity.x = x_direction * SPEED

	move_and_slide()

# special name for the harpoon
func enemy_damage()->void:
	self.queue_free()
