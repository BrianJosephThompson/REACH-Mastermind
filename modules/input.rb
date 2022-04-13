
# Module contains functions that receive input from user input
# and illicits a response from the computer.
module Input
  DIGITS                        = 4
  
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
      calculate_player_score
      fetch_user_name
      Users.add_user_to_db(score: @player_score, username: "#{@player_name}")
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
    @player_score = (@rounds - @current_round) * 10 + rand(1..9)
  end


  # Retrieve user name for adding to database.
  def fetch_user_name
    puts "Please enter your name"
    player_name = gets.chomp
    @player_name = player_name[0..15]
  end
end