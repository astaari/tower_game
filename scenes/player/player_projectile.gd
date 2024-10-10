class_name PlayerProjectile extends RigidBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed : float = 200
@export var direction = Vector2.ZERO
@export var lifetime : float = 2.0
@export var damage : float = 1

func _ready() -> void:
	attack_toss()
	get_tree().create_timer(lifetime).timeout.connect(
		func ():
			var player = get_tree().get_first_node_in_group("player")
			if not player:
				return
			player.projectiles_active = max(player.projectiles_active - 1, 0)
			queue_free()
	)


func _on_hit_box_component_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		print("Hit an enemy")
		queue_free()


func attack_toss() -> void:
	var toss_value: int = randi_range(1, 6)
	$HitBoxComponent.damage = damage * toss_value
	animation_player.play("attack")
	await animation_player.animation_finished
	$Sprite2D.frame = toss_value
