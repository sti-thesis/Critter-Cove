extends Node2D

@onready var pupil: Sprite2D = $Eyelid/Pupil
@onready var eye_center: Sprite2D = $Eyelid
@export var max_distance: float # Max movement range for the pupil

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_distance = (eye_center.texture.get_width()*0.002) * scale.x
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):  # Follow only when clicking/holding
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - eye_center.global_position).normalized()
		var distance = min(eye_center.global_position.distance_to(mouse_pos), max_distance)
		pupil.global_position = eye_center.global_position + direction * distance
	else:
		# Return the pupil to the center smoothly
		pupil.global_position = pupil.global_position.lerp(eye_center.global_position, 0.1)
