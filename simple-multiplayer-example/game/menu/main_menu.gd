extends Control


func _on_host_pressed() -> void:
	Network.host_server()
	get_tree().change_scene_to_file("res://game/game.tscn")

func _on_join_pressed() -> void:
	Network.join_server()
	get_tree().change_scene_to_file("res://game/game.tscn")
 
func _on_line_edit_text_changed(new_text: String) -> void:
	Network.connect_ip = new_text
