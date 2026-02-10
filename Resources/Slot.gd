class_name Slot extends Panel

signal drag_started(slot: Slot)
signal drag_released(slot: Slot)

var slot_data: SlotData = null
var slot_index: int = -1
var owner_kind: String = "inventory"

func set_slot(data: SlotData) -> void:
	slot_data = data
	update_ui()

func clear_slot() -> void:
	slot_data = null
	update_ui()

func update_ui() -> void:
	if slot_data == null or slot_data.item == null or slot_data.amount <= 0:
		%ItemAmount.visible = false
		return
		
	%ItemTexture.texture = slot_data.item.item_texture

	if slot_data.amount > 1:
		%ItemAmount.visible = true
		%ItemAmount.text = str(slot_data.amount)
	else:
		%ItemAmount.visible = false

func set_dragging(is_dragging: bool) -> void: 
	if %ItemTexture == null:
		return

	if is_dragging:
		%ItemTexture.modulate = Color(1, 1, 1, 0.4)
	else:
		%ItemTexture.modulate = Color(1, 1, 1, 1)  

func set_selected(is_selected: bool) -> void: 
	if %ItemTexture == null:
		return
		
	if is_selected: 
		%ItemTexture.modulate = Color(1, 1, 1, 1) 
	else: 
		%ItemTexture.modulate = Color(1, 1, 1, 0.4)
		
func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_left"):
		emit_signal("drag_started", self)
	elif event.is_action_released("mouse_left"):
		emit_signal("drag_released", self)
