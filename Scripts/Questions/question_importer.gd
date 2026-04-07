class_name QuestionImporter
extends Node

var file_path: String
var questions: Dictionary

var question_stride = 8

func _ready() -> void:
	file_path = "res://Questions.txt"
	read_questions()

func read_questions() -> void:
	questions.clear()
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	var lines = content.split("\n", true)
	
	for i in len(lines):
		lines.set(i, lines.get(i).strip_edges())
		if i % question_stride != 0:
			continue
		if i == len(lines) - 1 and lines.get(i) == "":
			break
		var q = Question.new()
		q.Text = lines.get(i+1)
		q.Option1 = lines.get(i+2)
		q.Option2 = lines.get(i+3)
		q.Option3 = lines.get(i+4)
		q.Option4 = lines.get(i+5)
		q.CorrectAnswer = lines.get(i+6)
		questions[int(lines.get(i))] = q
	
	for id in questions.keys():
		print(questions[id].Text)
