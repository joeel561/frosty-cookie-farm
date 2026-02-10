class_name DragController extends Control

const SLOT_SCENE := preload("res://Resources/Slot.tscn")

@export var inventory_data: InventoryData
@export var hotbar_data: HotbarData

var current_drag := {}

func get_slot(kind: String, index: int) -> SlotData:
	if kind == "inventory":
		return inventory_data.slots[index]
		
	if kind == "hotbar":
		return hotbar_data.slots[index]
	
	return null
	
func start_drag(from_slot: Slot) -> void: 
	var from_kind := from_slot.owner_kind
	var from_index := from_slot.slot_index
	
	print(from_index, "from index")
	var slot := get_slot(from_kind, from_index)
	
	if slot == null or slot.item == null or slot.amount <= 0:
		return 
		
	current_drag = {"from_kind": from_kind, "from_index": from_index}
	
	from_slot.set_dragging(true)
	create_drag_item(slot)

func finish_drag(hovered_control: Control) -> void:
	if current_drag.is_empty():
		return
		
	var from_kind : String = current_drag["from_kind"]
	var from_index: int = current_drag["from_index"]
	
	_reset_source_visual(from_kind, from_index)
	
	delete_drag_icon()
	
	if not (hovered_control is Slot): 
		current_drag.clear()
		inventory_data.update.emit()
		hotbar_data.update.emit()
		return
		
	var to_slot: Slot = hovered_control
	var to_kind := to_slot.owner_kind
	var to_index := to_slot.slot_index
	
	if to_kind == from_kind and to_index == from_index:
		current_drag.clear()
		inventory_data.update.emit()
		hovered_control.update.emit()
		return
		
	var source_slot := get_slot(from_kind, from_index)
	var target_slot := get_slot(to_kind, to_index)
	
	if source_slot == null or source_slot.item == null or source_slot.amount <= 0:
		current_drag.clear()
		inventory_data.update.emit()
		hotbar_data.update.emit()
		return 
		
	if target_slot.item == null:
		# move
		target_slot.item = source_slot.item
		target_slot.amount = source_slot.amount
		source_slot.item = null
		source_slot.amount = 0
	else:
		# swap
		var tmp_item = target_slot.item
		var tmp_amount = target_slot.amount
		target_slot.item = source_slot.item
		target_slot.amount = source_slot.amount
		source_slot.item = tmp_item
		source_slot.amount = tmp_amount
		
	current_drag.clear()
	GlobalSignals.UpdateInventory.emit()
	hotbar_data.update.emit()
	inventory_data.update.emit()
			
func create_drag_item(slot_data: SlotData) -> void: 
	var drag_root := Control.new()
	drag_root.name = "ItemDrag"
	drag_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(drag_root)
	
	var icon := TextureRect.new()
	icon.texture = slot_data.item.item_texture
	drag_root.add_child(icon)
	
	if slot_data.amount > 1:
		var label := Label.new()
		label.text = str(slot_data.amount)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.anchor_right = 1
		label.anchor_bottom = 1
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
		label.offset_right = -4
		label.offset_bottom = -2
		label.add_theme_constant_override("outline_size", 2)
		label.add_theme_color_override("font_outline_color", Color.BLACK)
		drag_root.add_child(label)
	

func _process(delta: float) -> void:
	if has_node("ItemDrag"):
		$ItemDrag.global_position = get_global_mouse_position() - $ItemDrag.size / 2

func delete_drag_icon() -> void: 
	if has_node("ItemDrag"):
		$ItemDrag.queue_free()

func _reset_source_visual(kind: String, index: int) -> void: 
	pass			
