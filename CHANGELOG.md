18 into dev:

I will try to log my changes in here along with times.
I will work on harpoon shooting.

43 min:

I implemented basic harpoon shooting.

1 hr 15 min in (5:23pm):
I implemented reeling and the harpoon's FSM,
I will take a break.

...

Picking up:
I need to:

- [x] add max distance to shoot (just skip straight to charging if too far)
- [x] add locked state
  - reel state will assume it was previously locked, because if the player tries to reel just reset to charging state
- [x] apply force to player on reel
- [ ] make enemies
  - [x] bat enemies
    - cool ai idea: bats have a flapping cooldown, their x vel is just towards the player and they flap if cooldown is over and the player is above them  (like flappy bird)
  - [x] batguy
    - walks and spawns bats
    - if time, give different personalities, like always chase player vs keep distance
- [ ] map
  - [ ] add walls and hooking points
  - [ ] add start point and end point
    - don't need to actually add multiple levels, just have the things there
- [ ] explode on contact?


start working again at 6:38pm

1:39
reeling took a while to balance
