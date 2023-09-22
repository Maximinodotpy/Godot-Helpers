extends Control

@export() var configFilePath: String
@export_file('*.json') var schemaPath = "res://addons/godot_helpers/Settings View/example.json"


const SCHEMA_TYPES = [
	'select',
	'bool',
	'text',
	'number',
]

const REQUIRED_KEYS = [
	'name',
	'type',
	'description',
	'default',
]

var schema = {}
var configFile : ConfigFile

# Called when the node enters the scene tree for the first time.
func _ready():
	# Create all these Elements
	configFile = ConfigFile.new()

	# Ensuring that the File Exists
	Helpers.ensureFileExists(configFilePath)

	configFile.load(configFilePath)

	# Load the Schema
	var schema = Helpers.getFileAsJson(schemaPath)

	for section in schema.keys():
		print(section)

		var sectionVBox = VBoxContainer.new()
		var sectionLabel = Label.new()
		sectionVBox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		sectionLabel.text = section
		sectionVBox.add_child(sectionLabel)

		for row in schema[section]:

			if not Helpers.objectHasTheseKeys(row, REQUIRED_KEYS):
				continue

			var rowVHox = HBoxContainer.new()
			rowVHox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			var rowLabel = Label.new()

			rowVHox.add_child(rowLabel)

			rowLabel.text = row['name']

			var value = configFile.get_value(section, row['name'], row['default'])
			var inputElement = LineEdit.new()

			if row['type'] == 'bool':
				inputElement = CheckBox.new()
				inputElement.button_pressed = value

			elif row['type'] == 'text':
				inputElement = LineEdit.new()
				inputElement.text = value

			elif row['type'] == 'select':
				inputElement = OptionButton.new()

				# TODO CHECK IF ROW HAS options KEY
				# TODO CHECK IF THE DEFAULT VALUE IS IN THE OPTIONS

				for item in row['options']:
					inputElement.add_item(item)

				var currentId = row['options'].find(configFile.get_value(section, row['name'], row['default']))

				inputElement.selected = currentId

			var inter = func inter(arg1 = null, arg2 = null, arg3 = null):
				registerChanges(inputElement, section, row['name'], row)

			# Connect All these Events to ensure that Changes on the Input element are registered
			Helpers.connectEventIfItExists(inputElement, 'focus_exited', inter)
			Helpers.connectEventIfItExists(inputElement, 'text_changed', inter)
			Helpers.connectEventIfItExists(inputElement, 'pressed', inter)
			Helpers.connectEventIfItExists(inputElement, 'item_selected', inter)

			inputElement.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			rowLabel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			rowVHox.add_child(inputElement)
			sectionVBox.add_child(rowVHox)

		$"v".add_child(sectionVBox)

func registerChanges(node: Node, section: String, key: String, row):
	print('Changes by %s in %s:%s' % [node, section, key])

	var value = 0

	if node is CheckBox:
		value = node.button_pressed
	elif node is OptionButton:
		value = row['options'][node.selected]
	else:
		value = node.text

	configFile.set_value(section, key, value)
	configFile.save(configFilePath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
