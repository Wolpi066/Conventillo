# Conventillo

Segundo parcial de Videojuegos. Juego visto desde arriba: hay que cruzar cada nivel sin que te toque un zombie
y salir por la puerta del fondo.

Hecho con Godot 4.7.2.

## Cómo abrirlo

1. En el Administrador de Proyectos: Importar, elegir `CONVENTILLO.zip` y una carpeta vacía.
2. Importar, con "Editar Ahora" marcado.
3. F5.

## Controles

- WASD: moverse
- Mouse: apuntar
- Clic izquierdo: disparar
- R: reiniciar el nivel
- Esc: volver al menú

## Cómo funciona

- Hay dos zombies: el tonto va derecho al jugador y se traba con las paredes, el inteligente usa
  NavigationAgent2D para rodearlas.
- Las balas son limitadas: se empieza con 12. Cada zombie que muere tiene 25% de chance de soltar
  una caja con 6 balas más.
- Matar un zombie tonto da 100 puntos y uno inteligente 150. Los puntos y las balas pasan de un nivel al otro.
  Si te agarran o reiniciás con R, vuelven a lo que tenías al entrar al nivel.
- El nivel 2 tiene más zombies y son más rápidos.
- `Game` y `Fade` son autoloads: `Game` guarda los puntos y las balas entre escenas, y `Fade` hace
  el fundido a negro cada vez que se cambia de escena.
