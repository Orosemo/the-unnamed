extends InvSpace

func update():
    for slot in inv_slots:
        if slot.slot.amount == 0:
            slot.queue_free()
    