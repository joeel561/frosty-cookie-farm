extends Control

@export var inventory_data : InventoryData
@export var hotbar_data : HotbarData
var current_dragged_item_data : Dictionary
@export var drag_controller: DragController
var is_open  = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventar"):
		if is_open: 
			close()
		else: 
			open()

func _ready() -> void: 
	inventory_data.ensure_initialized()
	inventory_data.update.connect(update_inventory_data)

	close()
	update_inventory_data()
	connect_signals()

func close(): 
	visible = false
	is_open = false
	
func open(): 
	visible = true
	is_open = true
	
	
func connect_signals() -> void: 
	GlobalSignals.connect("UpdateInventory", update_inventory_data)
	
func update_inventory_data():
	for slot in %SlotGroup.get_children():
		slot.queue_free()

	var slot_scene := preload("res://Resources/Slot.tscn")

	for i in range(inventory_data.slots.size()):
		var new_slot: Slot = slot_scene.instantiate()
		new_slot.owner_kind = "inventory"
		new_slot.slot_index = i 
		
		new_slot.set_slot(inventory_data.slots[i])
		new_slot.drag_started.connect(drag_controller.start_drag)
		new_slot.drag_released.connect(func(_slot): drag_controller.finish_drag(get_viewport().gui_get_hovered_control()))
		
		%SlotGroup.add_child(new_slot)
		
