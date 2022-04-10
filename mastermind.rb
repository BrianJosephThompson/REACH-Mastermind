# TODO(Brian Thompson): Add functionality to play again
# TODO(Brian Thompson): Create Unit Tests
# TODO(Brian Thompson): Allow varying difficulty levels
# TODO(Brian Thompson): Implement High Score logic, Add SQL database to store information


require 'uri'
require 'net/http'


class RandomCodeGenerator
  DIGITS_REQUIRED      = 4
  MIN_NUMBER           = 0
  MAX_NUMBER           = 7
  COLUMNS              = 1
  NUMBER_BASE          = 10
  FORMAT               = :plain
  RANDOM_REQUEST       = :new

  def initialize
    @random_code_array = []
  end

  # generates code from api if internet connection exists
  # otherwise will generate an internal code.
  def generate_secret_code_array
    if internet_connection?
      get_code_from_api
    else
      generate_internal_code_array
    end
    @random_code_array
  end


  def internet_connection?
    begin
      true if URI.open("https://www.random.org")
    rescue
      false
    end
  end


  def get_code_from_api
    uri = URI(
      "https://www.random.org/integers/?
      num=#{DIGITS_REQUIRED}&
      min=#{MIN_NUMBER}&
      max=#{MAX_NUMBER}&
      col=#{COLUMNS}&
      base=#{NUMBER_BASE}&
      format=#{FORMAT}&
      rnd#{RANDOM_REQUEST}&
      ")

    response = Net::HTTP.get_response(uri)
    temp = response.body if response.is_a?(Net::HTTPSuccess)
    string_array = temp.split
    string_array.each { |x| @random_code_array << x.to_i }
  end


  def generate_internal_code_array
    index = 0
    while index < DIGITS_REQUIRED
        @random_code_array << rand(MIN_NUMBER..MAX_NUMBER)
        index += 1
    end
  end


end

class Mastermind
  DIGITS                        = 4


  def initialize
    @rounds                     = 10
    @current_round              = 0
    @code_array                 = []
    @game_over_flag             = false
    @number_generator           = RandomCodeGenerator.new
    init_guess_variables
  end


  def init_guess_variables
    @code_check_array           = []
    @guess_array                = []
    @right_number_right_place   = 0
    @right_number_wrong_place   = 0
  end


  def get_user_input
    temp_array = gets.chomp.scan(/\d/)
    temp_array.each { |digit| @guess_array << digit.to_i }
    @code_array.each { |digit| @code_check_array << digit }
  end


  def run
    @code_array = @number_generator.generate_secret_code_array
    puts "#{@code_array}"
    start_game
  end


  def start_game
    puts "Will you guess the secret code?"
    while (@current_round < @rounds)
      get_user_input
      check_user_input
      @current_round += 1
      print_program_response
      if @game_over_flag == true
        break
      else
        init_guess_variables
      end
    end
    play_again
  end


  def check_user_input
    check_well_placed_digit
    check_misplaced_digit
  end


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


  def print_program_response
    case
    when @right_number_right_place == DIGITS
      puts "Congratulations! You've Won!"
      @game_over_flag = true
    when @right_number_right_place == 0 && @right_number_wrong_place == 0
      puts "The numbers you have guessed aren't included in the secret code!"
    else
      puts "Right Number Right Digit: #{@right_number_right_place}"
      puts "Right Number Wrong Digit: #{@right_number_wrong_place}"
    end
    track_player_guesses
  end


  def track_player_guesses
    guess_count = @rounds - @current_round
    case
    when @current_round != @rounds && @game_over_flag == false
      puts "You have #{guess_count} guesses remaining!"
    when @current_round == @rounds
      puts "So sorry, you're out of guesses! Better luck next time!"
    else
      puts "when will i print?"
    end
  end


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
      else
        puts 'Please enter yes or no'
      end
    end
  end

end

def main
  game = Mastermind.new
  game.run
end

main