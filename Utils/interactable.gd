class_name Interactable
extends CollisionObject3D

signal interacted

@export var interact_key : String = "interact"
##Etkileşime geçilebilir mi?
@export var can_interact : bool = true

var prompt_name := "interactable"
##Oyuncu etkileşime geçtiğinde direkt olarak bu fonksiyonu çağırır.
##Interactable değilse boşverir, diğer durumda interacted'i emitler ve
##_on_interacted fonksiyonunu kendinde çağırır. Virtual bir fonksiyondur.
func interact() -> void:
	if not can_interact:
		return
	interacted.emit()
	_on_interacted()

##interactable'den inherit bir class burada istediğini çalıştırabilir.
##Örneğin, CustomerInteractable, burada kendi customer_interact'ını emitlerken
##customer_interact.emit(self) yaparak CustomerManager için kendisini parametre olarak yollar.
##Başka bir örnek için Money'e de bakılabilir.
func _on_interacted():
	pass

func _ready() -> void:
	add_to_group("Interactable")
