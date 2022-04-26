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


## Object that keeps track of __object values and changes them according to time passed.
class GdTween:
	var __object: WeakRef
	var __curr_time := 0.0
	var __target_time: float
	var __end_values: Dictionary
	var __start_values: Dictionary
	var __lib: GdTweener
	var __ease_type := 'outQuad'
	var __delete := false
	var __delay := 0.0
	
	var __on_start_funcRefs := []
	var __on_update_funcRefs := []
	var __on_complete_funcRefs := []
	
	func _init(obj: Object, seconds: float, key_values: Dictionary, library: GdTweener):
		__object = weakref(obj)
		__target_time = seconds
		__end_values = key_values
		__lib = library
	
	## Mark this cTween for deletion, and remove all references to other objects
	func stop() -> void:
		__delete = true
		__lib = null
		__object = null
		__on_start_funcRefs.clear()
		__on_update_funcRefs.clear()
		__on_complete_funcRefs.clear()
	
	## Add a function reference that will be called when this tween starts.
	## The function will be called with no arguments.
	## Returns self.
	func onStart(function: FuncRef) -> GdTween:
		__on_start_funcRefs.append(function)
		return self
	
	## Add a function reference that will be called once per __update.
	## The function will be called with the 'dt' argument.
	## Returns self.
	func onUpdate(function: FuncRef) -> GdTween:
		__on_update_funcRefs.append(function)
		return self
	
	## Add a function reference that will be called on completion.
	## No functions will be called if this twen is stopped.
	## The function will be called with no arguments.
	## Returns self.
	func onComplete(function: FuncRef) -> GdTween:
		__on_complete_funcRefs.append(function)
		return self
	
	## Call queue_free on the __object this gdTween is tweening when this tween is complete.
	func queueFreeOnComplete() -> GdTween:
		__on_complete_funcRefs.append(funcref(__object.get_ref(), 'queue_free'))
		return self
	
	## Set the easing function used for this tween.
	## The default is 'outQuad'
	## Returns self.
	func ease(ease_function_name: String) -> GdTween:
		__ease_type = ease_function_name
		return self
	
	## Add a delay on this tween before it should start.
	## The given delay can be negative.
	## This allows a tween started by GdTween.after() to start at some time before this GdTween ends.
	## Returns self.
	func delay(seconds: float) -> GdTween:
		__delay += seconds
		return self
	
	## Manually set start values.
	## Start values not set will be set automatically when the tween starts.
	## Returns self.
	func startValues(key_values: Dictionary) -> GdTween:
		__start_values = key_values
		return self
	
	## Start another tween with the same delay as this one.
	## Returns new tween.
	func at(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
		return __lib.to(obj, seconds, key_values).delay(__delay)
	
	## Start another tween with delay equal to this tweens delay + this tweens duration
	## Returns new tween.
	func after(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
		return __lib.to(obj, seconds, key_values).delay(__delay + __target_time)
	
	## Call all FuncRefs in given array.
	## This will be called automatically by Tweener.
	func __callFuncRefList(FuncRefs: Array) -> void:
		if !__object.get_ref(): return
		for f in FuncRefs:
			f.call_func()
	
	## Call all FuncRefs __update function array.
	## This will be called automatically by Tweener.
	func __callOnUpdateFuncRefs(dt: float) -> void:
		if !__object.get_ref(): return
		for f in __on_update_funcRefs:
			f.call_func(dt)
	
	## Set tween start values to the current values corresponding to all the given keys.
	## This will be called automatically by Tweener.
	func __autoSetStartValues() -> void:
		for key in __end_values.keys():
			if not __start_values.has(key):
				__start_values[key] = __object.get_ref().get(key)
	
	## Update object values based on given completion factor.
	## This will be called automatically by Tweener.
	func __updateValues(completion_factor: float) -> void:
		if !__object.get_ref(): return
		
		for key in __end_values.keys():
			var start_end_diff = __end_values[key] - __start_values[key]
			__object.get_ref().set(key, __start_values[key] + start_end_diff * completion_factor)

	## Checks all active tweens and deletes them if there are any 
	## This will be called automatically by Tweener.
	func __deleteClashingTweens() -> void:
		for tween in __lib.active_GdTweens:
			if tween == self or tween.__object != self.__object or tween.__first_time_tween_runs:
				continue
			for key in tween.__end_values.keys():
				if self.__end_values.has(key):
					tween.stop()
					break
	
	var __first_time_tween_runs := true
	
	## update the tween.
	## This will be called automatically by Tweener.
	func __update(dt: float) -> void:
		if __delete: return
		
		if !__object.get_ref():
			stop()
			return
		
		if __delay > 0:
			__delay -= dt
			return
		
		if __first_time_tween_runs:
			dt -= __delay
			__autoSetStartValues()
			__deleteClashingTweens()
			__callFuncRefList(__on_start_funcRefs)
			__first_time_tween_runs = false
		
		__callOnUpdateFuncRefs(dt)
		
		__curr_time += dt
		
		var completion_factor = __lib.call(__ease_type, __curr_time / __target_time)
		__updateValues(completion_factor)
		
		if __curr_time >= __target_time:
			__callFuncRefList(__on_complete_funcRefs)
			stop()
	
	func get_class() -> String: return 'GdTween'

## list of all active GdTweens
const active_GdTweens := []

## Start and return a tween.
## Obj is the object wich contains the values you want to tween.
## Seconds is how long the tween should take.
## Key_values is a dictionary of string-value pairs that decide what the final values
## of the Obj will be when the tween is complete.
func to(obj: Object, seconds: float, key_values: Dictionary) -> GdTween:
	var tween = GdTween.new(obj, seconds, key_values, self)
	active_GdTweens.append(tween)
	return tween

## This is just here to be passed into a GdTween as a dummy object.
class Nothing:
	pass
var __nothing := Nothing.new()

## Create a dummy GdTween object.
## Has all the same methods, but does not actually tween anything.
## Exists to make multiple offset gdTweens easier in for-loops.
func dummy(fake_duration: float = 0.0, fake_delay: float = 0.0) -> GdTween:
	return GdTween.new(__nothing, 0, {}, self)

func _process(delta):
	for tween in active_GdTweens:
		tween.__update(delta)
	
	# deletion algorithm
	var del_count = 0
	for i in range(active_GdTweens.size()):
		
		var tween: GdTween = active_GdTweens[i]
		if tween.__delete:
			del_count += 1
		else:
			active_GdTweens[i-del_count] = tween
	
	for _i in range(del_count):
		active_GdTweens.pop_back()
