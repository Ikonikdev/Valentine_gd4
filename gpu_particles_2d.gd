extends GPUParticles2D

@export var evade_radius: float = 200.0  # Radio de reacción del mouse
@export var min_speed: float = 0.5       # Escala mínima de velocidad
@export var max_speed: float = 3.0       # Escala máxima cuando el cursor está cerca
@export var smoothness: float = 0.1      # Suavidad del cambio de dirección

func _ready():
	speed_scale = min_speed  # Configurar velocidad mínima al inicio

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = global_position - mouse_position
	var distance = direction.length()

	if distance < evade_radius:
		# Cuanto más cerca esté el cursor, más rápido huyen las partículas
		var speed_factor = 1.0 - (distance / evade_radius)
		var new_speed = min_speed + (max_speed - min_speed) * speed_factor

		# Suavizar la transición de velocidad
		speed_scale = lerp(speed_scale, new_speed, smoothness)
	else:
		# Si el cursor está lejos, volvemos gradualmente a la velocidad normal
		speed_scale = lerp(speed_scale, min_speed, smoothness)
