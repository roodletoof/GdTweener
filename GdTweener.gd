extends Node
class_name GdTweener, 'res://GdTweener/Tweener.png'

# Info about this Node and the easing functions used:
	# To create a new easing type, add a method to this script following the same format as the easing methods below.
	# The parameter takes a float that should be clamped between 0.0 and 1.0.
	# If any number below 0.0 or above 1.0 should be passed to the method as an argument, the return should be 0.0 or 1.0 depending.
	# The gap between 0.0 and 1.0 is where the easing happens.
	# You use an easing function by calling GdTween.ease("insert_easing_function_name_here")


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

func linear(t: float) -> float:
	return clamp(t, 0.0, 1.0)

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

## list of all active cTweens
const active_GdTweens := []

## Object that keeps track of __object values and changes them according to time passed.
class GdTween:
	var __object: WeakRef
	var __curr_time := 0.0
	var __target_time: float
	var __end_values: Dictionary
	var __start_values: Dictionary
	var __lib: gdTweener
	var __ease_type := 'outQuad'
	var __delete := false
	var __delay := 0.0
	
	var __on_start_funcRefs := []
	var __on_update_funcRefs := []
	var __on_complete_funcRefs := []
	
	func _init(obj: Object, seconds: float, key_values: Dictionary, library: gdTweener):
		self.__object = weakref(obj)
		self.__target_time = seconds
		self.__end_values = key_values
		self.__lib = library
	
	## Mark this cTween for deletion, and remove all references to other objects
	func stop() -> void:
		self.__delete = true
		self.__lib = null
		self.__object = null
		self.__on_start_funcRefs.clear()
		self.__on_update_funcRefs.clear()
		self.__on_complete_funcRefs.clear()
	
	## Add a function reference that will be called when this tween starts.
	## The function will be called with no arguments.
	## Returns self.
	func onStart(function: FuncRef) -> GdTween:
		self.__on_start_funcRefs.append(function)
		return self
	
	## Add a function reference that will be called once per __update.
	## The function will be called with the 'dt' argument.
	## Returns self.
	func onUpdate(function: FuncRef) -> GdTween:
		self.__on_update_funcRefs.append(function)
		return self
	
	## Add a function reference that will be called on completion.
	## No functions will be called if this twen is stopped.
	## The function will be called with no arguments.
	## Returns self.
	func onComplete(function: FuncRef) -> GdTween:
		self.__on_complete_funcRefs.append(function)
		return self
	
	## Call queue_free on the __object this gdTween is tweening when this tween is complete.
	func queueFreeOnComplete() -> GdTween:
		self.__on_complete_funcRefs.append(funcref(self.__object.get_ref(), 'queue_free'))
		return self
	
	## Set the easing function used for this tween.
	## The default is 'outQuad'
	## Returns self.
	func ease(ease_function_name: String) -> GdTween:
		self.__ease_type = ease_function_name
		return self
	
	## Add a delay on this tween before it should start.
	## The given delay can be negative.
	## This allows a tween started by GdTween.after() to start at some time before this GdTween ends.
	## Returns self.
	func delay(seconds: float) -> GdTween:
		self.__delay += seconds
		return self
	
	## Manually set start values.
	## Start values not set will be set automatically when the tween starts.
	## Returns self.
	func startValues(key_values: Dictionary) -> GdTween:
		self.__start_values = key_values
		return self
	
	## Start another tween with the same delay as this one.
	## Returns new tween.
	func at(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
		return self.__lib.to(obj, seconds, key_values).delay(self.__delay)
	
	## Start another tween with delay equal to this tweens delay + this tweens duration
	## Returns new tween.
	func after(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
		return self.__lib.to(obj, seconds, key_values).delay(self.__delay + self.__target_time)
	
	## Call all FuncRefs in given array.
	## This will be called automatically by Tweener.
	func __callFuncRefList(FuncRefs: Array) -> void:
		if !self.__object.get_ref(): return
		for f in FuncRefs:
			f.call_func()
	
	## Call all FuncRefs __update function array.
	## This will be called automatically by Tweener.
	func __callOnUpdateFuncRefs(dt: float) -> void:
		if !self.__object.get_ref(): return
		for f in self.__on_update_funcRefs:
			f.call_func(dt)
	
	## Set tween start values to the current values corresponding to all the given keys.
	## This will be called automatically by Tweener.
	func __autoSetStartValues() -> void:
		for key in self.__end_values.keys():
			if not self.__start_values.has(key):
				self.__start_values[key] = self.__object.get_ref().get(key)
	
	## Update object values based on given completion factor.
	## This will be called automatically by Tweener.
	func __updateValues(completion_factor: float) -> void:
		if !self.__object.get_ref(): return
		
		for key in __end_values.keys():
			var start_end_diff = self.__end_values[key] - self.__start_values[key]
			self.__object.get_ref().set(key, self.__start_values[key] + start_end_diff * completion_factor)
	
	## Checks all active tweens and deletes them if there are any 
	## This will be called automatically by Tweener.
	func __deleteClashingTweens() -> void:
		for tween in self.__lib.active_GdTweens:
			if tween == self or tween.__object != self.__object or tween.__first_time_tween_runs:
				continue
			for key in tween.__end_values.keys():
				if self.__end_values.has(key):
					tween.stop()
					break
	
	var __first_time_tween_runs := true
	
	## __update the tween.
	## This will be called automatically by Tweener.
	func __update(dt: float) -> void:
		if self.__delete: return
		
		if !self.__object.get_ref():
			self.stop()
			return
		
		if self.__delay > 0:
			self.__delay -= dt
			return
		
		if self.___first_time_tween_runs:
			dt -= self.__delay
			self.__autoSetStartValues()
			self.__deleteClashingTweens()
			self.__callFuncRefList(__on_start_funcRefs)
			self.__first_time_tween_runs = false
		
		self.__callOnUpdateFuncRefs(dt)
		
		self.__curr_time += dt
		
		var completion_factor = self.__lib.call(self.ease_type, self.__curr_time / self.target_time)
		self.__updateValues(completion_factor)
		
		if self.__curr_time >= self.target_time:
			self.__callFuncRefList(self.__on_complete_funcRefs)
			self.stop()

## Dummy GdTween __object to make using the gdTweener module easier in for loops
class GdTweenDummy:
	var duration: float
	var delay_: float
	var lib: gdTweener;
	
	func _init(fake_duration: float, fake_delay: float, library: gdTweener):
		self.duration = fake_duration
		self.delay_ = fake_delay
		self.lib = library
	
	## Start another tween with the same delay as this fake one.
	## Returns new tween.
	func at(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
		return self.lib.to(obj, seconds, key_values).delay(self.delay_)
	
	## Start another tween with delay equal to this fake tweens delay + this tweens duration
	## Returns new tween.
	func after(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
		return self.lib.to(obj, seconds, key_values).delay(self.delay_ + self.duration)
	
	## add delay to the dummy tween
	func delay(seconds: float) -> GdTweenDummy:
		self.delay_ += seconds
		return self
	
	# Dummy functions
	
	func stop() -> void: pass
	
# warning-ignore:unused_argument
	func onStart(function: FuncRef) -> GdTweenDummy: return self
	
# warning-ignore:unused_argument
	func onUpdate(function: FuncRef) -> GdTweenDummy: return self
	
# warning-ignore:unused_argument
	func onComplete(function: FuncRef) -> GdTweenDummy: return self
	
	func queueFreeOnComplete() -> GdTweenDummy: return self
	
# warning-ignore:unused_argument
	func ease(ease_function_name: String) -> GdTweenDummy: return self
	
	
# warning-ignore:unused_argument
	func startValues(key_values: Dictionary) -> GdTweenDummy: return self
	

## Start and return a tween.
## Obj is the object wich contains the values you want to tween.
## Seconds is how long the tween should take.
## Key_values is a dictionary of string-value pairs that decide what the final values
## of the Obj will be when the tween is complete.
func to(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
	var tween = GdTween.new(obj, seconds, key_values, self)
	self.active_gdTweens.append(tween)
	return tween

## Create a dummy tween __object.
## Has methods: at, and after.
## Exists to make multiple offset gdTweens easier in for-loops.
func dummy(fake_duration: float = 0.0, fake_delay: float = 0.0) -> GdTweenDummy:
	return GdTweenDummy.new(fake_duration, fake_delay, self)

func _process(delta):
	for tween in active_GdTweens:
		tween.__update(delta)
	
	# deletion algorithm
	var del_count = 0
	for i in range(active_GdTweens.size()):
		var tween = active_GdTweens[i]
		if tween.__delete:
			del_count += 1
		else:
			active_GdTweens[i-del_count] = tween
	for _i in range(del_count):
		active_GdTweens.pop_back()
