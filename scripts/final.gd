extends Area2D

@export var unshaded_tilemap_path: NodePath = NodePath("")
@export var unshaded_material: Material = null

var _unshaded_tilemap: TileMapLayer = null
var _original_material: Material = null

func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)
    if unshaded_tilemap_path != NodePath(""):
        _unshaded_tilemap = get_node_or_null(unshaded_tilemap_path)
        if _unshaded_tilemap:
            _original_material = _unshaded_tilemap.material

func _on_body_entered(body):
    if body.is_in_group("character"):
        if _unshaded_tilemap and unshaded_material:
            _unshaded_tilemap.material = unshaded_material
            body.turn_audio_off()
 

func _on_body_exited(body):
    if body.is_in_group("character"):
        if _unshaded_tilemap:
            _unshaded_tilemap.material = _original_material
            body.turn_audio_on()           
   
