extends Node2D


func _on_0_body_entered(body):
	if body is KinematicBody2D:
		global.change_scene("res://scenes/locations/map_left/main_left.tscn")
