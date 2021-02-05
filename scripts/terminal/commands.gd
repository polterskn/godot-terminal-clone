extends Node


onready var main = get_parent()


func syntaxCheck(command, option):
	if 'cd ' in command:
		return true
	elif ' ' in command[3]:
		return true
	else:
		main.exceptionOccur(1, String('>' + command.replace(" ", "") + ' ' + option))

func cat(syntax):
	if syntaxCheck(syntax, '[file]'):
		print('cat success')


func cd(syntax):
	if syntaxCheck(syntax, '[directory]'):
		print('cd success')


func man(syntax):
	if syntaxCheck(syntax, '[command]') && 'm' in syntax[0]:
			var option = String(syntax.replace(" ", ""))
			
			match option:
				'mancat':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/cat.txt'))
				'mancd':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/cd.txt'))
				'manclear':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/clear.txt'))
				'mandate':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/date.txt'))
				'manhelp':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/help.txt'))
				'manhistory':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/history.txt'))
				'manls':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/ls.txt'))
				'manman':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/man.txt'))
				'manrun':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/run.txt'))
				'manpwd':
					main.addToConsoleLog(0, main.load_file('res://media/txt/desc/pwd.txt'))
				_:
					main.exceptionOccur(1, String('>man ' + option.replace("man", "") + ' [nonexistent option]'))


func run(syntax):
	if syntaxCheck(syntax, '[file]'):
		print('run success')
