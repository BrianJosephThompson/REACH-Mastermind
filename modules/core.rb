# module contains functions that are essential to the core
# functionality of the game.
module Core

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
end