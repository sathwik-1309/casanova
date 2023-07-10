module InningHelper

  def self.adjust_array_length(arr, length)
    if arr.length == length
      arr
    else
      last_item = arr.last
      arr + [last_item] * (length - arr.length)
    end
  end

  def self.calculate_percentage_array(array1, array2)
    raise ArgumentError, "Input arrays must have the same length" unless array1.length == array2.length

    percentage_array = []

    count = 0
    while count < 20
      percentage = (array1[count] * 100.0 / (array2[count] + array1[count])).round
      percentage_array << [percentage, 100 - percentage]
      count += 1
    end
    percentage_array
  end

end
