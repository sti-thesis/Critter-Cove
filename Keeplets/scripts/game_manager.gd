extends Node

const SAVE_PATH := "user://save_data.json"
const HUNGER_RATE = 1  
const TIME_INTERVAL = 60  
const MIN_HUNGER = 0  
const MAX_HUNGER = 100
const FEED_VALUE = 20

var time_elapsed = 0.0
var save_data: Dictionary = {
	"leaf": 0,
	"sampaguita": 0,
	"last_time": 0.0,
	"animals": {
		"tarsier":{
			"unlocked": false,
			"hunger": 0
		},
		"eagle":{
			"unlocked": false,
			"hunger": 0
		},
		"dove":{
			"unlocked": false,
			"hunger": 0
		},
		"deer":{
			"unlocked": false,
			"hunger": 0
		},
		"peacock":{
			"unlocked": false,
			"hunger": 0
		},
		"cat":{
			"unlocked": false,
			"hunger": 0
		},
		"lizard":{
			"unlocked": false,
			"hunger": 0
		},
		"turtle":{
			"unlocked": false,
			"hunger": 0
		},
		"hornbill":{
			"unlocked": false,
			"hunger": 0
		},
		"rat":{
			"unlocked": false,
			"hunger": 0
		}
	},
	"items": {
		"mango": 0,
		"insect": 0,
	}
	
}

func _ready() -> void:
	load_game()
	update_all_hunger()
	print(ProjectSettings.globalize_path(SAVE_PATH))


func _process(delta: float) -> void:
	time_elapsed += delta
	if time_elapsed >= 1.0:
		time_elapsed = 0.0  # Reset timer
		save_data["last_time"] = Time.get_unix_time_from_system()
		save_game()
func save_game():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()
func load_game():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var content = file.get_as_text()
			file.close()
			var json = JSON.new()
			var parse_result = json.parse(content)
			
			if parse_result == OK:
				var loaded_data = json.get_data()
				if loaded_data is Dictionary:
					merge_defaults(loaded_data)
				else:
					print("Invalid save data format, resetting to defaults.")
					save_data = get_default_values()
			else:
				print("Failed to parse save data, resetting to defaults.")
				save_data = get_default_values()
	else:
		print("No save file found, using default values.")
		save_data = get_default_values()
		save_game()
func update_all_hunger():
	var current_time = Time.get_unix_time_from_system()  # get time now
	var last_time = int(save_data["last_time"])
	var elapsed_time = current_time - last_time
	
	if elapsed_time >= TIME_INTERVAL:
		var hunger_decrease = int(elapsed_time / TIME_INTERVAL) * HUNGER_RATE
		
		for animal_name in save_data["animals"]:
			var current_hunger = save_data["animals"][animal_name]["hunger"]
			save_data["animals"][animal_name]["hunger"] = max(MIN_HUNGER, current_hunger - hunger_decrease)  
		save_data["last_time"] = current_time 
		
	print("Updated hunger for all animals!")
func feed_animal(animal_name: String):
	if animal_name in save_data["animals"]:
		var current_hunger = save_data["animals"][animal_name]["hunger"]
		save_data["animals"][animal_name]["hunger"] = min(MAX_HUNGER, current_hunger + FEED_VALUE)
		print(animal_name, " fed! Hunger: ", save_data["animals"][animal_name]["hunger"])
		save_game()
	else:
		print("Invalid animal:", animal_name)

func merge_defaults(loaded_data: Dictionary):
	for key in save_data.keys():
		if key in loaded_data:
			save_data[key] = loaded_data[key]
		else:
			print("Missing key in save file:", key, "Setting to default.")
	save_game()
func get_default_values() -> Dictionary:
	return {
		"leaf": 0,
		"sampaguita": 0,
		"last_time": 0.0,
		"animals": {
			"tarsier":{
				"unlocked": false,
				"hunger": 10
			},
			"eagle":{
				"unlocked": false,
				"hunger": 20
			},
			"dove":{
				"unlocked": false,
				"hunger": 30
			},
			"deer":{
				"unlocked": false,
				"hunger": 0
			},
			"peacock":{
				"unlocked": false,
				"hunger": 0
			},
			"cat":{
				"unlocked": false,
				"hunger": 0
			},
			"lizard":{
				"unlocked": false,
				"hunger": 0
			},
			"turtle":{
				"unlocked": false,
				"hunger": 0
			},
			"hornbill":{
				"unlocked": false,
				"hunger": 0
			},
			"rat":{
				"unlocked": false,
				"hunger": 0
			}
		},
		"items": {
			"mango": 0,
			"insect": 0,
		}
	}
