extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var hurt_component_collision_shape_2d: CollisionShape2D = $HurtComponent/HurtComponentCollisionShape2D
@onready var damage_component: DamageComponent = $DamageComponent
var randomNumberGen = RandomNumberGenerator.new()

var stone_scene = preload("res://scenes/objects/stones/stone.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)


func on_hurt(hit_damage: int) -> void:
	var shake_invensity = randomNumberGen.randf_range(0.8,1.2)
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", shake_invensity)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0.0)
	
func on_max_damage_reached() -> void:
	call_deferred("add_log_scence")
	queue_free()

func add_log_scence() -> void:
	var stone_scene = stone_scene.instantiate() as Node2D
	stone_scene.global_position.y = global_position.y
	stone_scene.global_position.x = global_position.x
	
	get_parent().add_child(stone_scene)
