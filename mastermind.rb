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

  # generates code from api if internet connection exists, otherwise will generate an internal code.
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
    @code_check_array           = []
    @guess_array                = []
    @right_number_right_place   = 0
    @right_number_wrong_place   = 0
    @number_generator           = RandomCodeGenerator.new
  end


  def get_user_input
    temp_array = gets.chomp.scan(/\d/)
    temp_array.each { |x| @guess_array << x.to_i }
  end

  def run
    @code_array = @number_generator.generate_secret_code_array
    @code_array.each { |digit| @code_check_array << digit }
    start_game
  end

  def start_game
    puts "Will you guess the secret code?"
    while (@current_round < @rounds)
      get_user_input
      check_user_input
    end
  end

  def check_user_input
    check_well_placed_digit
    check_misplaced_digit
    print_program_response
  end

  def check_well_placed_digit
    index = 0
    while index < DIGITS
      if @guess_array[index] = @code_check_array[index]
        @right_number_right_place += 1
        @guess_array.delete_at(index)
        @code_check_array.delete_at(index)
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
    @current_round += 1
    guess_count = @rounds - @current_round
    if @right_number_right_place == DIGITS
      puts "Congratulations! You Won!"

    elsif @right_number_right_place == 0 && @right_number_wrong_place == 0
      puts "The numbers you have guessed aren't included in the secret code!"

    elsif @current_round == @rounds
      puts "So sorry, you're out of guesses! Better luck next time!"

    else
      puts "Right Number Right Digit: #{@right_number_right_place}"
      puts "Right Number Wrong Digit: #{@right_number_wrong_place}"
    end

    if @current_round != @rounds
      puts "You have #{guess_count} guesses remaining!"
    end
  end




end

def main
  game = Mastermind.new
  game.run
end

main