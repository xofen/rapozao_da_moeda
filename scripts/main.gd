extends Node


@export var coin_scene : PackedScene
@export var powerup : PackedScene
@export var cactus : PackedScene
@export var playtime = 30


var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false


func _ready():
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()


func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)


func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		$LevelSound.play()


func spawn_cactus():
	for i in level + 1:
		var d = cactus.instantiate()
		add_child(d)
		d.screensize = screensize
		d.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
		 


func _process(_delta):
	if playing and get_tree().get_nodes_in_group("Coins").size() == 0:
		level += 1
		time_left += 5
		spawn_cactus()
		spawn_coins()
		$PowerUpTimer.start()


func _on_game_timer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_pickup(type):
	match type:
		"coin":
			score += 1
			$HUD.update_score(score)
			$CoinSound.play()
		"powerup":
			$PWSound.play()
			time_left += 5
			$HUD.update_timer(time_left)


func _on_player_hurt():
	game_over()


func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("Coins", "queue_free")
	get_tree().call_group("Obstacles", "queue_free")
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()


func _on_hud_start_game():
	new_game()


func _on_power_up_timer_timeout():
	var p = powerup.instantiate()
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))

