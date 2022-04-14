# TODO(COMPLETE): Add functionality to play again
# TODO(COMPLETE): Write explanatory comments
# TODO(COMPLETE): Setup input validation
# TODO(Brian Thompson): Create Unit Tests
# TODO(Brian Thompson): Allow varying difficulty levels
# TODO(Brian Thompson): Write Readme
# TODO(COMPLETE): Implement High Score logic, Add SQL database to store information

Dir["./modules/*.rb"].each { |file| require_relative file }
require_relative "code.rb"
require_relative "model.rb"

# A class for executing the game mastermind from the command line.
# Guess to Code checking is done via array comparison.
class Mastermind

  DIGITS                        = 4

  def initialize
    @player_name                = nil
    @player_score               = 0
    @rounds                     = 10
    @current_round              = 0
    @code_array                 = []
    @game_over                  = false
    @number_generator           = CodeGenerator.new
    init_guess_variables
  end


  # Retrieves secret code from CodeGenerator class.
  def run
    @code_array = @number_generator.generate_secret_code_array
    puts "#{@code_array}"
    game_loop
  end


  # Initiates the start of the guessing loop.
  def game_loop
    puts "Will you guess the secret code?"
    until (@current_round == @rounds || @game_over == true)
      get_user_input
      check_user_input
      @current_round += 1
      print_program_response
      init_guess_variables
    end
    play_again
  end

  # module contains functions that are essential to the core
# functionality of the game.
# module Core

  
  # Initializes variables that are used in code checking validation.
  def init_guess_variables
    @valid_user_input           = false
    @code_check_array           = []
    @guess_array                = []
    @right_number_right_place   = 0
    @right_number_wrong_place   = 0
  end


  # creates an integer copy of input array
  def fill_integer_array(input_array)
    integer_array = []
    input_array.each do |element|
      integer_array << element.to_i
    end
    integer_array
  end


  # Calls two functions to check well placed and misplaced digits.
  def check_user_input
    check_well_placed_digit
    check_misplaced_digit
  end


  # Checks to see if player guess numbers match to code guess numbers
  # at the same index. If there is a match, it is counted and the matching 
  # numbers at said index are deleted from each array. The index and loop are
  # then decremented to account for the new array size.
  def check_well_placed_digit
    index = 0
    while index < DIGITS - @right_number_right_place
      if @guess_array[index] == @code_check_array[index]
        @right_number_right_place += 1
        @guess_array.delete_at(index)
        @code_check_array.delete_at(index)
        index -= 1
      end
      index += 1
    end
  end


  # Checks each remaining guess array element against the remaining code array elements.
  # If a correct number exists in the incorrect digit location, it is counted
  # and the check continues with comparing the next guess array element to the
  # remaining code array elements.
  def check_misplaced_digit
    index = 0
    puts "#{@guess_array}"
    puts "break"
    puts "#{@code_check_array}"
    while index < DIGITS - @right_number_right_place
      @guess_array.each do |digit|
        if digit == @code_check_array[index]
          @right_number_wrong_place += 1
          break
        end
      end
      index += 1
    end
  end

# end


# Module contains functions that receive input from user input
# and illicits a response from the computer.
# module Input

  # Gets and validates user input. Once valid, fills guess array
  # and creates a copy of the original code array for future checks.
  def get_user_input
    while !@valid_user_input
      response = gets.chomp
      valid_input = validate_user_input(response)
    end
    @guess_array = fill_integer_array(valid_input)
    @code_check_array = fill_integer_array(@code_array)
  end
  

  # Validates user response and illicits a response based on:
  #   Whether the response contains anything other than numbers
  #   Whether the response contains the numbers 8 or 9.
  #   If the response contains the numbers 0-7 and is only
  #   4 digits long, the response is considered valid and returned.
  def validate_user_input(response)
    case response
    when /\D/
      puts "You have entered a character, only digits are valid"
    when /[8-9]/
      puts "Only digits from 0-7 are valid"
    when /[0-7]/
      if response.size != 4
        puts "Please only enter four digits"
      else
        @valid_user_input = true
        response = response.scan(/\d/)
      end
    else
      puts "Invalid Input"
    end
    response
  end


  # Restarts the game if the player would like to play again.
  def play_again
    puts 'Would you like to play again?'
    play_again_flag = nil
    while play_again_flag.nil?
      response = gets.chomp.downcase
      case response
      when 'yes', 'y'
        play_again_flag = true 
        initialize
        run
      when 'no', 'n', 'quit'
        play_again_flag = false
        puts 'Goodbye!'
        Users.get_high_score_list
      else
        puts 'Please enter yes or no'
      end
    end
  end


  # Prints computer response to the user's guess based on:
  #   Whether they have won the game, if so adds their info to db.
  #   Whether their guess contains numbers included in the secret code.
  #   The count of their correctly placed guesses and misplaced guesses.
  def print_program_response
    case
    when @right_number_right_place == DIGITS
      puts "Congratulations! You've Won!"
      score = calculate_player_score
      player = fetch_user_name
      Users.add_user_to_db(score: score, username: "#{player}")
      @game_over = true
    when @right_number_right_place == 0 && @right_number_wrong_place == 0
      puts "The numbers you have guessed aren't included in the secret code!"
    else
      puts "Right Number Right Digit: #{@right_number_right_place}"
      puts "Right Number Wrong Digit: #{@right_number_wrong_place}"
    end
    if @game_over == true
      track_player_guesses
    end
  end


  # Tracks and responds with the players remaining guesses.
  def track_player_guesses
    guess_count = @rounds - @current_round
    case
    when @current_round != @rounds && @game_over == false
      puts "You have #{guess_count} guesses remaining!"
    when @current_round == @rounds
      puts "So sorry, you're out of guesses! Better luck next time!"
    else
    end
  end


  # Algorithm for calculating player scores.
  def calculate_player_score
    score = (@rounds - @current_round) * 10 + rand(1..9)
  end


  # Retrieve user name for adding to database.
  def fetch_user_name
    puts "Please enter your name"
    player = gets.chomp[0..15]
  end
# end

end

# Starts the game
def main
  game = Mastermind.new
  game.run
end

main