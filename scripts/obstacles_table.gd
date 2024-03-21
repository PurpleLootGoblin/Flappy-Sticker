class_name ObstaclesTable

var obstacles: Array[Dictionary] = []
var weight_total = 0

func add_obstacle(obstacle, weight: float):
	obstacles.append({"obstacle": obstacle, "weight": weight})
	weight_total += weight
	
func pick_obstacle():
	var random_weight_chosen = randf_range(0.0, weight_total)
	var iteration_weight = 0
	for obstacle in obstacles:
		iteration_weight += obstacle["weight"]
		if iteration_weight >= random_weight_chosen:
			return obstacle["obstacle"]
		
