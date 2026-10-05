# Hit'n'Run

Version 0.1.1

Action platformer rougelike inspired by hollow knight
Action platformer rougelike inspired by hollow knight (test)

Made by Joko26 (coding and design) and Hysedux (art + music/sfx and level + conceptual design)

# Table of contens

- [Controls](#controls)
- [Roadmapp](#roadmap)
- [Features](#features)
	- [Status Effects](#status-effects-system)
	- [Movement System](#movement-system)


## Controls

Key/Controller | Function
---|---
a, d/left stick |	left, right
space/x |	jump
e/▲ | open inv (coming soon)
escape/pause | pause

## Roadmap

- 0.1.0: Movement system + saving/loding
- 0.2.0: Inventory + weapons/equipment
- 0.3.0: enemys + dungeon manager
- 0.5.0 music and sfx
- 0.6.0: story
- 1.0.0 Release

## Features

### Status effects System

The status effect system uses the `StatusEffect` and `CurrentEffects` resources to manage status effects, which effects get executed in the `status_effects` node.

#### Current status effects

ID | Effect
--- | ---
0 | Poison (blindness, slowness)
1 | Shock (dazzle)
2 | Frost (slowness, increased damage taken)
3 | Decay (takes fixed percentage of health and stops at 5hp)
4 | Fire (continuous damage)
5 | Regeneration (healing)
6 | Sleep (slowness, can’t attack)
7 | Confusion (reversed controlls)
8 | Slowness
9 | Speed
10 | Weakness
11 | Strenght

#### How to add new effects

New status effects can be added by:
1. adding them to the enum in `scripts/resources/status_effect.gd`
2. adding the sprites of the effect for the effect display and particles in `scripts/globals/global_assets.gd`
3. adding an execution in `scripts/components/status_effects.gd`
4. enjoy your new effect


### Movement system

#### current movement:

- walking
- jumping
- walljumping
- wallsliding

## Thanks
- [pixelfranek](https://pixelfranek.itch.io/free-textures-of-light) for the light textures
