
require 'uri'
require 'net/http'

class Mastermind


def get_secret_code
  uri = URI('https://www.random.org/integers/?num=4&min=0&max=7&col=1&base=10&format=plain&rnd=new')
  result = Net::HTTP.get_response(uri)
  temp = result.body if result.is_a?(Net::HTTPSuccess)
  string_array = temp.split
  code_array = []
  string_array.each { |x| code_array << x.to_i }

  puts "#{code_array}"
  index = 0
end

def main
  get_secret_code
end

main