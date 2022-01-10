extends "res://attacks/base/Base.gd"

# Min/Max speed range
export var min_speed = 150
export var max_speed = 250

# The current velocity of the attack
var velocity = Vector2()

# bounce on wall hit
func _physics_process(delta):
    var collision = move_and_collide(velocity * delta)
    if collision:
        velocity = velocity.bounce(collision.normal)
        if collision.collider.has_method("hit"):
            collision.collider.hit()
