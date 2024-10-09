class_name PlayerProjectile extends RigidBody2D

@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed : float = 200
@export var direction = Vector2.ZERO
@export var lifetime : float = 3.5
@export var damage : float = 10

func _ready() -> void:
	var toss_value: int = randi_range(1, 6)
	$Sprite2D.frame = toss_value
	$HitBoxComponent.damage = damage * toss_value
	get_tree().create_timer(lifetime).timeout.connect(
		func ():
			var player = get_tree().get_first_node_in_group("player")
			player.projectiles_active = max(player.projectiles_active - 1, 0)
			queue_free()
	)


func _on_hit_box_component_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("Hit an enemy")
		queue_free()
