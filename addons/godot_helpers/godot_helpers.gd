@tool
extends EditorPlugin

const SINGLETONS = {
	'EventBus': 'EventBus.gd',
	'Helpers': 'Helpers.gd',
}

func _enter_tree():
	print('Initializing Godot Helpers')

	for key in SINGLETONS.keys():
		var path = 'Singletons/%s' % SINGLETONS[key]
		print('Loading "%s" Singleton at "%s"' % [key, path])
		add_autoload_singleton(key, path)


func _exit_tree():
	print('Deinitializing Godot Helpers')

	for key in SINGLETONS.keys():
		print('Clearing "%s" Singleton' % key)
		remove_autoload_singleton(key)

	pass
