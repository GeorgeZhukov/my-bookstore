module CartHelper
  def secure_credit_card_number(number)
    if number.length > 4
      result = '*' * (number.length-4)
      result += number[-4..-1]
    else
      result = 'wrong number'
    end
    result
  end
end
