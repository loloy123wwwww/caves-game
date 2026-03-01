extends Area2D

@export var required_coins: int = 5
@onready var hatch_area = $"../Hatch"
@onready var collision = $"../Hatch/CollisionShape2D"
@onready var label = $Label
@onready var fail_sound = $Error

var player_inside: bool = false
var player_ref: Node = null

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    label.visible = false

func _process(_delta: float) -> void:
    if player_inside and Input.is_action_just_pressed("interact"):
        var player_coins = player_ref.coins if "coins" in player_ref else 0
        if player_coins >= required_coins:
            collision.set_deferred("disabled", true)
            $Label2.visible = false
            GameState.complete_level(3)
        else:
            fail_sound.play()
            animate_error_label()

func _on_body_entered(body):
    if body.is_in_group("character"):
        player_inside = true
        player_ref = body

func _on_body_exited(body):
    if body.is_in_group("character"):
        player_inside = false
        player_ref = null
var _label_tween: Tween = null

func animate_error_label():
    if _label_tween:
        _label_tween.kill()

    label.text = "Not enough coins! Need " + str(required_coins)
    label.modulate.a = 1.0
    label.visible = true
    $Label2.visible = false
    var original_pos = label.position
    label.position = original_pos 

    _label_tween = create_tween()
    _label_tween.tween_property(label, "position:x", original_pos.x + 8, 0.05)
    _label_tween.tween_property(label, "position:x", original_pos.x - 8, 0.05)
    _label_tween.tween_property(label, "position:x", original_pos.x + 6, 0.05)
    _label_tween.tween_property(label, "position:x", original_pos.x - 6, 0.05)
    _label_tween.tween_property(label, "position:x", original_pos.x, 0.05)
    await _label_tween.finished

    await get_tree().create_timer(1.0).timeout

    _label_tween = create_tween()
    _label_tween.tween_property(label, "modulate:a", 0.0, 0.5)
    await _label_tween.finished
    label.visible = false
    $Label2.visible = true
