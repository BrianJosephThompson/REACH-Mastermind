Dir["./modules/*.rb"].each { |file| require_relative file }
require_relative "code.rb"
require_relative "model.rb"

# A class for executing the game mastermind from the command line.
# Guess to Code checking is done via array element comparison.
class Mastermind
  DIGITS                        = 4

  include InputOutput
  include Gameplay

  def initialize
    @rounds                     = 10
    @current_round              = 0
    @code_array                 = []
    @game_over                  = false
    @number_generator           = CodeGenerator.new
    init_guess_variables
  end


  # Retrieves secret code from CodeGenerator class.
  # Initiates the start of the guessing loop.
  def game_loop
    @code_array = @number_generator.generate_secret_code_array
    puts "Will you guess the secret code?"
    until (@current_round == @rounds || @game_over == true)
      get_user_input
      check_well_placed_digit
      check_misplaced_digit
      @current_round += 1
      print_program_response
      init_guess_variables
    end
    play_again
  end
end

# Starts the game
def main
  Mastermind.new.game_loop
end

main