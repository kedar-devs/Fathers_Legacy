extends Sprite

func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var GrassEffect=load("res://Effects/grasseffect.tscn")
		var grasseffect=GrassEffect.instance()
		var main=get_tree().current_scene
		main.add_child(grasseffect)
		grasseffect.global_position=global_position
		queue_free()
