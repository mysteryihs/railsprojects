require 'sinatra'
#require 'sinatra/reloader'

def caesar_cypher(input_string, shift)
	#initialize the alphabet to number hash
	return nil if input_string == nil
	letters = ('a'..'z').to_a
	cap_letters = ('A'..'Z').to_a
	numbers = (1..26).to_a
	cap_numbers = (27..53).to_a
	decrypted = Hash.new
	cap_decrypted = Hash.new
	letters.zip(numbers).each do |letter, number|
		decrypted[letter] = number
	end
	cap_letters.zip(cap_numbers).each do |letter, number|
		cap_decrypted[letter] = number
	end
	decrypted = cap_decrypted.merge(decrypted)


	output_string = []
	final_answer = []
	input_string = input_string.split("")
	#this checks if it's a letter and changes to integer
	input_string.each do |letter|
		if ['!', ' ', '.','"', '\'', '?'].include? letter
			output_string << letter
		else
			output_string << decrypted[letter]
		end
	end
	#shifts the cypher the amount of times specified
	shift.times do
		output_string.collect! do |number|
			if number.is_a? Integer
				#this determines whether it is capitalized or not
				if number > 26
					if number + 1 < 53
						number += 1
					else
						number = 27
					end
				end
				if number <= 26
					if number + 1 < 27
						number += 1
					else
						number = 1
					end
				end
				number
			else
				number
			end
		end
	end
	#this changes the integers back into a number
	output_string.each do |number|
		if number.is_a? Integer
			final_answer << decrypted.key(number)
		else
			final_answer << number
		end
	end

	final_answer.join
end

answer = ""

get '/' do
  input = params['input']
  answer = caesar_cypher(input, 5)
  erb :index, :locals => {:answer => answer}
end