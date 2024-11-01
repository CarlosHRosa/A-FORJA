extends Control

@onready var wood_counter: Label = $ContainerConterWood/WoodContainer/WoodCounter as Label

func _ready() -> void:
	wood_counter.text = str("%04d" % Globals._wood)
