class_name Projectile extends Node2D

@export var speed : float = 200
@export var direction = Vector2.ZERO
@export var lifetime : float = 5.0
@export var damage : float = 10


func _ready() -> void:
	$HitBoxComponent.damage = damage
	#$AnimationPlayer.play("rotate")
	get_tree().create_timer(lifetime).timeout.connect(
		func ():
			queue_free()
	)


func _physics_process(delta : float) -> void:
	position += direction * speed * delta


func _on_hit_box_component_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		queue_free() # Replace with function body.
