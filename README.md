### WHAT IS IT?

The Archery Game Simulation is a NetLogo model that replicates the experience of an archery game. Players take on the role of an archer, aiming to hit moving targets with limited darts to earn points. The game challenges players to test their aiming and shooting skills by hitting as many targets as possible.

### HOW IT WORKS

Agents-
The simulation involves three breeds of agents: humans (archers), darts, and targets.

Initialization-
The setup procedure initializes the simulation by creating patches, humans, darts, and targets.

Gameplay-
Players control the character and can shoot darts by clicking the "Shoot" button. Launched darts move horizontally across the screen.

Target Movement-
Targets move vertically within specific regions, simulating different difficulty levels.

Scoring-
Hitting a target increases the player's score, and hit targets are removed from the simulation.

Win/Lose Conditions-
The player wins by hitting all targets; the game ends if the player runs out of darts without hitting all targets.

### HOW TO USE IT

Setup: Press the "Setup" button to initialize the simulation.

Shoot: Click the "Shoot" button to launch darts from the character (10 shots by default).

Game Progress: Watch targets move and aim to maximize your score.

Win/Lose: The game ends when all targets are hit (win) or when you run out of darts without hitting all targets (lose).


### THINGS TO NOTICE

Observe target movements at different speeds based on their positions.

Keep an eye on remaining shots; the game ends when exhausted.

The player's score increases with each hit target.

Check the message area for game status updates.


### THINGS TO TRY

Aim to hit all targets and win the game.

Experiment with different aiming and shooting strategies.

Modify the code to adjust remaining shots, target speeds, or other parameters.


### EXTENDING THE MODEL

Player-Controlled Dart Angle-

Allow players to control the angle of dart launches.

Dart Direction Control-

Implement controls for players to set dart direction, aiming both left and right.

Launch Dart at an Angle-

Modify shoot procedure to consider player-set dart direction and launch angle.

Control the Dart Angle-

Introduce controls for players to dynamically adjust dart angle during gameplay.

Update Dart Angle-

Adjust go-darts procedure to consider player-controlled dart angle.


### NETLOGO FEATURES

Utilizes NetLogo's agent-based modeling features (ask, sprout, hatch).

Uses patches and breeds to set up the game environment and agent interactions.

The update-user-message procedure updates the user message in the Interface tab.


### DEVELOPED BY TEAM 

-Vineela Jyothi Seerla

-Soundarya Boyeena

-Divya Podila
