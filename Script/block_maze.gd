extends Node2D

@onready var tilemaplayer = $TileMapLayer

@export var ROWS = 25
@export var COLS = 25
@export var WALL = Vector2i(25, 17)
@export var PATH = Vector2i(29, 17)

var maze = []
var generate_button : Button

func _ready() -> void:
	setup_ui()
	generate_maze()

func setup_ui():
	generate_button = Button.new()
	generate_button.text = "Generate Maze"
	generate_button.position = Vector2(10, ROWS * 32 + 10)
	generate_button.size = Vector2(150, 30)
	generate_button.connect("pressed", Callable(self, "_on_generate_maze_predded"))
	add_child(generate_button)
	

func _on_generate_maze_pressed():
	generate_maze()
func reset_maze():
	maze = []
	for r in range(ROWS):
		var row =[]
		for c in range(COLS):
			row.append(1)
		maze.append(row)

func generate_maze():
	reset_maze()
	
	var start_row = 1
	var start_col = 1 
	maze[start_row][start_col] = 0
	
	carve_message(start_row, start_col)
	draw_maze()

func carve_message(row, col):
	var direction = [
		[0, 2], #right
		[2, 0], #down
		[0, -2], #left
		[-2, 0] #up
	]
	
	direction.shuffle()
	
	for dir in direction:
		var dr = dir[0]
		var dc = dir[1]
		
		var new_row = row + dr
		var new_col = col + dc
		
		if (
			new_col > 0 and 
			new_col < COLS-1 and 
			new_row > 0 and 
			new_row < ROWS-1 and 
			maze[new_row][new_col] == 1
		):
			maze[new_row][new_col] = 0
			maze[row + dr/2][col + dc/2] = 0
			carve_message(new_row, new_col)

func draw_maze():
	tilemaplayer.clear()
	
	for r in range(ROWS):
		for c in range(COLS):
			var tile_type = WALL if maze[r][c] == 1 else PATH
			tilemaplayer.set_cell(Vector2i(c, r), 0, tile_type)

func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	generate_maze()
