extends Resource
class_name Stat

signal depleted

export(float) var maximum = INF setget set_maxumum
export(float) var value = 0.0 setget set_value


func set_value(val):
	value = clamp(val, 0, maximum)
	if value == 0:
		emit_signal("depleted")

func set_maxumum(val):
	maximum = val
	self.value = value