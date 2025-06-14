## Set up a slideshow by using this class several times on it's siblings.
## All slides will play one after the other.
class_name Slideshow extends Control

@export_range(0,5) var fade_in_time: float = 1.5
@export_range(0,5) var wait_time: float = 2.5
@export_range(0,5) var fade_out_time: float = 0.5

signal slideshow_finished

# We store the Tween, in case we need to stop it
var _tween: Tween

# Store the starting time of the animation, to ensure enough time has passed before
# being able to interrupt the animation
var _start_msec: int

## Only play the animations if we're the first sibling or we don't have a parent.
func _ready() -> void:	
	# Set the alpha to zero
	modulate = Color.TRANSPARENT

	# Only play the animation if we're the first slide
	if (get_parent() == null) or (get_index() == 0):
		_animate()
	else:
		process_mode = Node.PROCESS_MODE_DISABLED

	
func _animate() -> void:
	Log.msg("Animating slide '%s'" % name)
	process_mode = Node.PROCESS_MODE_INHERIT
	visible = true
	_start_msec = Time.get_ticks_msec()
	_tween = create_tween()
	_tween.set_parallel(true)
	var alphaTime: float = fade_in_time * 0.5
	# Fade In
	_tween.set_trans(Tween.TRANS_CUBIC).tween_property(self, "modulate", Color.WHITE, alphaTime)
	_tween.set_trans(Tween.TRANS_CUBIC).tween_property(self, "scale", Vector2.ONE, fade_in_time).from(Vector2(1.05, 1.05))
	# Wait Time
	_tween.tween_interval(wait_time)
	# Fade Out
	var fadeOutDelay: float = fade_in_time + wait_time
	_tween.set_trans(Tween.TRANS_CUBIC).tween_property(self, "modulate", Color.TRANSPARENT, fade_out_time).set_delay(fadeOutDelay)
	# Wait for the animation to end and skip to the next slide
	await _tween.finished
	_callNextSlide()	


## Skip to the next slide if any input is pressed
func _input(event: InputEvent) -> void:
	if process_mode == Node.PROCESS_MODE_DISABLED: return
	if Utils.get_elapsed_seconds(_start_msec) < fade_in_time: return
	if _tween == null: return
	if event.is_released():
		_tween.stop()
		_callNextSlide()


## Reset the state of the current slide (not visible, process disabled, white tinted and scale 1)
func _reset() -> void:
	_tween = null
	modulate = Color.WHITE
	scale = Vector2.ONE
	process_mode = Node.PROCESS_MODE_DISABLED
	visible = false


## Only called on the final element of the slideshow. It'll be ignored on all others.
func _finish() -> void:
	Log.msg("Slideshow end")
	slideshow_finished.emit()


## Callback that should be played once this slide animation ends to start the next one.
func _callNextSlide() -> void:
	_reset()
	
	# Check if it has a parent
	var parent := get_parent()
	if parent == null:
		_finish()
		return
		
	# Check if the next inex is valid
	var next_index: int = get_index() + 1
	if next_index >= parent.get_child_count(): 
		_finish()
		return
		
	# Check if the next sibling is a Slideshow too
	var next_sibling: Slideshow = parent.get_child(next_index)
	if next_sibling == null: 
		_finish()
		return
		
	# Animate the next slide
	next_sibling._animate()
