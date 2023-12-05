; CMPS 5443 SOFTWARE AGENTS FALL SEMESTER 2023

; NETLOGO PROJECT 5 - "Dartopia: Where Darts and Targets Collide" - EXTENSION

; TEAM MEMBERS :

;-Soundarya Boyeena

;-Vineela Jyothi Seerla

;-Divya Podila

; Define breeds for humans, guns, targets, and darts
breed [humans human]
breed [guns gun]
breed [targets target]
breed [darts dart]

; Define global variables
globals [radius creation-timer throw-enabled score newscore targets-hit targets-die highest-score]

; Define the new-game procedure
to new-game
  clear-turtles
  clear-patches
  ; Initialize global variables
  set creation-timer 0
  set radius 1
  set score 0
  set newscore 0
  set targets-hit 0
  set targets-die 0
  set aim-angle 0 ; Initialize aiming angle
  set throw-enabled false
  set targets-die false
  set-default-shape guns "line"
  set-patch-size 18

  ; Read the highest score from a file if it exists
  if file-exists? "highscore.txt" [
    file-open "highscore.txt"
    set highest-score file-read
    file-close
    file-delete "highscore.txt"
  ]

  ; Set patch colors based on distance from the center
  ask patches with [distance patch 0 0 >= 4 and distance patch 0 0 <= 8] [
    set pcolor blue
  ]

  ask patches with [distance patch 0 0 >= 8 and distance patch 0 0 <= 13] [
    set pcolor pink
  ]

  ask patches with [distance patch 0 0 >= 13 and distance patch 0 0 <= 18] [
    set pcolor yellow
  ]

  ask patches with [distance patch 0 0 >= 18 ] [
    set pcolor sky
  ]

  ; Create a human with a gun and a dart at the center
  ask patch 0 0 [
    sprout-humans 1 [
      set shape "person construction"
      set size 3
      set color yellow + 4
      hatch-guns 1 [
        set size 2
        ask myself [ create-link-to myself [ tie hide-link ]]
        set breed turtles
        fd 2.5
        set color red
        set shape "dart"
        ask myself [ create-link-to myself [ tie hide-link ]]
      ]
    ]
  ]

  ; Initialize ticks
  reset-ticks
end

; Define the create-new-target procedure
to create-new-target
  set radius one-of [15.5 10.5 6]
  let angle random 360
  let new-xcor radius * sin angle
  let new-ycor radius * cos angle
  ; Create a new target at a random position on a circular path
  create-targets 1 [
    set shape "target"
    set color red
    set size 3
    setxy new-xcor new-ycor
    set creation-timer ticks
  ]
end

; Define the update-targets procedure
to update-targets
  ; Check if it's time to create a new target
  if creation-timer mod 200 = 0 [
    create-new-target
  ]
  ; Increment creation-timer for existing targets
  ask targets [
    set creation-timer creation-timer + 1
  ]
  ; Check if any targets have reached their lifespan
  ask targets [
    if creation-timer mod 200 = 0 [
      ; Remove targets that have reached their lifespan
      die
    ]
  ]
end

; Define the throw procedure
to throw
  ; Enable throwing darts
  set throw-enabled true
  ask humans [
    if throw-enabled = true [
      ; Each human hatches a dart and sets its properties
      hatch-darts 1 [
        set shape "dart"
        set size 2
        set color red
        fd 2.5
        set heading aim-angle
      ]
    ]
  ]
end

; Define the go-darts procedure
to go-darts
  ; Move darts forward and check for collisions
  ask darts [
    ifelse (pxcor >= max-pxcor or pxcor <= min-pxcor or pycor >= max-pycor or pycor <= min-pycor) [
      ; If dart reaches the boundary, remove it
      die
    ] [
      ; Move dart forward and check for collisions
      forward 1
      check-dart-target-collision
    ]
  ]
end

; Define the check-dart-target-collision procedure
to check-dart-target-collision
  ; Check for collisions between darts and targets
  ask darts [
    let my-patch patch-here
    let hit-targets targets-on my-patch
    if any? hit-targets [
      ask hit-targets [
        ; If a dart hits a target, mark it for removal, play a beep, and update the score
        set targets-die true
        beep ; emits one beep
        let patch-color [pcolor] of my-patch
        ifelse patch-color = blue [
          set score score + 5
        ] [
          ifelse patch-color = pink [
            set score score + 10
          ] [

              set score score + 20

          ]
        ]
        set newscore score
        die ; Remove the hit targets
      ]
      ; Remove all darts on the same patch as the hit target
      let darts-on-my-patch darts-on my-patch
      ask darts-on-my-patch [die]
      ; Increment the count of targets hit
      set targets-hit targets-hit + 1
    ]
  ]
