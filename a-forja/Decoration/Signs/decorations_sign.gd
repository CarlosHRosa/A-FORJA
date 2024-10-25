extends DecorationComponent

class_name DecorationSign


func _ready() -> void:
	var _sign_texture: String = _textures_list.pick_random()
	if _sign_texture == "res://Decoration/Signs/18.png":
		$Texture1.position = Vector2(-0,-40)
	$Texture1.texture = load(_sign_texture)
