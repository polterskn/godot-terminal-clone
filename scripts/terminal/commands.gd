extends Node


onready var main = get_parent()

# Checks if command syntax is correct.
func syntaxCheck(command):
	if !'  ' in command:
		if 'cd ' in command:
			return true
		elif ' ' in command[3]:
			return true

# Complex commands.
func cat(syntax):
	if syntaxCheck(syntax) && syntax != 'cat ':
		if main.currentDir.content != []:
			var file = syntax.replace('cat', '').replace(' ', '')
			
			for i in main.currentDir.content:
				if i == file && !('/' in file):
					if !'.sh' in file:
						var route
						
						if '.txt' in file:
							file.erase(file.length() - 4, 4)
							route = String('res://media/json/langs/terminal/' + file + '.json')
							main.addToConsoleLog(0, global.get_file_lang(route))
							return
						elif ".css" in file:
							file.erase(file.length() - 4, 4)
						else:
							file.erase(file.length() - 5, 5)
						
						if route == null:
							route = String('res://media/txt/' + file + '.txt')
						
						main.addToConsoleLog(0, global.load_file(route))
						return
					
					else:
						main.addToConsoleLog(0, main.translate["EXCEPTION"]["cat"]["type"][global.current_lang])
						return
			
			var arr = main.translate["EXCEPTION"]["cat"]["null"][global.current_lang].split("/", true, 1)
			main.addToConsoleLog(0, String(arr[0] + file + arr[1]))
		
		else:
			main.addToConsoleLog(0, main.translate["EXCEPTION"]["cat"]["empty"][global.current_lang])
	else:
		main.exceptionOccur(1, String('>cat' + main.translate["COMMAND"]["cat"][global.current_lang]))


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
				main.addToConsoleLog(0, main.translate["EXCEPTION"]["cd"]["already"][global.current_lang])
		
		elif dir != '':
			var dirValidate = dirExists(dir)
			
			if dirValidate != null:
				var dirLocation = String(main.currentDir.location + dir)
				
				if dirLocation == dirValidate.location:
					changeDirectory(dirValidate)
				else:
					var arr = main.translate["EXCEPTION"]["cd"]["null"][global.current_lang].split("/", true, 1)
					main.addToConsoleLog(0, String(arr[0] + dir + arr[1]))
	else:
		main.exceptionOccur(1, String('>cd' + main.translate["COMMAND"]["cd"][global.current_lang]))

func getDirParent(dir):
	var parentIndex = dir.index - 1
	
	for i in main.tree:
		if i.index == parentIndex:
			if i.location in dir.location:
				return i

func dirExists(dir):
	if dir == main.currentDir.location:
		main.addToConsoleLog(0, String(main.translate["EXCEPTION"]["cd"]["current"][global.current_lang] + dir))
	elif dir[0] == '/':
		for i in main.tree:
			if dir in i.location:
				return i
		
		var arr = main.translate["EXCEPTION"]["cd"]["null"][global.current_lang].split("/", true, 1)
		main.addToConsoleLog(0, String(arr[0] + dir + arr[1]))
	else:
		main.exceptionOccur(1, String(main.translate["EXCEPTION"]["cd"]["syntax"][global.current_lang] + dir.replace('/', '')))

func changeDirectory(dir):
	main.currentDir = dir


func man(syntax):
	if syntaxCheck(syntax) && syntax != 'man ':
			var param = ['mancat', 'mancd', 'manclear', 'mandate', 'manhelp', 'manhistory', 'manls', 'manman', 'manrun', 'manpwd']
			var option = String(syntax.replace(" ", ""))
			
			for i in range(0, param.size()):
				if option == param[i]:
					var route = String('res://media/json/langs/terminal/desc/' + option + '.json')
					main.addToConsoleLog(0, global.get_file_lang(route))
					return
					
			main.addToConsoleLog(0, String('man: ' + option.replace("man", "") + main.translate["EXCEPTION"]["man"]["null"][global.current_lang]))
	else:
		main.exceptionOccur(1, String('>man' + main.translate["COMMAND"]["man"][global.current_lang]))


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
						main.addToConsoleLog(0, main.translate["EXCEPTION"]["run"]["type"][global.current_lang])
						return
			
			var arr = main.translate["EXCEPTION"]["run"]["null"][global.current_lang].split("/", true, 1)
			main.addToConsoleLog(0, String(arr[0] + file + arr[1]))
		
		else:
			main.addToConsoleLog(0, main.translate["EXCEPTION"]["run"]["empty"][global.current_lang])
	else:
		main.exceptionOccur(1, String('>run' + main.translate["COMMAND"]["run"][global.current_lang]))
