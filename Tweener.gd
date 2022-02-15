extends Node
class_name gdTweener, 'res://gdTweener/Tweener.png'

# Helper functions #########################################
func __clamper(t: float, calculated_output: float) -> float:
	if 0.0 < t and t < 1.0:
		return calculated_output
	return clamp(t, 0.0, 1.0)

func __inverse(t: float, funcname: String) -> float:
	return 1.0 - call(funcname, 1.0-t)

func __inout(t: float, in_func_name: String, out_func_name: String) -> float:
	t *= 2
	return (call(in_func_name, t) + call(out_func_name, t-1)) / 2

# Ease in ##################################################

func inSine(t: float) -> float:
	return __clamper(t, 1-cos((t * PI) / 2))

func inQuad(t: float) -> float:
	return __clamper(t, pow(t, 2))

func inCubic(t: float) -> float:
	return __clamper(t, pow(t, 3))

func inQuart(t: float) -> float:
	return __clamper(t, pow(t, 4))

func inQuint(t: float) -> float:
	return __clamper(t, pow(t, 5))

func inExpo(t: float) -> float:
	return __clamper(t, pow(2, (10*t-10)))

func inCirc(t: float) -> float:
	return __clamper( t, 1.0 - sqrt(1-pow(t, 2)))

func inBack(t: float) -> float:
	var c1 = 1.70158
	var c3 = c1 + 1
	return __clamper(t, c3 * pow(t, 3) - c1 * pow(t, 2))

func inElastic(t: float) -> float:
	var c4 = 2.0*PI/3.0
	return __clamper(t, -pow(2, 10*t-10) * sin((t*10-10.75) * c4))

func inBounce(t: float) -> float:
	return __inverse(t, 'outBounce')

# Ease out ######################################################

func outSine(t: float) -> float:
	return __inverse(t, 'inSine')

func outQuad(t: float) -> float:
	return __inverse(t, 'inQuad')

func outCubic(t: float) -> float:
	return __inverse(t, 'inCubic')

func outQuart(t: float) -> float:
	return __inverse(t, 'inQuart')

func outQuint(t: float) -> float:
	return __inverse(t, 'inQuint')

func outExpo(t: float) -> float:
	return __inverse(t, 'inExpo')

func outCirc(t: float) -> float:
	return __inverse(t, 'inCirc')

func outBack(t: float) -> float:
	return __inverse(t, 'inBack')

func outElastic(t: float) -> float:
	return __inverse(t, 'inElastic')

func outBounce(t: float) -> float:
	var n1 = 7.5625
	var d1 = 2.75
	
	if t >= 1.0 or t <= 0.0: return clamp(t, 0, 1)
	
	if t<1/d1:
		return n1*pow(t,2)
	elif t<2/d1:
		t -= 1.5 / d1
		return n1 * pow(t,2) + 0.75
	elif t<2.5/d1:
		t -= 2.25 / d1
		return n1 * pow(t,2) + 0.9375
	else:
		t -= 2.625 / d1
		return n1 * pow(t,2) + 0.984375

# Ease in and out ################################################

func inOutSine(t: float) -> float:
	return __inout(t, 'inSine', 'outSine')

func inOutQuad(t: float) -> float:
	return __inout(t, 'inQuad', 'outQuad')

func inOutCubic(t: float) -> float:
	return __inout(t, 'inCubic', 'outCubic')

func inOutQuart(t: float) -> float:
	return __inout(t, 'inQuart', 'outQuart')

func inOutQuint(t: float) -> float:
	return __inout(t, 'inQuint', 'outQuint')

func inOutExpo(t: float) -> float:
	return __inout(t, 'inExpo', 'outExpo')

func inOutCirc(t: float) -> float:
	return __inout(t, 'inCirc', 'outCirc')

func inOutBack(t: float) -> float:
	return __inout(t, 'inBack', 'outBack')

func inOutElastic(t: float) -> float:
	return __inout(t, 'inElastic', 'outElastic')

func inOutBounce(t: float) -> float:
	return __inout(t, 'inBounce', 'outBounce')

# Mixed easing ######################################

