class_name Ticker

# One-shot, self-destructs
static func once(target: Node, time: float):
	var timer = TickerTimer.new()
	timer.one_shot = true
	timer.connect("timeout", timer, "queue_free")
	target.add_child(timer)
	timer.start(time)
	return timer

# One-shot, reusable
static func trigger(target: Node, time: float = -1):
	var timer = TickerTimer.new()
	timer.one_shot = true
	target.add_child(timer)
	timer.wait_time = time
	return timer

# Loops, reusable
static func loop(target: Node, time: float = -1):
	var timer = TickerTimer.new()
	target.add_child(timer)
	timer.wait_time = time
	return timer


class TickerTimer:
	extends Timer

	func then(target: Object, method_name: String, binds: Array = [], flags: int = 0):
		connect("timeout", target, method_name, binds, flags)
		return self

	func start(time_sec: float = -1):
		.start(time_sec)
		return self
