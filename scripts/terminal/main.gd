extends Control


const COMPLEX_COMMANDS = ['cat', 'cd', 'man', 'run']
const SIMPLE_COMMANDS = ['clear', 'date', 'help', 'history', 'ls', 'pwd']

onready var consoleLog = $Console/console__log
onready var consoleInput = $Console/Input/console__input
onready var writeIndicator = $Console/Input/write__indicator
onready var commands = $commands
onready var anim = $anim

var simpleFunctions = [
	funcref(self, "clearTerminal"),
	funcref(self, "printDate"),
	funcref(self, "showHelp"),
	funcref(self, "printHistory"),
	funcref(self, "listContent"),
	funcref(self, "printCurrentDir")
]

var root = dir.new()
var bin = dir.new()
var user = dir.new()
var bash = dir.new()
var docs = dir.new()
var down = dir.new()
var meth = dir.new()

var tree = [root, bin, user, bash, docs, down, meth]

var translate = global.jsonify("res://media/json/langs/terminal/commands.json")

var commandHistory = []
var historyIndex = -1

var currentDir = root

var finished = false

# Called once after the scene is created.
func _ready():
	initTree()
	initTerminal()

# Called once per frame
func _process(_delta):
	consoleInput.visible = finished
	writeIndicator.visible = finished
	
	if finished == true:
		consoleInput.placeholder_text = translate["HOLDER"][global.current_lang]
	else:
		consoleInput.placeholder_text = ''

# Detects player input
func _input(_event):
	if commandHistory != []:
		if Input.is_action_pressed("ui_up") && consoleInput.has_focus():
			consoleInput.text = commandHistory[commandHistory.size() - 1]

# Initializes directory tree.
func initTree():
	root.construct('/home', 0, ['/bin', '/user', 'gettingStarted.txt'])
	bin.construct('/home/bin', 1, ['/bash', 'traveling.txt'])
	user.construct('/home/user', 1, ['/documents', '/downloads'])
	bash.construct('/home/bin/bash', 2, ['init.sh'])
	docs.construct('/home/user/documents', 2, ['user.json', 'diary.txt'])
	down.construct('/home/user/downloads', 2, ['/methodsWebsite'])
	meth.construct('/home/user/downloads/methodsWebsite', 3, ['index.html', 'styles.css'])

# Initializes the terminal.
func initTerminal():
	var br = '\n\n'
	var initialText = []
	
	initialText.insert(0, transformDate() + br)
	initialText.insert(1, global.load_file('res://media/txt/greet.txt') + br)
	initialText.insert(2, '©' + String(OS.get_datetime().year) + ' by Ne Solutions' + br)
	initialText.insert(3, global.get_file_lang('res://media/json/langs/terminal/intro.json'))
	
	for i in initialText:
		consoleLog.bbcode_text += i
	
	consoleLog.scroll_following = false
	printLog(initialText, 2) #8
	addToConsoleLog(2, currentDir.location, br)

# Gets datetime from OS and returns the full date as string.
func transformDate():
	var date = OS.get_datetime()
	var month
	var MONTHS = translate["MONTHS"][global.current_lang]
	
	for i in range(1, MONTHS.size()):
		if date.month == i:
			month = MONTHS[i]
	
	match global.current_lang:
		"en":
			return String(month + ' ' + String(date.day) + ', ' + String(date.year) + ' - ' + String(date.hour) + ':' + String(date.minute) + ':' + String(date.second))
		"es":
			return String(String(date.day) + ' de ' + month + ' de ' + String(date.year) + ' - ' + String(date.hour) + ':' + String(date.minute) + ':' + String(date.second))
		"eo":
			return String(String(date.day) + ' ' + month + ' ' + String(date.year) + ' - ' + String(date.hour) + ':' + String(date.minute) + ':' + String(date.second))

# Animates consoleLog percent_visible property.
func printLog(_dialog, duration):
	finished = false
	consoleLog.percent_visible = 0
	anim.interpolate_property(
		consoleLog, "percent_visible", 0, 1, duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	anim.start()

# Validates whether the introduced command exists or not.
func validateCommand(command):
	
	consoleInput.clear()
	
	if ' ' in command:
		if 'man' in command && command[0] == 'm':
			commands.man(command)
			return
		elif 'cat' in command && command[0] == 'c':
			commands.cat(command)
			return
		elif 'cd' in command && command[0] == 'c':
			commands.cd(command)
			return
		elif 'run' in command && command[0] == 'r':
			commands.run(command)
			return
		else:
			exceptionOccur(0, command)
			
	else:
			for i in range(0, SIMPLE_COMMANDS.size()):
				if command == SIMPLE_COMMANDS[i]:
					simpleFunctions[i].call_func()
					return
			
			if command in COMPLEX_COMMANDS:
				exceptionOccur(1, String('>' + command + translate["COMMAND"][command][global.current_lang]))
			else:
				exceptionOccur(0, command)

# Adds a new line to consoleLog bbcode.
func addToConsoleLog(type, logCont, br = '\n'):
	var newline
	
	if type == 1:
		newline = String(br + '[color=#00FF00]>' + logCont + '[/color]')
	elif type == 2:
		newline = String(br + logCont).replace('/', '[color=#FFFF00]/[/color]')
	else:
		newline = String(br + logCont)
	
	consoleLog.bbcode_text += newline

# Adds an error line to consoleLog bbcode.
func exceptionOccur(id, exception):
	if id == 0:
		addToConsoleLog(0, String(translate["ERROR"]["null"][global.current_lang] + exception))
	else:
		addToConsoleLog(0, String(translate["ERROR"]["syntax"][global.current_lang] + exception))

# Adds the introduced command to historyIndex array.
func addToHistory(command):
	historyIndex += 1
	commandHistory.insert(historyIndex, String(command))

# Simple commands
func clearTerminal():
	consoleLog.bbcode_text = ''


func printDate():
	addToConsoleLog(0, transformDate())


func showHelp():
	addToConsoleLog(0, global.get_file_lang("res://media/json/langs/terminal/help.json"))


func printHistory():
	for i in historyIndex + 1:
		addToConsoleLog(0, String(i) + String(': ' + commandHistory[i]))


func listContent():
	for i in currentDir.content:
			if i.length() > 0:
				addToConsoleLog(2, i)


func printCurrentDir():
	addToConsoleLog(2, currentDir.location)

# Signals.
func _on_anim_tween_completed(_object, _key):
	finished = true
	consoleLog.scroll_following = true


func _on_console__input_text_entered(new_text):
	if new_text.empty() != true:
		addToConsoleLog(1, new_text, '\n\n')
		validateCommand(new_text)
		addToHistory(new_text)
