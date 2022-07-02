extends Node3D
class_name EnemySpawner

@export var round_folder_path: String
@export var name_enemy_path_map: Dictionary

var name_enemy_map: Dictionary
var medium_rounds: Array[Round]

func _ready() -> void:
	for name in name_enemy_path_map:
		name_enemy_map[name] = load(name_enemy_path_map[name])
	
	var medium_dir = Directory.new()
	if medium_dir.open(round_folder_path + "/medium") == OK:
		medium_dir.list_dir_begin()
		var file_name = medium_dir.get_next()
		while file_name != "":
			if not medium_dir.current_is_dir():
				medium_rounds.append(parse_round(medium_dir.get_current_dir() + "/" + file_name))
			file_name = medium_dir.get_next()

# {spawn_time}: x{count}, {delay_per_enemy}, {enemy_type}
func parse_round(text_path: String) -> Round:
	var file = File.new()
	file.open(text_path, File.READ)
	var new_round: Round = Round.new()
	while not file.eof_reached():
		var line: String = file.get_line()
		if line.is_empty():
			continue
		new_round.spawn_times.append(line.substr(0, line.find(":")).to_float())
		
		var new_group: EnemyGroup = EnemyGroup.new()
		new_round.enemy_groups.append(new_group)
		
		var param: PackedStringArray = line.substr(line.find(": ")).split(", ")
		new_group.count = param[0].substr(1).to_int()
		new_group.delay = param[1].to_float()
		new_group.enemy_scene = name_enemy_map[param[2]]
	return new_round
