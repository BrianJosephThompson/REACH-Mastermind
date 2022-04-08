require 'uri'
require 'net/http'

class RandomCodeGenerator

  DIGITS_REQUESTED     = 4
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
      num=#{DIGITS_REQUESTED}&
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
    while index < DIGITS_REQUESTED
        @random_code_array << rand(MIN_NUMBER..MAX_NUMBER)
        index += 1
    end
  end


end

class Mastermind
  def initialize
    @rounds             = 10
    @current_round      = 0
    @code_array         = []
    @guess_array        = []
    @well_placed        = 0
    @misplaced          = 0
    @number_generator   = RandomCodeGenerator.new
  end


  def get_user_input
    temp_array = gets.chomp.scan(/\d/)
    temp_array.each { |x| @guess_array << x.to_i }
    puts "#{@guess_array}"
  end

  def run
    @code_array = @number_generator.generate_secret_code_array
    get_user_input
    puts "#{@code_array}"
  end

  def start_game
    puts "Will you guess the secret code?"
    while (@current_round < @rounds)
      get_user_input
      check_user_input
    end
  end

  def check_user_input
    check_well_placed_number
    check_misplaced_number
    print_program_response
  end

  def check_well_placed_number
    index = 0
    while index < 4
      if 
    

    
  end

  def check_misplaced_number

  end

  def print_program_response

  end




end

def main
  game = Mastermind.new
  game.run
end

main