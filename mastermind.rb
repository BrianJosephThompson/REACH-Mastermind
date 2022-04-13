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
  include Core
  include Input


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
    start_game
  end


  # Initiates the start of the guessing loop.
  def start_game
    puts "Will you guess the secret code?"
    while (@current_round < @rounds)
      get_user_input
      check_user_input
      @current_round += 1
      print_program_response
      if @game_over == true
        break
      else
        init_guess_variables
      end
    end
    play_again
  end

end

# Starts the game
def main
  game = Mastermind.new
  game.run
end

main