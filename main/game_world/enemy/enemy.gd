extends Area3D
class_name Enemy
# Base class for all bacteria and virus enemies

signal spawn_started

const DEATH_OFFSET: float = 0.01
const DEATH_RAISE_TIME: float = 0.1

@export var move_speed: float = 1.0
@export var health: int = 1:
	set(value):
		health = value
		if health <= 0:
			for i in range(len(spawn_scenes)):
				var new_spawn = spawn_scenes[i].instantiate()
				
				var new_path_follow: PathFollow3D = EnemySpawner.create_path_follow()
				path_follow.get_parent().add_child(new_path_follow)
				new_path_follow.add_child(new_spawn)
				
				# Evenly distribute spawn with slight randomness for large clumps
				new_path_follow.offset = path_follow.offset + (i * spawn_offset_max / len(spawn_scenes)) - (spawn_offset_max/2) + (spawn_offset_rand * randf())
				
				new_spawn.hit_by = hit_by
				new_spawn.health += health
			# If currently in pop animation, wait to delete
			if anim.is_active() and anim.current_animation == "pop":
				await anim.animation_finished
			path_follow.call_deferred("queue_free")
@export var spawn_scenes: Array[PackedScene]
@export var spawn_offset_max: float = 0.295
@export var spawn_offset_rand: float = 0.125

@onready var path_follow: PathFollow3D = get_parent()
@onready var anim: AnimationPlayer = get_node("AnimationPlayer")
@onready var mesh: MeshInstance3D = get_node("MeshInstance3D")

var hit_by: Attack

func _ready() -> void:
	connect("area_entered", projectile_entered)
	
	# Generate noise texture
	var noise = FastNoiseLite.new()
	noise.seed = randi()
	var noise_tex = NoiseTexture.new()
	noise_tex.width = 64 
	noise_tex.height = 64
	noise_tex.noise = noise
	mesh.material_override.set_shader_param("noise_tex", noise_tex)

func _process(delta) -> void:
	path_follow.offset += move_speed * delta
	# Apply small, almost invisible y offset for layering by progress on track
	position.y = path_follow.unit_offset / 32.0

func projectile_entered(area: Area3D) -> void:
	if not area is Attack or hit_by == area or area.pierce <= 0:
		return
	# Projectile could be deleted before pop animation is complete, so we must
	# store damage instead of accessing it from the instance
	var damage: int = area.damage
	
	area.pierce -= 1
	hit_by = area
	if health - damage <= 0:
		set_process(false)
		
		# Raise enemy above spawn while being destroyed
		# Cannot be included in animation due to variable y position
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(mesh, "position:y", position.y + DEATH_OFFSET, DEATH_RAISE_TIME)
		
		anim.current_animation = "pop"
		# Emitted mid-animation
		await spawn_started
	self.health -= damage
