class_name DumbZombie
extends Zombie
## Zombie tonto: va en línea recta al jugador y se traba contra lo que tenga adelante.


func get_move_direction() -> Vector2:
	return global_position.direction_to(player.global_position)