func inSineOutQuad(t: float) -> float:
	return __inout(t, 'inSine', 'outQuad')

func inSineOutCubic(t: float) -> float:
	return __inout(t, 'inSine', 'outCubic')

func inSineOutQuart(t: float) -> float:
	return __inout(t, 'inSine', 'outQuart')

func inSineOutQuint(t: float) -> float:
	return __inout(t, 'inSine', 'outQuint')

func inSineOutExpo(t: float) -> float:
	return __inout(t, 'inSine', 'outExpo')

func inSineOutCirc(t: float) -> float:
	return __inout(t, 'inSine', 'outCirc')

func inSineOutBack(t: float) -> float:
	return __inout(t, 'inSine', 'outBack')

func inSineOutElastic(t: float) -> float:
	return __inout(t, 'inSine', 'outElastic')

func inSineOutBounce(t: float) -> float:
	return __inout(t, 'inSine', 'outBounce')

func inQuadOutSine(t: float) -> float:
	return __inout(t, 'inQuad', 'outSine')

func inQuadOutCubic(t: float) -> float:
	return __inout(t, 'inQuad', 'outCubic')

func inQuadOutQuart(t: float) -> float:
	return __inout(t, 'inQuad', 'outQuart')

func inQuadOutQuint(t: float) -> float:
	return __inout(t, 'inQuad', 'outQuint')

func inQuadOutExpo(t: float) -> float:
	return __inout(t, 'inQuad', 'outExpo')

func inQuadOutCirc(t: float) -> float:
	return __inout(t, 'inQuad', 'outCirc')

func inQuadOutBack(t: float) -> float:
	return __inout(t, 'inQuad', 'outBack')

func inQuadOutElastic(t: float) -> float:
	return __inout(t, 'inQuad', 'outElastic')

func inQuadOutBounce(t: float) -> float:
	return __inout(t, 'inQuad', 'outBounce')

func inCubicOutSine(t: float) -> float:
	return __inout(t, 'inCubic', 'outSine')

func inCubicOutQuad(t: float) -> float:
	return __inout(t, 'inCubic', 'outQuad')

func inCubicOutQuart(t: float) -> float:
	return __inout(t, 'inCubic', 'outQuart')

func inCubicOutQuint(t: float) -> float:
	return __inout(t, 'inCubic', 'outQuint')

func inCubicOutExpo(t: float) -> float:
	return __inout(t, 'inCubic', 'outExpo')

func inCubicOutCirc(t: float) -> float:
	return __inout(t, 'inCubic', 'outCirc')

func inCubicOutBack(t: float) -> float:
	return __inout(t, 'inCubic', 'outBack')

func inCubicOutElastic(t: float) -> float:
	return __inout(t, 'inCubic', 'outElastic')

func inCubicOutBounce(t: float) -> float:
	return __inout(t, 'inCubic', 'outBounce')

func inQuartOutSine(t: float) -> float:
	return __inout(t, 'inQuart', 'outSine')

func inQuartOutQuad(t: float) -> float:
	return __inout(t, 'inQuart', 'outQuad')

func inQuartOutCubic(t: float) -> float:
	return __inout(t, 'inQuart', 'outCubic')

func inQuartOutQuint(t: float) -> float:
	return __inout(t, 'inQuart', 'outQuint')

func inQuartOutExpo(t: float) -> float:
	return __inout(t, 'inQuart', 'outExpo')

func inQuartOutCirc(t: float) -> float:
	return __inout(t, 'inQuart', 'outCirc')

func inQuartOutBack(t: float) -> float:
	return __inout(t, 'inQuart', 'outBack')

func inQuartOutElastic(t: float) -> float:
	return __inout(t, 'inQuart', 'outElastic')

func inQuartOutBounce(t: float) -> float:
	return __inout(t, 'inQuart', 'outBounce')

func inQuintOutSine(t: float) -> float:
	return __inout(t, 'inQuint', 'outSine')

func inQuintOutQuad(t: float) -> float:
	return __inout(t, 'inQuint', 'outQuad')

func inQuintOutCubic(t: float) -> float:
	return __inout(t, 'inQuint', 'outCubic')