end

; Define the check-targets-die procedure
to check-targets-die
  ; Check if any targets are marked for removal and create a new target
  check-dart-target-collision
  if targets-die = true [
    create-new-target
    set targets-die false
  ]
end

; Define the go procedure
to go
  ; Set the heading of humans to the aiming angle
  ask humans [
    set heading aim-angle
  ]
  ; Update targets, move darts, check collisions, and display the score
  update-targets
  if throw-enabled [
    go-darts
    check-targets-die
    ; display
  ]
  ; Update the highest score
  if newscore > highest-score [
    set highest-score newscore
  ]
  ; Check if it's time to stop the simulation
  if ticks = 2000 [
    ; Save the highest score to a file before stopping
    if newscore > highest-score [
      set highest-score newscore
      file-open "highscore.txt"
      file-write highest-score
      file-close
    ]
    user-message "Game Over!! Play Again to beat the High score??"
    stop
  ]
  ; Increment the tick counter
  tick
end
@#$#@#$#@
GRAPHICS-WINDOW
10
10
612
613
-1
-1
18.0
1
10
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
701
128
790
162
NIL
new-game
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
843
130
906
163
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
690
241
952
274
aim-angle
aim-angle
0
360
0.0
1
1
NIL
HORIZONTAL

BUTTON
789
334
852
367
NIL
throw
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
709
17
775
62
NIL
newscore
17
1
11

MONITOR
825
15
913
60
NIL
highest-score
17
1
11

TEXTBOX
956
27
1392
107
Welcome to \"Dartopia: Where Darts and Targets Collide\"
16
0.0
1

TEXTBOX
1050
93
1302
566
**How to Play:**\n\n1. Click the \"new-game\" button, and then click on \"Go\".\n\n2. While the targets appear in different patches within the simulation, use the \"aim-angle\" slider to set an angle of the dart and \"throw\" button to take your shots and hit the targets.\n\n3. You'll get a Score of \"5\" if you hit a target in the Blue patch, \"10\" if you hit a target in the Pink Patch and \"15\" if you hit a target in the Yellow patch.\n\n4. Aim and hit as fast as possible because the targets disappear after 5 seconds.\n\n5. Once the game ends, Play again if you wish to beat your previous \"High Score\".\n\n*** Enjoy Playing***\n\n
14
0.0
1

TEXTBOX
626
513
776
589
Team Members: \n-Soundarya Boyeena\n-Vineela Jyothi Seerla\n-Divya Podila
15
0.0
1

@#$#@#$#@
## CMPS 5443 SOFTWARE AGENTS FALL SEMESTER 2023

## NETLOGO PROJECT 5 - "Dartopia: Where Darts and Targets Collide"

## TEAM MEMBERS

-Soundarya Boyeena

-Vineela Jyothi Seerla

-Divya Podila


## WHAT IS IT?

This NetLogo model simulates a game where humans with guns try to hit targets using darts. The game involves the creation of humans equipped with guns and darts at the center of the simulation. Targets appear at random positions on circular paths, and the objective is for the humans to throw darts to hit these targets. The simulation keeps track of the score, the number of targets hit, and the highest score achieved. The game runs for a set number of ticks (2000 ticks in this case), saves the highest score to a file and display game over user message at the end..

## HOW IT WORKS

Initialization (new-game): The model starts by clearing the environment, setting up parameters, and creating a central human with a gun and a dart.

Target Creation (create-new-target): Periodically, new targets are created at random positions on a circular path around the central point.

Update Targets (update-targets): Existing targets age over time, and if they reach their lifespan, they are removed. New targets are created periodically.

Throwing Darts (throw): The user can initiate dart throws, and each human agent produces a dart in the direction it is facing.

Dart Movement (go-darts): Darts move forward, and if they hit the boundary, they are removed. Collisions with targets are checked.

Target-Dart Collision (check-dart-target-collision): If a dart collides with a target, the target is marked for removal, a beep sound is played, and the player's score is updated as per pcolor if the target that was hit is in blue it adds 5, for pink 10 and yellow 20 points.

Checking Targets for Removal (check-targets-die): Targets marked for removal are removed, and a new target is created.

Scoring and Highest Score (go): The model tracks the score, updates the highest score, and stops after a set number of ticks.

## HOW TO USE IT

Press the "New Game" button to initialize the environment and start the game.

Click the "Throw Darts" button to enable the human agents to throw darts.

Observe the movement of darts and their collisions with targets.

The score and highest score are displayed in the interface.

Experiment with adjusting parameters like target creation rate and dart speed.

