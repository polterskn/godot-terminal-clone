extends Control


const ROOT_DIR = '/home/user'
const MONTHS = ['', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']

onready var consoleLog = $Console/console__log
onready var consoleInput = $Console/Input/console__input
onready var writeIndicator = $Console/Input/write__indicator
onready var commands = $commands
onready var anim = $anim

var commandHistory = []
var historyIndex = -1

var currentDirectory

var finished = false


func _ready():
	initTerminal()


func _process(_delta):
	consoleInput.visible = finished
	writeIndicator.visible = finished
	
	if finished == true:
		consoleInput.placeholder_text = '[Waiting for input]'
	else:
		consoleInput.placeholder_text = ''


func initTerminal():
	var br = '\n\n'
	var initialText = []
	
	initialText.insert(0, transformDate() + br)
	initialText.insert(1, load_file('res://media/txt/greet.txt') + br)
	initialText.insert(2, '©' + String(OS.get_datetime().year) + ' by Ne Solutions' + br)
	initialText.insert(3, load_file('res://media/txt/intro.txt'))
	
	for i in initialText:
		consoleLog.bbcode_text += i
	
	consoleLog.scroll_following = false
	printLog(initialText, 2) #10
	currentDirectory = ROOT_DIR


func transformDate():
	var date = OS.get_datetime()
	var month
	
	for i in range(1, MONTHS.size()):
		if date.month == i:
			month = MONTHS[i]
	
	return String(month + ' ' + String(date.day) + ', ' + String(date.year) + ' - ' + String(date.hour) + ':' + String(date.minute) + ':' + String(date.second))


func load_file(file):
	var f = File.new()
	var data
	f.open(file, File.READ)
	data = f.get_as_text()
	f.close()
	return data


func printLog(_dialog, duration):
	finished = false
	consoleLog.percent_visible = 0
	anim.interpolate_property(
		consoleLog, "percent_visible", 0, 1, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	anim.start()


func validateCommand(command):
	
	consoleInput.clear()
	
	if ' ' in command:
		if 'man' in command:
			commands.man(command)
			return
		elif 'cat' in command:
			commands.cat(command)
			return
		elif 'cd' in command:
			commands.cd(command)
			return
		elif 'run' in command:
			commands.run(command)
			return
		else:
			exceptionOccur(0, command)
			
	else:
			match command:
				'clear':
					consoleLog.bbcode_text = ''
				'date':
					addToConsoleLog(0, transformDate())
				'help':
					addToConsoleLog(0, load_file('res://media/txt/help.txt'))
				'history':
					printHistory()
				'ls':
					pass # List content
				'pwd':
					addToConsoleLog(0, currentDirectory)
				_:
					match command:
						'man':
							exceptionOccur(1, String(command + ' [command]'))
						'cat':
							exceptionOccur(1, String(command + ' [file]'))
						'cd':
							exceptionOccur(1, String(command + ' [directory]'))
						'run':
							exceptionOccur(1, String(command + ' [file]'))
						_:
							exceptionOccur(0, command)


func addToConsoleLog(isLog, command, br = '\n'):
	var newline
	
	if isLog == 1:
		newline = String(br + '[color=#00FF00]>' + command + '[/color]')
	else:
		newline = String(br + command)
	
	consoleLog.bbcode_text += newline


func exceptionOccur(id, exception):
	if id == 0:
		addToConsoleLog(0, String('Command not found: ' + exception))
	else:
		addToConsoleLog(0, String('Syntax error: ' + exception))


func addToHistory(command):
	historyIndex += 1
	commandHistory.insert(historyIndex, String(command))


func printHistory():
	for i in historyIndex + 1:
		addToConsoleLog(0, String(i) + String(': ' + commandHistory[i]))


func _on_anim_tween_completed(_object, _key):
	finished = true
	consoleLog.scroll_following = true


func _on_console__input_text_entered(new_text):
	if new_text.empty() != true:
		addToConsoleLog(1, new_text, '\n\n')
		validateCommand(new_text)
		addToHistory(new_text)
