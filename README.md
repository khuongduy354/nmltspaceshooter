# Core game design
### Overall 
Campaign and Endless Mode 
Campaign comprises Cutscene to explain game plot, and 2 scenes to play. 
Endless mode play until player dies. 
Score is gained based on enemies killed, planets destroyed, and show survival time. 



# Player design
- space or wasd control
- fly and shoot

# Boss Design 

- always target player
- have many shooting states in BossStateManager.gd (FSM)
- pick state randomly based on %
- movement: if close enough player orbit, else chase (fly straight toward player)
- boss shooting: has 12 guns in total, surrounding itself (2 consecutive guns differ an angle 
of 30 degrees)

# SFX and VFX

- use godot physics particle system

- use shaders: white flash,

- sources:

- animation: godot animation player, keyframe properties: Sprite.frame


# Enemy Design 

- 1 Gun 

- patrol, idle, chasing states (fsm)

- detect player if in zone -> chase (fly toward player and attack)

- player out range -> idle

- idle for some times -> patrol (move a bit)



# Asteroids Design

- 3 sizes: big small medium

- big destroyed -> 2 medium, medium destroyed -> 2 small

- only big has collision detection


# Spawners Design

- spawn mobs every X interval

- max_mobs_count limit mobs on map that spawner can have at a time

# cutscenes design

- Each cutscene is coded very differently

- cut scene manager, loads cutscenes in order

- press next move to next, or exit to move to main menu

- has written plot, displayed in textbox 

  

# UI

- connect signal, change scenes

- apply transition

- put UI ín structure


# Other components

### DropManager & Drop item

* drop manager: item and its percentage can be configured depending on scene

* call drop may drop or not item based on its %

  

### Gun & Bullet

* a gun can take any bulletscene

* call shoot on gun will shoot provided bullet based on marker position

* laser -> raycast, draw from beginning to closest colliding object (player)

  

  



