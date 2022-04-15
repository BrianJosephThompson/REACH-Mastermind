require 'uri'
require 'net/http'

# Class for generating secret code array for Mastermind game.
class CodeGenerator
  DIGITS               = 4
  MIN_NUMBER           = 0
  MAX_NUMBER           = 7
  COLUMNS              = 1
  NUMBER_BASE          = 10
  FORMAT               = :plain
  RANDOM_REQUEST       = :new

  def initialize
    @random_code_array = []
  end

  # Generates code from api if internet connection exists.
  # Otherwise will generate an internal code.
  def generate_secret_code_array
    if internet_connection?
      get_code_from_api
    else
      generate_internal_code_array
    end
    @random_code_array
  end

  # Checks whether user has internet connection to Random API
  def internet_connection?
    begin
      true if URI.open("https://www.random.org")
    rescue
      false
    end
  end

  # Retrieves a string based on the constants defined at the start of the class.
  # Converts string characters to integers and stuffs them into a class instance array.
  def get_code_from_api
    string = "https://www.random.org/integers/?
      num=#{DIGITS}&
      min=#{MIN_NUMBER}&
      max=#{MAX_NUMBER}&
      col=#{COLUMNS}&
      base=#{NUMBER_BASE}&
      format=#{FORMAT}&
      rnd#{RANDOM_REQUEST}&
      "
    uri = URI(string)
    response = Net::HTTP.get_response(uri)
    if response.is_a?(Net::HTTPSuccess)
      temp = response.body 
      string_array = temp.split
      string_array.each { |x| @random_code_array << x.to_i }
    end
  end

  # Stuffs class instance array with randomly generated integers 
  def generate_internal_code_array
    index = 0
    while index < DIGITS
        @random_code_array << rand(MIN_NUMBER..MAX_NUMBER)
        index += 1
    end
  end
end