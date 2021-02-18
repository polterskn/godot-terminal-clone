extends Node


onready var main = get_parent()

# Checks if command syntax is correct (if not return an error log)
func syntaxCheck(command):
	if !'  ' in command:
		if 'cd ' in command:
			return true
		elif ' ' in command[3]:
			return true

# Complex commands
func cat(syntax):
	if syntaxCheck(syntax) && syntax != 'cat ':
		if main.currentDir.content != []:
			var file = syntax.replace('cat', '').replace(' ', '')
			
			for i in main.currentDir.content:
				if i == file && !('/' in file):
					if !'.sh' in file:
						var route
						
						if '.txt' in file:
							route = String('res://media/txt/' + file)
						elif '.css' in file:
							file.erase(file.length() - 4, 4)
						else:
							file.erase(file.length() - 5, 5)
						
						if route == null:
							route = String('res://media/txt/' + file + '.txt')
						
						main.addToConsoleLog(0, main.load_file(route))
						return
					
					else:
						main.addToConsoleLog(0, 'cat: Unsupported file type')
						return
			
			main.addToConsoleLog(0, String('cat: File ' + file + ' not found'))
		
		else:
			main.addToConsoleLog(0, 'cat: Current directory is empty')
	else:
		main.exceptionOccur(1, String('>cat [file]'))


func cd(syntax):
	if syntaxCheck(syntax) && syntax != 'cd ':
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
				main.addToConsoleLog(0, 'cd: You are already in the root directory')
		
		elif dir != '':
			var dirValidate = dirExists(dir)
			
			if dirValidate != null:
				var dirLocation = String(main.currentDir.location + dir)
				
				if dirLocation == dirValidate.location:
					changeDirectory(dirValidate)
				else:
					main.addToConsoleLog(0, String('cd: Directory ' + dir + ' not found'))
	else:
		main.exceptionOccur(1, String('>cd [directory]'))

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
		
		main.addToConsoleLog(0, String('cd: Directory ' + dir + ' not found'))
	else:
		main.exceptionOccur(1, String('cd: Maybe you meant -> /' + dir.replace('/', '')))

func changeDirectory(dir):
	main.currentDir = dir


func man(syntax):
	if syntaxCheck(syntax) && syntax != 'man ':
			var param = ['mancat', 'mancd', 'manclear', 'mandate', 'manhelp', 'manhistory', 'manls', 'manman', 'manrun', 'manpwd']
			var option = String(syntax.replace(" ", ""))
			
			for i in range(0, param.size()):
				if option == param[i]:
					var route = String('res://media/txt/desc/' + option + '.txt')
					main.addToConsoleLog(0, main.load_file(route))
					return
					
			main.addToConsoleLog(0, String('man: ' + option.replace("man", "") + ': Nonexistent option'))
	else:
		main.exceptionOccur(1, String('>man [command]'))


func run(syntax):
	if syntaxCheck(syntax) && syntax != 'run ':
		if main.currentDir.content != []:
			var file = syntax.replace('run', '').replace(' ', '')
			
			for i in main.currentDir.content:
				if i == file && !('/' in file):
					if '.sh' in file:
						print('run success on ', file)
						return
					
					else:
						main.addToConsoleLog(0, 'run: Unsupported file type')
						return
			
			main.addToConsoleLog(0, String('run: File ' + file + ' not found'))
		
		else:
			main.addToConsoleLog(0, 'run: Current directory is empty')
	else:
		main.exceptionOccur(1, String('>run [file]'))
