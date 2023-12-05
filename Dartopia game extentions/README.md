### WHAT IS IT?

This NetLogo model simulates a game where humans equipped with guns try to hit targets using darts. The game takes place in a circular environment, with humans at the center aiming to hit targets appearing at random positions on circular paths. The simulation keeps track of the score, targets hit, and the highest score achieved. The game runs for a set number of ticks, saves the highest score to a file, and displays a game-over message at the end.


### HOW IT WORKS

Initialization (new-game):

Clears the environment, sets up parameters, and creates a central human with a gun and a dart.

Target Creation (create-new-target):

Periodically creates new targets at random positions on a circular path around the central point.

Update Targets (update-targets):

Existing targets age over time, and if they reach their lifespan, they are removed. New targets are created periodically.

Throwing Darts (throw):

The user can initiate dart throws, and each human agent produces a dart in the direction it is facing.

Dart Movement (go-darts):

Darts move forward, and if they hit the boundary, they are removed. Collisions with targets are checked.

Target-Dart Collision (check-dart-target-collision):

If a dart collides with a target, the target is marked for removal, a beep sound is played, and the player's score is updated based on the color of the target.

Checking Targets for Removal (check-targets-die):

Targets marked for removal are removed, and a new target is created.

Scoring and Highest Score (go):

Tracks the score, updates the highest score, and stops after a set number of ticks.

### HOW TO USE IT

Press the "New Game" button to initialize the environment and start the game.

Click the "Throw Darts" button to enable human agents to throw darts.

Observe the movement of darts and their collisions with targets.

The score and highest score are displayed in the interface.

Experiment with adjusting parameters like target creation rate and dart speed.

### THINGS TO NOTICE

Target Creation: Pay attention to how new targets are created periodically.

Dart Throwing: Observe the behavior of humans throwing darts and hitting targets.

Score Changes: Monitor the score and highest score as the simulation progresses.

### THINGS TO TRY

Adjust Parameters: Experiment with changing parameters such as target creation rate, dart speed, or the initial radius.

Observe Score Changes: Watch how the score changes according to hit targets in different color patches.

Highest Score Tracking: Note how the highest score is tracked and updated.

### EXTENDING THE MODEL

Suggestions:

Implement different dart-throwing strategies for humans.

Introduce obstacles that affect dart trajectory.

Create different types of targets with varying properties.

### NETLOGO FEATURES

Breeds: Organizes different agent types (humans, guns, targets, darts) using NetLogo's breed feature.

Patch Colors: Assigns colors to patches based on their distance from the center.

Link Creation: Uses links to represent ties between guns and their aiming arrows.

File I/O: Reads and writes data to a file, saving and loading the highest score.

Tick-based Events: Actions are triggered based on discrete time steps (ticks).

Global Variables: Used for tracking important information across the entire simulation.

Hatching Agents: Creates new agents (darts) during the simulation.

Conditional Statements: Controls the flow of the simulation based on specific conditions.

Beep Sound: Plays a sound when a dart hits a target.

### DEVELOPED BY TEAM 

-Vineela Jyothi Seerla

-Soundarya Boyeena

-Divya Podila
