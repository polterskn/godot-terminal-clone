extends Node

const LANGS = ["en", "es", "eo"]

var current_lang


func _ready():
	current_lang = get_language()


func jsonify(file):
	var f = File.new()
	f.open(file, File.READ)
	var data = f.get_as_text()
	var result = JSON.parse(data).result
	f.close()
	return result


func get_file_lang(file):
	var media = jsonify(file)
	return media[current_lang]["content"]

# Gets txt files and returns their content as string.
func load_file(file):
	var f = File.new()
	f.open(file, File.READ)
	var data = f.get_as_text()
	f.close()
	return data


func get_language():
	var lang = OS.get_locale()
	
	if "_" in lang:
		var arr = lang.split("_", true, 1)
		lang = arr[0]
	
	if !lang in LANGS:
		lang = LANGS[0]
	
	return lang


func change_scene(path):
	assert(get_tree().change_scene(path) == OK)
