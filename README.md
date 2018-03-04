# Terminal Tac Toe 

Terminal Tac Toe is a tic tac toe game developed with the Ruby language. The game has been expanded
with some extra features and can be played on any terminal.

## Features

* Developed with Ruby 2.3.1;
* Player input validation;
* Game mode selection: player vs computer / player vs player / computer vs computer;
* Game difficulty selection: newbie / medium / hard;
* Player mark customization;
* Board size selection.

## Installation

To run the game, just clone this repo and execute ```tictactoe.rb```.

## File Summary

```/tictactoe.rb``` **-->** creates a game instance and starts the game; <br/>
```/classes/Game.rb``` **-->** game class which contains the game loop, runs the game configuration and executes the game; <br/>
```/modules/BoardScan.rb``` **-->** methods to scan the board for vertical, horizontal and diagonal wins or ties; <br/>
```/modules/GameConfig.rb``` **-->** methods to get user input in order to configure the game (board size, game mode, etc.); <br/>
```/modules/MovementGetters.rb``` **-->** methods to get human input and to generate computer moves based on game difficulty; <br/>
```/tests/test_boardscan.rb``` **-->** some integration tests of the BoardScan module methods; <br/>
```/tests/test_gameconfig.rb``` **-->** some integration tests of the GameConfig module methods; <br/>
```/tests/test_boardscan.rb``` **-->** some integration tests of the BoardScan module methods. <br/>

## Game Modes

* **NEWBIE:** computer makes **random moves only**;
* **MEDIUM:** computer makes random moves but **blocks adversary movements** when they are about to win;
* **HARD:** computer makes random moves, blocks adversary movements and also scans for **possible moves to win the match**.

## Player Mark Customization

The traditional tic tac toe player marks ```X``` and ```O``` which are drawn on the tic tac toe's board can be customized to any single letter. As an example, one player can use a ```Z``` mark and the other one a ```W``` mark. 

**Traditional marks (X, O):**

```
  X |  O |  O
====+====+====
  O |  X |  X
====+====+==== 
  X |  O |  X 
```

**Customized marks (Z, W):**

```
  Z |  W |  W
====+====+====
  W |  Z |  Z
====+====+==== 
  Z |  W |  Z 
```


## Board Size Selection

Tired of easy and quick matches on a 3x3 board? Just select a board with 4 or 5 rows for more brain-intensive matches!

**3 x 3 board:**
```
  0 |  1 |  2
====+====+====
  3 |  4 |  5
====+====+==== 
  6 |  7 |  8 
```

**4 x 4 board:**
```
  0 |  1 |  2 |  3
====+====+====+====
  4 |  5 |  6 |  7
====+====+====+==== 
  8 |  9 | 10 | 11
====+====+====+====
 12 | 13 | 14 | 15
```

**5 x 5 board:**
```
  0 |  1 |  2 |  3 |  4
====+====+====+====+====
  5 |  6 |  7 |  8 |  9
====+====+====+====+====
 10 | 11 | 12 | 13 | 14
====+====+====+====+====
 15 | 16 | 17 | 18 | 19
====+====+====+====+====
 20 | 21 | 22 | 23 | 24
 ```

I've set a maximum limit of 5 rows and cols (5x5 board) because matches on bigger boards take just too long and are boring. 
However, **if the input validation up to 5 rows and cols is removed**, all the game code and board printing will work just as fine.
