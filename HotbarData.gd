class_name HotbarData extends Resource

signal update

@export var size: int = 9
@export var slots: Array[SlotData] = []

func _init():
	while slots.size() < size:
		slots.append(SlotData.new())
			
func insertHotbar(item: ItemData) -> void:
	for slot in slots:
		if slot.item == item and slot.item != null:
			slot.amount += 1
			update.emit()
			return

	for slot in slots:
		if slot.item == null:
			slot.item = item
			slot.amount = 1
			update.emit()
			return

	print("Inventar ist voll")
