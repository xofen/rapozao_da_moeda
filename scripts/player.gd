extends Area2D

signal pickup
signal hurt

@export var speed = 350

var velocity = Vector2.ZERO
var screensize = Vector2(480, 720)


func _process(delta):
	velocity = Input.get_vector("left", "right", "up", "down")
	position += velocity * speed * delta
	
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0


func start():
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"


func die():
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)


func _on_area_entered(area):
	if area.is_in_group("Coins"):
		area.pickup()
		pickup.emit("coin")
	
	if area.is_in_group("Obstacles"):
		hurt.emit()
		die()
	
	if area.is_in_group("PowerUps"):
		area.pickup()
		pickup.emit("powerup")

