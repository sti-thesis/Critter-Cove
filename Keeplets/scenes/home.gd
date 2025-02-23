extends Node2D

@onready var hunger_lbl: Label = $hungerLbl
@onready var button: Button = $Button
@onready var hunger_lbl_2: Label = $hungerLbl2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hunger_lbl.text = "hunger " + str(GameManager.save_data["animals"]["tarsier"]["hunger"])
	hunger_lbl_2.text = "hunger " + str(GameManager.save_data["animals"]["eagle"]["hunger"])


func _on_button_button_up() -> void:
	GameManager.feed_animal("tarsier")


func _on_button_2_button_up() -> void:
	GameManager.feed_animal("eagle")
