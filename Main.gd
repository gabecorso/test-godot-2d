extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func game_over():
	
	$ScoreTimer.stop()
	$MobTimer.stop()
	$BGMusic.stop()
	$DeathSound.play()
	$HUD.show_game_over()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free") # remove all mobs on screen at once
	$BGMusic.play()


func _on_mob_timer_timeout():
	
	#create a new instance of the mob scene
	var mob = mob_scene.instantiate()
	
	#choose random spawn using the spawn path
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	#set mob direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# set mobs position to a random location
	
	mob.position = mob_spawn_location.position
	
	# randomize the direction
	
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	#choose mob velocity
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# spawn the mob and add it to the main scene
	add_child(mob)
	


func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
