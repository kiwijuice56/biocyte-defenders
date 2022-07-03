extends Node3D
class_name EnemySpawner

var path: Path3D
var enemy_spawn_timer: Timer

var count: int
var delay: float
var enemy_scene: PackedScene

func _ready() -> void:
	enemy_spawn_timer = Timer.new()
	add_child(enemy_spawn_timer)
	enemy_spawn_timer.one_shot = true
	enemy_spawn_timer.connect("timeout", spawn_enemy)

func initialize(group: EnemyGroup, _path: Path3D) -> void:
	count = group.count
	delay = group.delay
	enemy_scene = group.enemy_scene
	path = _path
	
	enemy_spawn_timer.start(delay)

func spawn_enemy() -> void:
	var path_follow: PathFollow3D = PathFollow3D.new()
	path_follow.cubic_interp = false
	path_follow.rotation_mode = PathFollow3D.ROTATION_NONE
	var new_enemy = enemy_scene.instantiate()
	path_follow.add_child(new_enemy)
	path.add_child(path_follow)
	
	count -= 1
	if count > 0:
		enemy_spawn_timer.start(delay)
	else:
		queue_free()
