extends TileMap

var nav = AStar2D.new()
var goals = []

func populateAstarGrid():
	var layer = -1
	nav = AStarGrid2D.new()
	nav.region = get_used_rect()
	nav.cell_size = tile_set.tile_size
	nav.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	nav.update() # Initialize the grid

	# Loop through all tiles to set solid regions
	for cell in get_used_cells(layer):
		var tile_data = get_cell_tile_data(layer,cell)
		if tile_data and tile_data.get_collision_polygons_count(0) > 0:
			nav.set_point_solid(cell)
		if tile_data.get_custom_data("isGoal"):
			goals.append(cell)	
			
func disableRed():
	var layer = -1
	for cell in get_used_cells(layer):
		var tile_data = get_cell_tile_data(layer,cell)
		if tile_data.get_custom_data("is_RedDoor"):
			set_cell(layer, cell, 11, Vector2i(2,0))
		elif (get_cell_source_id(layer,cell) == 11 and get_cell_atlas_coords(layer,cell) == Vector2i(2,0)):
			set_cell(layer, cell, 11, Vector2i(3,0))
	
	
func _ready() -> void:
	populateAstarGrid()
	
