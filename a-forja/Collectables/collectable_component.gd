extends Area2D

class_name CollectableComponent

var wood : int = 1
func _on_body_entered(_body: Node2D) -> void:
	if _body is BaseCharacter:
		queue_free()
		Globals._wood += wood 
		print(Globals._wood)
		
