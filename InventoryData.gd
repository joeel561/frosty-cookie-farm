class_name InventoryData extends Resource

signal update

@export var slots: Array[SlotData] = []
@export var size: int = 15

func ensure_initialized() -> void:
	while slots.size() < size: 
		slots.append(SlotData.new())
		
	for i in range(slots.size()):
		if slots[i] == null:
			slots[i] = SlotData.new()

func insert(item: ItemData) -> void:
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
	update.emit()
