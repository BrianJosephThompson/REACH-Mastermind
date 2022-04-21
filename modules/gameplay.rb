

# module contains functions that are essential to the core
# functionality of the game.
module Gameplay
  DIGITS                        = 4
  
  # Initializes variables that are used in code checking validation.
  def init_guess_variables
    @valid_user_input           = false
    @code_check_array           = []
    @guess_array                = []
    @right_number_right_place   = 0
    @right_number_wrong_place   = 0
    @tracking_hash              = Hash.new(0)
  end


  # creates an integer copy of input array
  def fill_integer_array(input_array)
    integer_array = []
    input_array.each do |element|
      integer_array << element.to_i
    end
    integer_array
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

  # Checks to see if player guess and code guess numbers match at a given digit position
  # If they do, count it and add the index as key along with true as value to a hash.
  # if they do not, add the index as key and the number as value to hash.
  def check_well_placed_hash
    index = 0
    while index < DIGITS
      if @guess_array[index] == @code_check_array[index]
        @right_number_right_place += 1
        @tracking_hash[index] = true
      else
        @tracking_hash[index] = @code_check_array[index]
      end
      index += 1
    end
  end


  # Checks a guess array element against each of the remaining code array elements.
  # If a match is made, it is counted and the block is exited to avoid double counting.
  def check_misplaced_digit
    index = 0
    while index < DIGITS - @right_number_right_place
      @code_check_array.each do |digit|
        if digit == @guess_array[index]
          @right_number_wrong_place += 1
          break
        end
      end
      index += 1
    end
  end


  # Checks guess array against hash created in check_well_placed_hash
  # If the key for the hash has a value of true, we know those to be exact matches and skip them
  # If the value for an index key is a match to the value at the guess arrays index,
  # Then we know the value exists at a different index, so we incremement right number wrong place.
  def check_misplaced_hash
    index = 0
    while index < DIGITS
      if @tracking_hash[index] == true
        #Skipping matches
      elsif @tracking_hash.key?(index) && @tracking_hash.value?(@guess_array[index])
        @right_number_wrong_place += 1
      end
      index += 1
    end
  end

end