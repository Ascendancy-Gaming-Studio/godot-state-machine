@icon("../sprites/state-machine.svg")

class_name StateMachine extends Node


signal auto_start_changed
signal current_state_changed
signal previous_state_changed


@export var _auto_start := true: set=set_auto_start, get=get_auto_start


var _previous_state: String: set=set_previous_state, get=get_previous_state
var _current_state: String: set=set_current_state, get=get_current_state


"""
SETTERS and GETTERS
"""
func set_auto_start(new_value: bool) -> void:
	if _auto_start == new_value:
		return


	_auto_start = new_value
	emit_signal("auto_start_changed")


func set_current_state(new_value: String) -> void:
	if _current_state == new_value:
		return


	_current_state = new_value
	emit_signal("current_state_changed")


func set_previous_state(new_value: String) -> void:
	if _previous_state == new_value:
		return


	_previous_state = new_value
	emit_signal("previous_state_changed")


func get_auto_start() -> bool:
	return _auto_start


func get_current_state() -> String:
	return _current_state


func get_previous_state() -> String:
	return _previous_state


func _ready() -> void:
	if not get_auto_start():
		return

	if not get_child_count():
		return


	handle_change_state(get_children().front().name)


func handle_change_state(state: String) -> void:
	_change_state(state)


func _change_state(state: String) -> void:
	set_current_state(state)
	handle_init_previous_state()
	handle_init_current_state()
	set_previous_state(get_current_state())


func handle_init_current_state() -> void:
	if not get_current_state():
		return

	var node := get_node_or_null(get_current_state())

	if not node:
		return

	if not node.has_method("transition_in"):
		return


	_init_current_state(node)

func _init_current_state(node: State) -> void:
	node.emit_signal("entered_transition_in")
	node.transition_in()
	node.emit_signal("entered_transition_out")


func handle_init_previous_state() -> void:
	if not get_previous_state():
		return

	var node := get_node_or_null(get_previous_state())

	if not node:
		return

	if not node.has_method("transition_out"):
		return


	_init_previous_state(node)

func _init_previous_state(node: State) -> void:
	node.emit_signal("exited_transition_in")
	node.transition_out()
	node.emit_signal("exited_transition_out")


# Finaliza o estado inicializado quando o modo de execuçao unica esta ativo.
func handle_transition_one_shot(node: State) -> void:
	if not node.get("one_shot"):
		return


	_transition_one_shot(node)


func _transition_one_shot(node: State) -> void:
	_init_previous_state(node)


func get_shared_property(state: String, property: String) -> Variant:
	assert(not property.begins_with("_"), "Oppss, voce nao pode acessar propriedades privada.")
	assert(has_node(state))

	return get_node(state).get(property)
