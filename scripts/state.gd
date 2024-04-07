@icon("../sprites/state.svg")

class_name State extends Node


signal entered_transition_in
signal entered_transition_out
signal exited_transition_in
signal exited_transition_out


@export var one_shot := false


@onready var state_machine := get_parent() as StateMachine


func _ready() -> void:
	if not state_machine:
		return


	transition_out()


func _process(_delta: float) -> void:
	state_machine.handle_transition_one_shot.call_deferred(self)


func transition_in() -> void:
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)


func transition_out() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
