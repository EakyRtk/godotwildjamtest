class_name Player extends CharacterBody3D

#--MOVEMENT AND VIEW--
const SPEED := 8.0 #5
const JUMP_VELOCITY := 4.5 #4.5

const DEFAULT_FOV := 75
const ZOOM_FOV := 25
var t_bob := 0.0
var zoomed := false

#bob
const BOB_FREQ := 2.0
const BOB_AMP := 0.08
#-----

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera3D
@onready var player_mesh : MeshInstance3D = $PlayerMesh
@onready var look_cast : RayCast3D = $Head/Camera3D/InteractCast
@onready var interact_label : RichTextLabel = %InteractLabel




var sensitivity : float = 0.01


func _ready() -> void:
	player_mesh.hide()
	look_cast.add_exception(self)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Globals.mouse_captured:
		head.rotate_y(-event.relative.x * sensitivity)
		camera.rotate_x(-event.relative.y * sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
		
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta


	if look_cast.is_colliding() and look_cast.get_collider() is Interactable:
		var interacted_obj : Interactable = look_cast.get_collider() as Interactable
		interact_label.text = "[center]%s[/center]" % interacted_obj.prompt_name
		##objenin interact fonksiyonunu E ye basarsak çağırıyoruz
		if Input.is_action_just_pressed(interacted_obj.interact_key):
			interacted_obj.interact()
	else:
		interact_label.text = ""
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		#if walk_cast.is_colliding() and walk_cast.get_collider().has_meta("ses"):
			#if not $AudioStreamPlayer3D.playing:
				#$AudioStreamPlayer3D.stream = walk_cast.get_collider().get_meta("ses")
				#$AudioStreamPlayer3D.play()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		#holding_item_mesh.position = Vector3.ZERO
		velocity.x = 0.0
		velocity.z = 0.0
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	move_and_slide()
		
func _headbob(time: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	#left_hand_mesh.position.y = sin(time * BOB_FREQ) * BOB_AMP / 3
	#right_hand_mesh.position.y = sin(time * BOB_FREQ) * BOB_AMP / 3

	return pos	