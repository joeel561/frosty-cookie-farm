extends Control
class_name HotbarUI

@export var hotbar_data: HotbarData
@export var drag_controller: DragController
const SLOT_SCENE := preload("res://Resources/Slot.tscn")

func _ready():
	hotbar_data.update.connect(update_hotbar_ui)
	update_hotbar_ui()

func update_hotbar_ui() -> void:
	for c in %SlotGroup.get_children():
		c.queue_free()

	for i in range(hotbar_data.slots.size()):
		var s: Slot = SLOT_SCENE.instantiate()
		s.owner_kind = "hotbar"
		s.slot_index = i
		s.set_slot(hotbar_data.slots[i])
		
		s.drag_started.connect(drag_controller.start_drag)
		s.drag_released.connect(func(_slot): drag_controller.finish_drag(get_viewport().gui_get_hovered_control()))
		
		%SlotGroup.add_child(s)
