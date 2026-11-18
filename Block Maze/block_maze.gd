extends Node2D

@onready var tilemaplayer = $TileMapLayer

@export var ROWS = 25
@export var COLS = 25
@export var WALL = Vector2i(0, 0)
@export var PATH = Vector2i(1, 0)

var maze = []
func _ready() -> void:
	reset_maze()
	generate_maze()

func reset_maze():
	maze = []
	for r in range(ROWS):
		var row =[]
		for c in range(COLS):
			row.append(1)
		maze.append(row)
	print(maze)

func generate_maze():
	reset_maze()
	
	
	var start_row = 1
	var start_col = 1 
	maze[start_col][start_row] = 0
	
	
	carve_message(start_col, start_row)
	draw_maze()

func carve_message(col, row):
	var direction = [
		[2, 0], #right
		[0, 2], #down
		[-2, 0], #left
		[0, -2] #up
	]
	
	
	direction.shuffle()
	
	
	for dir in direction:
		var dr = dir[1]
		var dc = dir[0]
		
		var new_row = row + dr
		var new_col = col + dc
		
		if (
			new_col > 0 and 
			new_col < COLS-1 and 
			new_row > 0 and 
			new_row < ROWS-1 and 
			maze[new_col][new_row] == 1
		):
			maze[new_row][new_col] = 0
			maze[row + dr/2][col + dc/2] = 0
			carve_message(new_row, new_col)
		

func draw_maze():
	tilemaplayer.clear()
	
	for r in range(ROWS):
		for c in range(COLS):
			var tile_type = WALL if maze[c][r] == 1 else PATH
			tilemaplayer.set_cell(Vector2i(c, r), 0, tile_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	generate_maze()




















func _on_button_pressed() -> void:
	pass # Replace with function body.
