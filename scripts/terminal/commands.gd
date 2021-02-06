extends Node


onready var main = get_parent()

# Checks if command syntax is correct (if not return an error log)
func syntaxCheck(command, option):
	if !'  ' in command:
		if 'cd ' in command:
			return true
		elif ' ' in command[3]:
			return true
	
	if '  ' in command:
		main.exceptionOccur(0, command)
	else:
		main.exceptionOccur(1, String('>' + command.replace(" ", "") + ' ' + option))

# Complex commands
func cat(syntax):
	if syntaxCheck(syntax, '[file]'):
		print('cat success')


func cd(syntax):
	if syntaxCheck(syntax, '[directory]') && syntax != 'cd ':
		var dir = syntax.replace('cd', '').replace(' ', '')
		
		if dir == '/':
			changeDirectory(main.root)
			
		elif dir == '..':
			if main.currentDir != main.root:
				if main.currentDir.index == 1:
					changeDirectory(main.root)
				else:
					var parentDir = getDirParent(main.currentDir)
					changeDirectory(parentDir)
			else:
				main.addToConsoleLog(0, 'You are already in the root directory')
		
		elif dir != '':
			var dirValidate = dirExists(dir)
			
			if dirValidate != null:
				var dirLocation = String(main.currentDir.location + dir)
				
				if dirLocation == dirValidate.location:
					changeDirectory(dirValidate)
				else:
					main.addToConsoleLog(0, String('Directory ' + dir + ' not found'))
	else:
		main.exceptionOccur(1, String('>' + syntax.replace(" ", "") + ' [directory]'))

func getDirParent(dir):
	var parentIndex = dir.index - 1
	
	for i in main.tree:
		if i.index == parentIndex:
			if i.location in dir.location:
				return i

func dirExists(dir):
	if dir == main.currentDir.location:
		main.addToConsoleLog(0, String('Currently in ' + dir))
	elif dir[0] == '/':
		for i in main.tree:
			if dir in i.location:
				return i
		
		main.addToConsoleLog(0, String('Directory ' + dir + ' not found'))
	else:
		main.exceptionOccur(1, String('maybe you meant -> /' + dir.replace('/', '')))

func changeDirectory(dir):
	main.currentDir = dir


func man(syntax):
	if syntaxCheck(syntax, '[command]'):
			var param = ['mancat', 'mancd', 'manclear', 'mandate', 'manhelp', 'manhistory', 'manls', 'manman', 'manrun', 'manpwd']
			var option = String(syntax.replace(" ", ""))
			
			for i in range(0, param.size()):
				if option == param[i]:
					var route = String('res://media/txt/desc/' + option + '.txt')
					main.addToConsoleLog(0, main.load_file(route))
					return true
					
			main.exceptionOccur(1, String('>man ' + option.replace("man", "") + ' [nonexistent option]'))


func run(syntax):
	if syntaxCheck(syntax, '[file]'):
		print('run success')
