class_name SmartZombie
extends Zombie
## Zombie inteligente: sigue el camino del NavigationAgent2D y rodea las paredes.

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D


func get_move_direction() -> Vector2:
	# Actualizo el destino en cada frame de física porque el jugador no se queda quieto.
	nav_agent.target_position = player.global_position
	if nav_agent.is_navigation_finished():
		return global_position.direction_to(player.global_position)
	return global_position.direction_to(nav_agent.get_next_path_position())
