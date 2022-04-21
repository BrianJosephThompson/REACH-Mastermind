Dir["./modules/*.rb"].each { |file| require_relative file }
require_relative "code_generator.rb"
require_relative "model.rb"

# A class for executing the game mastermind from the command line.
# Guess to Code checking is done via array element comparison.
class Mastermind
  DIGITS                        = 4

  include InputOutput
  include Gameplay

  def initialize(num_players)
    @number_of_players          = num_players
    @rounds                     = 10 * num_players
    @current_round              = 0
    @player_1_guesses           = 0
    @player_2_guesses           = 0
    @code_array                 = []
    @game_over                  = false
    @player_plays_again         = true
    @number_generator           = CodeGenerator.new
    @current_player             = 1
    init_guess_variables
  end


  # Retrieves secret code from CodeGenerator class.
  # Initiates the start of the guessing loop.
  def game_loop
    @code_array = @number_generator.generate_secret_code_array
    puts "#{@code_array}"
    puts "==== Welcome to Mastermind ===="
    puts "Will you guess the secret code?"
    until (@current_round == @rounds || @game_over == true)
      get_user_input
      check_well_placed_hash
      check_misplaced_hash
      print_program_response
      init_guess_variables
      @current_round += 1
      if @current_player == @number_of_players
        @current_player = 1
      else
        @current_player += 1
      end
    end
      play_again
  end

  # Run function defined outside of the main loop
  def run
    while @player_plays_again == true
      game_loop
    end
  end
end



# Starts the game
def main
  game = Mastermind.new(2)
  game.run
end

main