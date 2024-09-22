# Breakout Game in Lua

This project is a classic **Breakout** game implemented in Lua. The game consists of a menu page, multiple levels, and a leaderboard for players to track their scores. Players can control a paddle to hit a ball, break bricks, and clear levels while avoiding losing lives.

## Features
- **Menu Page**: Choose to view the leaderboard or start the game.
- **Paddle Selection**: Upon starting the game, the player can choose their paddle.
- **Multiple Levels**: Clear all the bricks to progress to the next level, which is dynamically generated.
- **Powerups**: Randomly generated powerups offer temporary perks to help players break more bricks or avoid losing lives.
- **Leaderboard**: After the game ends, the player can enter their name to be displayed on the leaderboard based on their score.

## How to Play
1. **Menu**:  
   - Start the game by selecting "Start" or view the leaderboard by selecting "Leaderboard".
   
2. **Paddle Control**:  
   - Move the paddle left or right using the `A` and `D` keys.
   - Press the `Spacebar` to launch the ball.

3. **Gameplay**:  
   - Break bricks by hitting the ball with the paddle.
   - Earn points with each brick you destroy.
   - Avoid letting the ball fall below the screen, or you will lose a life.
   - If you clear all bricks, you progress to the next level.
   - Randomly generated powerups provide helpful effects like multi-balls or increasing paddle size.

4. **Game Over**:  
   - When all lives are lost, the game ends, and you will be prompted to enter your name for the leaderboard.

## Controls
- **Move Left**: `A`
- **Move Right**: `D`
- **Launch Ball**: `Spacebar`

## Powerups
Powerups are randomly generated throughout gameplay and give temporary benefits, such as:
- **Extended Paddle**: Increases the length of your paddle.
- **Multi-Ball**: Launches additional balls to help you clear bricks faster.
- **Extra Life**: Adds an extra life.

## Installation and Running the Game

1. **Install Love2D**:  
   The game is built using the [Love2D](https://love2d.org/) game engine. You will need to install it on your system to run the game.
   
2. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/breakout-game-lua.git
   ```
   
3. **Run the Game**:
   Open a terminal and navigate to the game directory:
   ```bash
   cd breakout-game-lua
   love .
   ```

## Leaderboard
The leaderboard displays the highest scores achieved by players. After losing all lives, you can enter your name to record your score.

## Credits
- **Game Engine**: Love2D
- **Language**: Lua

Enjoy playing Breakout!
