## Set up a slideshow by using this class several times on it's siblings.
## All slides will play one after the other.
class_name Slideshow extends Control

@export_range(0,5) var fade_in_time: float = 1
@export_range(0,5) var wait_time: float = 2
@export_range(0,5) var fade_out_time: float = 0.5

## Only play the animations if we're the first sibling or we don't have a parent.
func _ready():	
	## Set the alpha to zero
	modulate.a = 0

	## Only play the animation if we're the first slide
	if (get_parent() == null) or (get_index() == 0):
		_animate()
	
func _animate():
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).tween_property(self, "modulate", Color.WHITE, fade_in_time)

## Callback that should be played once this slide animation ends to start the next one.
func _callNextSlide():
	pass
