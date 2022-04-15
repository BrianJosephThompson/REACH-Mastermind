# Mastermind Game - REACH

This project is a command line implementation of the game Mastermind completed for the REACH application process.  
This project was completed in Ruby with SQLite for the SQL embedded database.

## Description

Mastermind is a game composed of 8 pieces of different colors.  
A secret code is then composed of 4 distinct pieces.

The player has 10 attempts to find the secret code.  
After each input, the game indicates to the player the number of well placed pieces and the number of misplaced pieces.

For this implementation we will use numbers in lieu of colors and digits in lieu of pieces.  
Numbered digits are '0' '1' '2' '3' '4' '5' '6' '7'.

A well placed piece is when a player has guessed the right number at the right digit.  
A misplaced piece is when a player has guessed the right number but at a different digit location.

After each turn the player will be prompted with a message indicating the:
* Right Number Right Digit placed
* Right Number Wrong Digit placed
* Remaining guesses the player has

If the player finds the code, they win, and the game stops. They will be prompted to play again.  
If they player chooses not to play again, they will be prompted with a request for their name.  
The player score and name will be added to the Hall of Fame, which will then display the top ten player scores.

## Getting Started

### Dependencies

* Ruby
* SQLite

### Installation

* Ruby

  * Begin by checking if you already have Ruby installed. Enter the below into the command line:
    >```
    > `ruby -v`
    >```
    > If you do have ruby installed you should see something similar to this:
    >
    > ![Ruby Version Check](./readme_helpers/ruby_version_check.jpg)

  * If you do not have Ruby installed please visit the [Ruby Installer website](https://rubyinstaller.org/) for
    installation instructions.

* SQLite

  * Begin by checking if you already have SQLite installed. Enter the below in the command line:
    >```
    > `sqlite3`
    >```
    > If you do have SQLite installed you should see a similar message to the one below:
    >
    > ![Sqlite Version Check](./readme_helpers/sqlite_version_check.jpg)
    >
    > Enter Ctrl + d to exit the SQLite command prompt.

  * Please visit [this website](https://www.devdungeon.com/content/ruby-sqlite-tutorial) for detailed instructions on how to install SQLite as a Ruby gem.

* Cloning the Repository
  * Clone the repository into a folder titled brian_joseph_thompson_reach by executing the below:

```
  git clone https://github.com/BrianJosephThompson/REACH-Mastermind.git brian_joseph_thompson_reach
```

### Playing The Game

Navigate to the folder you have cloned the project into. Execute the game with  
```
ruby mastermind.rb
```

Regardless of whether the player wins or loses they will be prompted to play again:

![Lost Game](./readme_helpers/game_play.jpg)

If a player chooses not to play again they will be prompted for their name and the Hall of Fame will be printed and 
the program will be exited.  
An example of a winning game with the Hall of Fame:

![Won Game](./readme_helpers/hall_of_fame.jpg)

Only valid numbers from 0-7 are accepted as input, if a user enters something else the computer will notify them of their error:

![Invalid Input](./readme_helpers/invalid_input.jpg)


### Building the Game

My process for building this game went as follows:

* Deciding on a language:
  > I was initially torn on what language to do the project in. I am more comfortable with Ruby but had been delegating a lot of my time towards learning Java recently. Ultimately I decided that if the purpose of this project is to demonstrate ability and be able to talk through the project and collaborate together, I felt a lot more comfortable doing that in Ruby than I did in Java.

* Code Structure:
  > I chose to use classes to implement the code for this project. I am fond of the object oriented nature of Ruby and feel more comfortable operating within classes. My intent was to be consistent in the structure of the code, the naming conventions used, and the comments made accross classes and methods. I thought it best to seperate the API call into its own class. I followed similar logic with the classes for establishing a connection to the SQLite database and adding players to said database. Lastly the Mastermind game is its own class, which includes two modules. One for gameplay logic and one for player input/computer output.

* Process
  * API integration
  > The first thing I wanted to do before I got into building the project was to setup the call to the API to obtain the code. I decided that I wanted to create a CodeGenerator class for this process. I chose to create constants to hold the values that would be passed to the API in an effort to make the URL string more readable. I created an alternate method for generating the code array in the event that the user's internet has been interrupted or goes down. The API call will always be the primary method for generating the array unless the website cannot be reached. The user will not know which method generated the code, just that they are able to play the game. Later I moved this code out of the main mastermind file and into the code_generator.rb file.

  * Mastermind
  > Once I had the code generation up and running I focused on getting the user input, and writing the methods that would validate whether their was an exact match or whether their was the correct number but mismatched. After the initial setup of those methods I focused on printing the computer responses based on the players guess. I then realized I would like to have the computer give guidance to the player if the entered invalid input so I spent some time learning more about regular expressions to implement them in an input validation method. Function and class level comments were the next thing I added to the code to give a brief description of what each class, module, or method was intended to do. After that my primary focus was on refactoring the code, working on the code structure, fixing the things that I thought were working but actually were not working correctly. Lastly I dedicated my efforts towards creating this README before submitting the project.

  * SQLite Database
  > Something I really wanted to implement was the ability to display a hall of fame score list, like they used to do on arcade games when you finished playing. It also felt like a really good opportunity to make the project more applicable to the backend role I applied for by adding a SQLite database for storing the players scores and in turn printing them upon completion of the game. I setup a class for establishing the SQLite connection and for processing the requests. I then created a user class for creating the player and score in the database and for reading the information from the database to then print the top ten list. 

  * Challenges
  > I faced a few challenges in this project. Both in what I was able to implement and in what I wanted to do if I had more time. Getting the code just right for the digit checking proved to be more challenging than I had hoped. Both the well placed and the misplaced digit checks needed adjustments through the process to get just right. It was only through several specific test cases that I was able to get it working properly. Establishing the interaction with the database also caused me some headaches and took a few attempts to get just right. How i seperated and structured the code was hard as well. Looking back I would have liked to create a Game parent class that Mastermind inherits from but by the time I realized this I did not have the time to implement it. Resisting the urge to add additional features and instead make sure the project is working just like I intend it too was the right choice. I am happy with the quality of the project and look forward to the interview process.

  * Extensions included
    * Internal Code Generation if call to API fails
    * Functionality to play again
    * Hall of Fame score list
    * User Input Validation