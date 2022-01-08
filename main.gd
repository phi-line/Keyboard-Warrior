#extends Node2D
#
#onready var file = 'res://levels/desktop/dictionary.txt'
#
#var dictionary = []
#
#
#func _ready():
#    load_file(file)
#
#
#func load_file(file: String) -> void:
#    var f = File.new()
#    f.open(file, File.READ)
#
#    while not f.eof_reached():
#        dictionary.append(f.get_line())
#    f.close()
#
