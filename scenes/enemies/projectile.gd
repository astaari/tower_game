class_name Projectile extends Node2D

@export var speed : float = 200
@export var direction = Vector2.ZERO
@export var lifetime : float = 5.0
@export var damage : float = 10

#func _init(direction: Vector2 = Vector2.ZERO,speed : float = 200,lifetime : float = 5.0):
	#self.direction=direction
	#self.speed = speed
	#self.lifetime = lifetime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print($AnimationPlayer)
	$HitBoxComponent.damage = damage
	#$AnimationPlayer.play("rotate")
	get_tree().create_timer(lifetime).timeout.connect(
		func ():
			queue_free()
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta : float) -> void:
	position+=direction*speed*delta


func _on_hit_box_component_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free() # Replace with function body.
