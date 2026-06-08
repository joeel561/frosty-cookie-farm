class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@onready var animated_sprite = $AnimatedSprite2D
@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

@export var inv: InventoryData
@export var hotbar: HotbarData
var player_direction: Vector2


func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	
func collect(item) -> void:
	if not hotbar.insertHotbar(item): 
		inv.insert(item)
 
func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
