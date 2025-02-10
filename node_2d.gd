extends Node2D

@onready var sprite = $AnimatedSprite2D  # Referencia al personaje
@onready var screen_center = get_viewport_rect().size / 2  # Centro de la pantalla
@onready var yes_node = $yes
@onready var no_node = $no
@onready var text_label = $RichTextLabel
@onready var yes_button = $yes/TextureButton  # Referencia al botón dentro de "yes"
@onready var start_message = $StartMessage  # RichTextLabel del mensaje inicial
@onready var yay = $Yay

var arrow = load("res://Assets/Cursor flower.png")
var speed = 100  # Velocidad en píxeles por segundo
var moving = false  # Ahora comienza en falso hasta que se presione una tecla
var showing_nodes = false  # Controla si los nodos ya aparecieron
var game_started = false  # Controla si ya se presionó una tecla para iniciar

func _ready():
	# Ocultamos el cursor al inicio
	Input.warp_mouse(Vector2(0, 0))
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	Input.set_custom_mouse_cursor(arrow)
	# Ocultamos el personaje al inicio
	sprite.visible = false
	
	# Ocultamos los nodos "yes", "no" y el texto
	yes_node.modulate.a = 0
	no_node.modulate.a = 0
	text_label.modulate.a = 0  
	yay.modulate.a = 0
	
	# Conectamos el botón "yes" a su función
	yes_button.pressed.connect(_on_yes_button_pressed)

func _process(delta):
	# Esperar a que el usuario presione una tecla antes de iniciar
	if not game_started:
		if Input.is_action_just_pressed("ui_accept"):  # "ui_accept" = Enter o Espacio por defecto
			fade_out_message()  # Hace que el mensaje desaparezca antes de iniciar el juego
		return  
	
	if moving:
		var direction = (screen_center - sprite.position).normalized()  # Dirección al centro
		sprite.position += direction * speed * delta  # Movimiento suave
		
		# Cuando llega al centro, deja de moverse
		if sprite.position.distance_to(screen_center) < 5:
			moving = false
			sprite.play("normal")
			show_nodes()  # Llamamos a la función para mostrar los nodos

func fade_out_message():
	game_started = true  # Marcamos el juego como iniciado
	var tween = create_tween()
	tween.tween_property(start_message, "modulate:a", 0.0, 1.0)  # Fade-out en 1 segundo
	await tween.finished  # Espera a que termine la animación antes de continuar
	start_message.queue_free()  # Elimina el mensaje después del fade-out
	start_game()  # Llamamos a la función que inicia el juego

func start_game():
	sprite.visible = true  # Mostramos el personaje
	sprite.position = Vector2(-100, -100)  # Lo coloca en la esquina superior izquierda
	sprite.play("walking")  # Reproduce la animación de caminar
	moving = true  # Ahora sí puede moverse

func show_nodes():
	if showing_nodes:
		return  

	showing_nodes = true
	
	# Animamos la aparición de los nodos "yes", "no" y el texto
	var tween = create_tween()
	tween.tween_property(text_label, "modulate:a", 1.0, 1.5)
	tween.tween_property(yes_node, "modulate:a", 1.0, 1.5)
	tween.tween_property(no_node, "modulate:a", 1.0, 1.5)
	await tween.finished  # Esperamos a que termine la animación

	# Cuando todo ha aparecido, mostramos el cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_yes_button_pressed():
	sprite.play("hapi")  # Cambia la animación del personaje a "hapi"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var tween = create_tween()
	tween.tween_property(yes_node, "modulate:a", 0.0, 1.0)
	tween.tween_property(no_node, "modulate:a", 0.0, 1.0)
	tween.tween_property(text_label, "modulate:a", 0.0, 1.0)
	tween.tween_property(yay, "modulate:a", 1.0, 1.5)
	await tween.finished
	yes_node.queue_free()
	no_node.queue_free()
	text_label.queue_free()
	
