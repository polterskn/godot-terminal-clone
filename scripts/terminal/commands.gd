extends Node


onready var main = get_parent()

# Checks if command syntax is correct (if not return an error log)
func syntaxCheck(command, option):
	if 'cd ' in command:
		return true
	elif ' ' in command[3]:
		return true
	else:
		main.exceptionOccur(1, String('>' + command.replace(" ", "") + ' ' + option))

# Complex commands
func cat(syntax):
	if syntaxCheck(syntax, '[file]'):
		print('cat success')


func cd(syntax):
	if syntaxCheck(syntax, '[directory]'):
		print('cd success')


func man(syntax):
	if syntaxCheck(syntax, '[command]') && 'm' in syntax[0]:
			var param = ['mancat', 'mancd', 'manclear', 'mandate', 'manhelp', 'manhistory', 'manls', 'manman', 'manrun', 'manpwd']
			var option = String(syntax.replace(" ", ""))
			
			for i in range(0, param.size()):
				if option == param[i]:
					var route = String('res://media/txt/desc/' + option + '.txt')
					main.addToConsoleLog(0, main.load_file(route))
					return
					
			main.exceptionOccur(1, String('>man ' + option.replace("man", "") + ' [nonexistent option]'))


func run(syntax):
	if syntaxCheck(syntax, '[file]'):
		print('run success')
