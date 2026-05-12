extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var hurt_component_collision_shape_2d: CollisionShape2D = $HurtComponent/HurtComponentCollisionShape2D
@onready var damage_component: DamageComponent = $DamageComponent
var randomNumberGen = RandomNumberGenerator.new()

var log_scene = preload("res://scenes/objects/trees/log.tscn")

func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)


func on_hurt(hit_damage: int) -> void:
	var shake_invensity = randomNumberGen.randf_range(6,7)
	print(damage_component)
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", shake_invensity)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	print("max damaged reached")
	call_deferred("add_log_scence")
	queue_free()

func add_log_scence() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position.y = global_position.y + 8
	log_instance.global_position.x = global_position.x
	
	get_parent().add_child(log_instance)