func inQuintOutQuart(t: float) -> float:
	return __inout(t, 'inQuint', 'outQuart')

func inQuintOutExpo(t: float) -> float:
	return __inout(t, 'inQuint', 'outExpo')

func inQuintOutCirc(t: float) -> float:
	return __inout(t, 'inQuint', 'outCirc')

func inQuintOutBack(t: float) -> float:
	return __inout(t, 'inQuint', 'outBack')

func inQuintOutElastic(t: float) -> float:
	return __inout(t, 'inQuint', 'outElastic')

func inQuintOutBounce(t: float) -> float:
	return __inout(t, 'inQuint', 'outBounce')

func inExpoOutSine(t: float) -> float:
	return __inout(t, 'inExpo', 'outSine')

func inExpoOutQuad(t: float) -> float:
	return __inout(t, 'inExpo', 'outQuad')

func inExpoOutCubic(t: float) -> float:
	return __inout(t, 'inExpo', 'outCubic')

func inExpoOutQuart(t: float) -> float:
	return __inout(t, 'inExpo', 'outQuart')

func inExpoOutQuint(t: float) -> float:
	return __inout(t, 'inExpo', 'outQuint')

func inExpoOutCirc(t: float) -> float:
	return __inout(t, 'inExpo', 'outCirc')

func inExpoOutBack(t: float) -> float:
	return __inout(t, 'inExpo', 'outBack')

func inExpoOutElastic(t: float) -> float:
	return __inout(t, 'inExpo', 'outElastic')

func inExpoOutBounce(t: float) -> float:
	return __inout(t, 'inExpo', 'outBounce')

func inCircOutSine(t: float) -> float:
	return __inout(t, 'inCirc', 'outSine')

func inCircOutQuad(t: float) -> float:
	return __inout(t, 'inCirc', 'outQuad')

func inCircOutCubic(t: float) -> float:
	return __inout(t, 'inCirc', 'outCubic')

func inCircOutQuart(t: float) -> float:
	return __inout(t, 'inCirc', 'outQuart')

func inCircOutQuint(t: float) -> float:
	return __inout(t, 'inCirc', 'outQuint')

func inCircOutExpo(t: float) -> float:
	return __inout(t, 'inCirc', 'outExpo')

func inCircOutBack(t: float) -> float:
	return __inout(t, 'inCirc', 'outBack')

func inCircOutElastic(t: float) -> float:
	return __inout(t, 'inCirc', 'outElastic')

func inCircOutBounce(t: float) -> float:
	return __inout(t, 'inCirc', 'outBounce')

func inBackOutSine(t: float) -> float:
	return __inout(t, 'inBack', 'outSine')

func inBackOutQuad(t: float) -> float:
	return __inout(t, 'inBack', 'outQuad')

func inBackOutCubic(t: float) -> float:
	return __inout(t, 'inBack', 'outCubic')

func inBackOutQuart(t: float) -> float:
	return __inout(t, 'inBack', 'outQuart')

func inBackOutQuint(t: float) -> float:
	return __inout(t, 'inBack', 'outQuint')

func inBackOutExpo(t: float) -> float:
	return __inout(t, 'inBack', 'outExpo')

func inBackOutCirc(t: float) -> float:
	return __inout(t, 'inBack', 'outCirc')

func inBackOutElastic(t: float) -> float:
	return __inout(t, 'inBack', 'outElastic')

func inBackOutBounce(t: float) -> float:
	return __inout(t, 'inBack', 'outBounce')

func inElasticOutSine(t: float) -> float:
	return __inout(t, 'inElastic', 'outSine')

func inElasticOutQuad(t: float) -> float:
	return __inout(t, 'inElastic', 'outQuad')

func inElasticOutCubic(t: float) -> float:
	return __inout(t, 'inElastic', 'outCubic')

func inElasticOutQuart(t: float) -> float:
	return __inout(t, 'inElastic', 'outQuart')

func inElasticOutQuint(t: float) -> float:
	return __inout(t, 'inElastic', 'outQuint')

func inElasticOutExpo(t: float) -> float:
	return __inout(t, 'inElastic', 'outExpo')