## THINGS TO NOTICE

Target Creation: Pay attention to how new targets are created periodically.

Dart Throwing: Observe the behavior of humans throwing darts and hitting targets.

Score Changes: Monitor the score and highest score as the simulation progresses.

## THINGS TO TRY

Adjust Parameters: Experiment with changing parameters such as target creation rate, dart speed, or the initial radius.

Observe Score Changes: Watch how the score changes according the hit targets in different color patches.

Highest Score Tracking: Note how the highest score is tracked and updated.

## EXTENDING THE MODEL

Suggestions:

Implement different dart-throwing strategies for humans.

Introduce obstacles that affect dart trajectory.

Create different types of targets with varying properties.


## NETLOGO FEATURES

Breeds: The model uses NetLogo's breed feature to define different types of agents, such as humans, guns, targets, and darts. This helps organize and differentiate the various entities in the simulation.

Patch Colors: Different colors are assigned to patches based on their distance from the center. This is achieved using the ask patches construct along with conditional statements to set patch colors based on distance.

Link Creation: Links are used to represent ties between guns and their aiming arrows. The create-link-to command is employed to create directed ties between the guns and their associated darts.

File I/O: The model reads and writes data to a file. It checks if a file ("highscore.txt") exists, reads the highest score from the file, and saves the highest score back to the file at the end of the simulation.

Tick-based Events: The game progresses in discrete time steps (ticks). Various actions, such as updating targets, moving darts, and checking collisions, are triggered based on the current tick count.

Global Variables: Global variables are used to keep track of important information across the entire simulation, such as the score, aiming angle, and highest score.

Hatching Agents: The hatch command is used to create new agents (darts) during the simulation. For example, each human hatches a dart when the throw procedure is invoked.

Conditional Statements: The model uses conditional statements (if, ifelse) to control the flow of the simulation based on certain conditions, such as whether it's time to create a new target or whether a dart has reached the boundary and also used for scoring if the target that was hit is in blue it adds 5, for pink 10 and yellow 20 points.

Beep Sound: The beep command is used to play a sound when a dart hits a target.

## CREDITS AND REFERENCES

Professor - Dr. Tina Jhonson

https://ccl.northwestern.edu/netlogo/docs/

https://netlogoweb.org/whats-new#may24th2019-v2.6.0

https://groups.google.com/g/netlogo-users/c/WIgqu5qlMcg

https://chat.openai.com/
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

container
false
0
Rectangle -7500403 false false 0 75 300 225
Rectangle -7500403 true true 0 75 300 225
Line -16777216 false 0 210 300 210
Line -16777216 false 0 90 300 90
Line -16777216 false 150 90 150 210
Line -16777216 false 120 90 120 210
Line -16777216 false 90 90 90 210
Line -16777216 false 240 90 240 210
Line -16777216 false 270 90 270 210
Line -16777216 false 30 90 30 210
Line -16777216 false 60 90 60 210
Line -16777216 false 210 90 210 210
Line -16777216 false 180 90 180 210

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dart
true
0
Polygon -7500403 true true 135 90 150 285 165 90
Polygon -7500403 true true 135 285 105 255 105 240 120 210 135 180 150 165 165 180 180 210 195 240 195 255 165 285
Rectangle -1184463 true false 135 45 165 90
Line -16777216 false 150 285 150 180
Polygon -16777216 true false 150 45 135 45 146 35 150 0 155 35 165 45
Line -16777216 false 135 75 165 75
Line -16777216 false 135 60 165 60

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person construction
false
0
Rectangle -7500403 true true 123 76 176 95
Polygon -1 true false 105 90 60 195 90 210 115 162 184 163 210 210 240 195 195 90
Polygon -13345367 true false 180 195 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285
Circle -7500403 true true 110 5 80
Line -16777216 false 148 143 150 196
Rectangle -16777216 true false 116 186 182 198
Circle -1 true false 152 143 9
Circle -1 true false 152 166 9
Rectangle -16777216 true false 179 164 183 186
Polygon -955883 true false 180 90 195 90 195 165 195 195 150 195 150 120 180 90
Polygon -955883 true false 120 90 105 90 105 165 105 195 150 195 150 120 120 90
Rectangle -16777216 true false 135 114 150 120
Rectangle -16777216 true false 135 144 150 150
Rectangle -16777216 true false 135 174 150 180
Polygon -955883 true false 105 42 111 16 128 2 149 0 178 6 190 18 192 28 220 29 216 34 201 39 167 35
Polygon -6459832 true false 54 253 54 238 219 73 227 78
Polygon -16777216 true false 15 285 15 255 30 225 45 225 75 255 75 270 45 285

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
