extends Node2D

@export var base_speed: float = 200.0
@export var max_speed: float = 1000.0
@export var evade_radius: float = 200.0
@export var smoothness: float = 0.1
@export var friction: float = 500.0       # Fuerza de fricción para desacelerar (unidades/segundo)

var screen_size: Vector2
var velocity: Vector2 = Vector2.ZERO     # Velocidad actual del objeto

func _ready():
	screen_size = get_viewport_rect().size
	call_deferred("set_mouse_position")

func set_mouse_position():
	Input.warp_mouse(Vector2(0, 0))

func _process(delta):
	var mouse_position = get_global_mouse_position()
	var direction = global_position - mouse_position
	var distance = direction.length()
	
	if distance < evade_radius:
		# Cuando el cursor está cerca, calculamos la velocidad deseada
		direction = direction.normalized()
		var speed_factor = 1.0 - (distance / evade_radius)   # Cuanto más cerca, mayor factor
		var current_speed = base_speed + (max_speed - base_speed) * speed_factor
		var desired_velocity = direction * current_speed
		# Suavizamos la aceleración para evitar cambios bruscos
		velocity = velocity.lerp(desired_velocity, smoothness)
	else:
		# Si el cursor se aleja, aplicamos fricción para desacelerar gradualmente
		if velocity.length() > 0:
			var deceleration = friction * delta
			if velocity.length() < deceleration:
				velocity = Vector2.ZERO
			else:
				velocity -= velocity.normalized() * deceleration
	
	# Calculamos la nueva posición usando la velocidad actual
	var target_position = global_position + velocity * delta
	# Evitamos que el objeto se salga de la pantalla
	target_position = clamp_to_screen(target_position)
	global_position = target_position

func clamp_to_screen(position: Vector2) -> Vector2:
	var margin = 20.0  # Margen para no pegarse exactamente a los bordes
	var clamped_x = clamp(position.x, margin, screen_size.x - margin)
	var clamped_y = clamp(position.y, margin, screen_size.y - margin)
	return Vector2(clamped_x, clamped_y)
