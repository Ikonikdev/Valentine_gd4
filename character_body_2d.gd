extends CharacterBody2D

# Velocidad máxima del objeto
@export var speed: float = 200.0  
# Distancia mínima para reaccionar
@export var evade_radius: float = 100.0  
# Factor de suavizado para lerp()
@export var smoothness: float = 0.1  

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = global_position - mouse_position
	var distance = direction.length()
	
	if distance < evade_radius:
		direction = direction.normalized()
		var target_position = global_position + direction * speed * delta
		global_position = lerp(global_position, target_position, smoothness)
