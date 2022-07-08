extends Node3D
class_name GroupSpawner
# Transition gameplay by advancing rounds and spawning EnemySpawner nodes
# Custom rounds can be configured by creating text files in the
# `round_folder_path/{mode}/{round #}.txt` directory
# Each line of the text file must have lines(s) following the format
# `{spawn_time}: x{count}, {delay_per_enemy}, {enemy_type}`

@export var round_folder_path: String
@export var name_enemy_path_map: Dictionary

@onready var group_spawn_timer: Timer = $GroupSpawnTimer
@onready var world: GameWorld = get_parent()

var round_index: int = 0
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
		
	start_game()

# Advance through rounds
func start_game() -> void:
	round_index = 0
	while round_index < len(medium_rounds):
		await spawn_round_groups(medium_rounds[round_index])
		round_index += 1

# Spawn all of the EnemySpanwer nodes specified in a round's enemy_groups property
func spawn_round_groups(round: Round) -> void:
	var timer: Timer = Timer.new()
	timer.one_shot = true
	add_child(timer)
	
	var group_index: int = 0
	while group_index < len(round.enemy_groups):
		timer.start(round.spawn_times[group_index])
		await timer.timeout
		
		var new_spawner: EnemySpawner = EnemySpawner.new()
		add_child(new_spawner)
		
		new_spawner.initialize(round.enemy_groups[group_index], world.current_map.path)
		group_index += 1
	timer.queue_free()

# Create Round and EemyGroup resoures from text files
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
	file.close()
	return new_round