func inElasticOutCirc(t: float) -> float:
	return __inout(t, 'inElastic', 'outCirc')

func inElasticOutBack(t: float) -> float:
	return __inout(t, 'inElastic', 'outBack')

func inElasticOutBounce(t: float) -> float:
	return __inout(t, 'inElastic', 'outBounce')

func inBounceOutSine(t: float) -> float:
	return __inout(t, 'inBounce', 'outSine')

func inBounceOutQuad(t: float) -> float:
	return __inout(t, 'inBounce', 'outQuad')

func inBounceOutCubic(t: float) -> float:
	return __inout(t, 'inBounce', 'outCubic')

func inBounceOutQuart(t: float) -> float:
	return __inout(t, 'inBounce', 'outQuart')

func inBounceOutQuint(t: float) -> float:
	return __inout(t, 'inBounce', 'outQuint')

func inBounceOutExpo(t: float) -> float:
	return __inout(t, 'inBounce', 'outExpo')

func inBounceOutCirc(t: float) -> float:
	return __inout(t, 'inBounce', 'outCirc')

func inBounceOutBack(t: float) -> float:
	return __inout(t, 'inBounce', 'outBack')

func inBounceOutElastic(t: float) -> float:
	return __inout(t, 'inBounce', 'outElastic')

## list of all active cTweens
var active_gdTweens := []

## Object that keeps track of object values and changes them according to time passed.
class gdTween:
	var object: WeakRef
	var curr_time := 0.0
	var target_time: float
	var end_values: Dictionary
	var start_values: Dictionary
	var lib: gdTweener
	var ease_type := 'outQuad'
	var delete := false
	var _delay := 0.0
	
	var on_start_funcRefs := []
	var on_update_funcRefs := []
	var on_complete_funcRefs := []
	
	func _init(obj: Object, seconds: float, key_values: Dictionary, library: gdTweener):
		self.object = weakref(obj)
		self.target_time = seconds
		self.end_values = key_values
		self.lib = library
	
	## Mark this cTween for deletion, and remove all references to other objects
	func stop() -> void:
		self.delete = true
		self.lib = null
		self.object = null
		self.on_start_funcRefs.clear()
		self.on_update_funcRefs.clear()
		self.on_complete_funcRefs.clear()
	
	## Add a function reference that will be called when this tween starts.
	## The function will be called with no arguments.
	## Returns self.
	func onStart(function: FuncRef) -> gdTween:
		self.on_start_funcRefs.append(function)
		return self
	
	## Add a function reference that will be called once per update.
	## The function will be called with the 'dt' argument.
	## Returns self.
	func onUpdate(function: FuncRef) -> gdTween:
		self.on_update_funcRefs.append(function)
		return self
	
	## Add a function reference that will be called on completion.
	## No functions will be called if this twen is stopped.
	## The function will be called with no arguments.
	## Returns self.
	func onComplete(function: FuncRef) -> gdTween:
		self.on_complete_funcRefs.append(function)
		return self
	
	func queueFreeOnComplete() -> gdTween:
		self.on_complete_funcRefs.append(funcref(self.object.get_ref(), 'queue_free'))
		return self
	
	## Set the easing function used for this tween.
	## The default is 'outQuad'
	## Returns self.
	func ease(ease_function_name: String) -> gdTween:
		self.ease_type = ease_function_name
		return self
	
	## Add a delay on this tween before it should start.
	## Returns self.
	func delay(seconds: float) -> gdTween:
		self._delay += seconds
		return self
	
	## Start another tween with the same delay as this one.
	## Returns new tween.
	func at(obj: Object, seconds: float, key_values: Dictionary) -> gdTween:
		return self.lib.to(obj, seconds, key_values).delay(self._delay)
	
	## Start another tween with delay equal to this tweens delay + this tweens duration
	## Returns new tween.
	func after(obj: Object, seconds: float, key_values: Dictionary) -> gdTween:
		return self.lib.to(obj, seconds, key_values).delay(self._delay + self.target_time)
	
	## Call all FuncRefs in given array.
	## This will be called automatically by Tweener.
	func callFuncRefList(FuncRefs: Array) -> void:
		if !self.object.get_ref(): return
		for f in FuncRefs:
			f.call_func()
	
	## Call all FuncRefs update function array.
	## This will be called automatically by Tweener.
	func callOnUpdateFuncRefs(dt: float) -> void:
		if !self.object.get_ref(): return
		for f in self.on_update_funcRefs:
			f.call_func(dt)
	
	## Set tween start values to the current values corresponding to all the given keys.
	## This will be called automatically by Tweener.
	func setStartValues() -> void:
		for key in self.end_values.keys():
			start_values[key] = self.object.get_ref().get(key)
	
	## Update object values based on given completion factor.
	## This will be called automatically by Tweener.
	func updateValues(completion_factor: float) -> void:
		if !self.object.get_ref(): return
		
		for key in end_values.keys():
			var start_end_diff = end_values[key] - start_values[key]
			self.object.get_ref().set(key, start_values[key] + start_end_diff * completion_factor)
	
	## Checks all active tweens and deletes them if there are any 
	## This will be called automatically by Tweener.
	func deleteClashingTweens() -> void:
		for tween in self.lib.active_gdTweens:
			if tween == self or tween.object != self.object or tween.first_time_tween_runs:
				continue
			for key in tween.end_values.keys():
				if self.end_values.has(key):
					tween.stop()
					break
	
	var first_time_tween_runs := true
	
	## update the tween.
	## This will be called automatically by Tweener.
	func update(dt: float) -> void:
		if !self.object.get_ref(): 
			self.stop()
			return
		
		if self._delay > 0:
			self._delay -= dt
			return
		
		if self.first_time_tween_runs:
			dt -= self._delay
			self.setStartValues()
			self.deleteClashingTweens()
			self.callFuncRefList(on_start_funcRefs)
			self.first_time_tween_runs = false
		
		self.callOnUpdateFuncRefs(dt)
		
		self.curr_time += dt
		
		var completion_factor = self.lib.call(self.ease_type, self.curr_time / self.target_time)
		self.updateValues(completion_factor)
		
		if self.curr_time >= self.target_time:
			self.callFuncRefList(on_complete_funcRefs)
			self.stop()

