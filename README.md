# Core game design
### Overall 
Campaign and Endless Mode 
Campaign comprises Cutscene to explain game plot, and 2 scenes to play. 
Endless mode play until player dies. 
Score is gained based on enemies killed, planets destroyed, and show survival time. 



### Scenes
main_menu.tscn 
PreWorld.tscn contains most cutscenes
World.tscn contains level 1
World2.tscn contains level 2
EndlessWorld.tscn contains endless game 
gameover.tscn

# Player design
Player press space to move spaceship toward mouse position, left click mouse to shoot. 
Just destroy everything and player should win!

# Boss Design 

### How boss works?
Boss always target a player, it either move toward (chase) or orbiting player. 
While moving, it pick a shooting style, (called a shoot pattern).
That's it!

### Keys
1. Finite state machine (FSM)
- In BossStateManger.gd, comprise of shooting styles as
states: laser, straight, circle,... presented as enums
- At any given moment, a boss is at ONE shooting state. 
- 3 main parts (functions): enter_state, physic_process, and state_exit. 
First state is NONE, then whenever state is changed, run state_exit(old_state) to cleanup 
old state, then run state_enter(new_state) to enter the new state. During the time the 
state is active, it's respective function is called in _physics_process(). 

Cycle of a state: 
state_enter -> run permanent loop til it's changed in physics_process -> state_exit

E.g: laser state 
state_enter(LASER) -> _laser() is run in physics_process -> state_exit(LASER)

2. State picker
- In BossDecisionPicker.gd, 6 states in total, each assigned different percentage (%) to occur
- The way it works: pick 1 out of 6 states randomly (with equal chance). 
Take the picked state, and randomize based on its assigned percentage to decide whether 
the state will be picked, if not, rerun the function (repeat until 1 is picked).

3. Other minor parts 
- Guns: boss has 12 guns in total, surrounding itself (2 consecutive guns differ an angle 
of 30 degrees)
- Laser: Using raycast to check collision, draw a line from boss position
to its first colliding target. If no target hitted, max_length to limited laser.
- Moving: has player as target position, if boss position > thresh_hold distance, 
move straight to player position, else orbiting the player

# Enemy Design 
Idle means velocity = 0, chase = move toward player, when idle too long without finding 
player, it patrols a.k.a moving to a recent place

- FSM as Boss, but 3 states: IDLE, PATROL, CHASE more simple
-> has no state_enter or state_exit, logic is handle in physics_process state functions
- 1 Gun 
- Detect player if in zone

# Asteroids Design
 

# Spawners Design

# Other components 
- DropManager 
- Hurt/Hitbox
- Gun & Bullet

