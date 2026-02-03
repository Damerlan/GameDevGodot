extends Node

@export var texture: Texture2D
@export var alpha_threshold := 0.05
@export var min_size := 8
@export var line_tolerance := 18

var regions: Array = []
var grouped := {}

func _ready():
	map_texture()
	group_lines()
	print_result()



func map_texture():
	var img: Image = texture.get_image()

	var width: int = img.get_width()
	var height: int = img.get_height()

	var visited: Dictionary = {}

	for y in height:
		for x in width:

			var pos: Vector2i = Vector2i(x, y)

			if visited.has(pos):
				continue

			var color: Color = img.get_pixel(x, y)

			if color.a > alpha_threshold:
				var rect: Rect2 = flood_fill(img, x, y, visited)

				if rect.size.x > min_size and rect.size.y > min_size:
					regions.append(rect)

	print("Total sprites detectados:", regions.size())



func flood_fill(img: Image, start_x: int, start_y: int, visited: Dictionary) -> Rect2:

	var stack: Array[Vector2i] = [Vector2i(start_x, start_y)]

	var min_x: int = start_x
	var max_x: int = start_x
	var min_y: int = start_y
	var max_y: int = start_y

	while stack.size() > 0:
		var p: Vector2i = stack.pop_back()

		if visited.has(p):
			continue

		visited[p] = true

		if p.x < 0 or p.y < 0 or p.x >= img.get_width() or p.y >= img.get_height():
			continue

		if img.get_pixel(p.x, p.y).a <= alpha_threshold:
			continue

		min_x = min(min_x, p.x)
		max_x = max(max_x, p.x)
		min_y = min(min_y, p.y)
		max_y = max(max_y, p.y)

		stack.append(Vector2i(p.x + 1, p.y))
		stack.append(Vector2i(p.x - 1, p.y))
		stack.append(Vector2i(p.x, p.y + 1))
		stack.append(Vector2i(p.x, p.y - 1))

	return Rect2(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)


func group_lines():

	regions.sort_custom(func(a,b):
		if abs(a.position.y - b.position.y) < line_tolerance:
			return a.position.x < b.position.x
		return a.position.y < b.position.y
	)

	var line_index := 0
	var last_y := -9999

	for rect in regions:

		if abs(rect.position.y - last_y) > line_tolerance:
			line_index += 1
			last_y = rect.position.y
			grouped["line_" + str(line_index)] = []

		grouped["line_" + str(line_index)].append(rect)


func print_result():

	print("\n========= MAPA REAL DO ATLAS =========\n")

	for key in grouped.keys():

		print('"', key, '": [')

		for rect in grouped[key]:
			print("    Rect2(", rect.position.x, ", ", rect.position.y, ", ", rect.size.x, ", ", rect.size.y, "),")

		print("]\n")
