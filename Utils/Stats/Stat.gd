extends Resource
class_name Stat

export(float) var value = 0.0 setget set_value
export(float) var maximum = 0.0 setget set_maxumum


func set_value(val):
	value = clamp(val, 0, maximum)

func set_maxumum(val):
	maximum = val
	self.value = value