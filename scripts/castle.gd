extends Area2D

@export var fade_time: float = 1.0
@onready var enter_sound = $"../Victory/VictorySound"
var player_inside: bool = false
var player_ref: Node = null
var transitioning: bool = false

func _ready() -> void:
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    $"../Victory/Konfeta1".visible = false
    $"../Victory/Konfeta2".visible = false
func _process(_delta: float) -> void:
    if player_inside and not transitioning and Input.is_action_just_pressed("interact"):
        _enter_castle()

func _on_body_entered(body):
    if body.is_in_group("character"):
        player_inside = true
        player_ref = body

func _on_body_exited(body):
    if body.is_in_group("character"):
        player_inside = false
        player_ref = null

func _enter_castle():
    transitioning = true
    enter_sound.play()
    await get_tree().create_timer(1.0).timeout
    $"../Victory/Label".visible = true
    $"../Victory/Konfeta1".visible = true
    $"../Victory/Konfeta2".visible = true
    $"../Victory/Konfeta1".play("konfeta")
    $"../Victory/Konfeta2".play("konfeta")
    
 
    await $"../Victory/Konfeta1".animation_finished
    
    $"../Victory/Konfeta1".visible = false
    $"../Victory/Konfeta2".visible = false
    

    GameState.complete_level(0)  
    get_tree().change_scene_to_file("res://scenes/levels.tscn")
