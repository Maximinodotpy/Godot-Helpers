extends Button

@export_file('*.tscn') var scene

func _ready():
	## SET PROCESS MODE TO ALWAYS

	print('Scene Switch Button Ready')

	var err = connect("button_down", pressed)

	print(err)

func pressed():
	print('Trying to Switch')

	if scene:
		print('Switching To '+scene)
		get_tree().change_scene_to_file(scene)

