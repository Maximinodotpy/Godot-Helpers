extends Node

## This is a Collection of Helper Functions
##
## Some of these functions are used elsewhere in the Godot Helpers Plugin
## so it is crucial that this Singleton is activated

## Will return the Root Node of the Scene ( Not the Singletons and not the Windows )
func getSceneRoot() -> Node:
	return get_tree().root.get_child(-1)

func formatSeconds(time : float, use_milliseconds : bool) -> String:
	var minutes := time / 60
	var seconds := fmod(time, 60)
	if not use_milliseconds:
		return "%02d:%02d" % [minutes, seconds]
	var milliseconds := fmod(time, 1) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func getAllFilesInDirectory(path, extension = '') -> Array:
	var files = []
	var dir = DirAccess.open(path)

	if dir:
		dir.list_dir_begin()

		while true:
			var file = dir.get_next()
			if file == "":
				break
			elif not file.begins_with("."):
				files.append(file)

		return files

	return []

func objectHasTheseKeys(object: Dictionary, keys: Array) -> bool:
	for requiredKey in keys:
		if not requiredKey in object:
			print('Object is missing required Key "%s" ' % requiredKey, object)
			return false
			break

	return true

func connectEventIfItExists(node: Node, event: String, callable: Callable):
	if node.has_signal(event):
		node.connect(event, callable)

## Will ensure that the file exists at the given path
func ensureFileExists(path: String):
	if not FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.WRITE)
		file.close()

## Will open a json file and return its parsed contents
func getFileAsJson(path: String) -> Dictionary:
	return JSON.parse_string(FileAccess.open(path, FileAccess.READ).get_as_text())
