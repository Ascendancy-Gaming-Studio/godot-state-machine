@icon("../sprites/depurator.svg")

class_name StateMachineDepurator extends Node


@onready var state_machine := owner.find_child("*state_machine*") as StateMachine


func _ready() -> void:
	handle_subscribe()


func _on_entered_transition_in() -> void:
	print("O componente %s entrou no estado: %s - id: %s" % [
		owner.name,
		state_machine.get_current_state(),
		state_machine.get_node(state_machine.get_current_state()).get_instance_id()
	])


func _on_exited_transition_out() -> void:
	print("O componente %s saiu do estado: %s - id: %s" % [
		owner.name,
		state_machine.get_current_state(),
		state_machine.get_node(state_machine.get_current_state()).get_instance_id()
	])
	print("---")


func _subscribe() -> void:
	for child in state_machine.get_children():
		if not child is State:
			continue


		child.connect("entered_transition_in", _on_entered_transition_in)
		child.connect("exited_transition_out", _on_exited_transition_out)


func handle_subscribe() -> void:
	if not state_machine:
		return


	_subscribe()