## Dummy gdTween object to make using the gdTweener module easier in for loops
class gdTweenDummy:
	var duration: float
	var delay: float
	var lib: gdTweener;
	
	func _init(fake_duration: float, fake_delay: float, library: gdTweener):
		self.duration = fake_duration
		self.delay = fake_delay
		self.lib = library
	
	## Start another tween with the same delay as this fake one.
	## Returns new tween.
	func at(obj: Object, seconds: float, key_values: Dictionary) -> gdTween:
		return self.lib.to(obj, seconds, key_values).delay(self.delay)
	
	## Start another tween with delay equal to this fake tweens delay + this tweens duration
	## Returns new tween.
	func after(obj: Object, seconds: float, key_values: Dictionary) -> gdTween:
		return self.lib.to(obj, seconds, key_values).delay(self.delay + self.duration)

## Start and return a tween.
## Obj is the object wich contains the values you want to tween.
## Seconds is how long the tween should take.
## Key_values is a dictionary of string-float pairs that decide what the final values
## of the object will be when the tween is complete.
func to(obj: Object, seconds: float, key_values: Dictionary) -> gdTween:
	var tween = gdTween.new(obj, seconds, key_values, self)
	self.active_gdTweens.append(tween)
	return tween

## Create a dummy tween object.
## Has methods: at, and after.
## Exists to make using gdTweens easier in for-loops.
func dummy(fake_duration: float, fake_delay: float):
	return gdTweenDummy.new(fake_duration, fake_delay, self)

func _process(delta):
	for tween in active_gdTweens:
		tween.update(delta)
	
	# deletion algorithm
	var del_count = 0
	for i in range(active_gdTweens.size()):
		var tween = active_gdTweens[i]
		if tween.delete:
			del_count += 1
		else:
			active_gdTweens[i-del_count] = tween
	for _i in range(del_count):
		active_gdTweens.pop_back()
