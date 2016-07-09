require 'sinatra'
require 'sinatra/reloader'

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'


get '/' do
	input = params['guess']
	message = ""
	message = eval_answer(input)
	erb :index, :locals => {:secret_word => session['secret_word'], :secret_word_hidden => session['secret_word_hidden'], 
		:message => message, :guesses => session['guesses'], :guessed_letters => session['guessed_letters']}
end

get '/new' do
	gen_answer
	session['guesses'] = 10
	session['secret_word'] = @secret_word
	session['secret_word_hidden'] = @secret_word_hidden
	session['guessed_letters'] = "nothing"
	erb :index, :locals => {:secret_word => session['secret_word'], :secret_word_hidden => session['secret_word_hidden'],
	:guesses => session['guesses'], :guessed_letters => session['guessed_letters']}
	redirect to('/')
end

get '/win' do
	erb :win, :locals => {:secret_word => session['secret_word'].join}
end

get '/lose' do
	erb :lose, :locals => {:secret_word => session['secret_word'].join}
end


helpers do
	def gen_answer
		words = File.open "5desk.txt"
		valid_words = []
		while words.eof? != true
			current_line = words.readline
			if current_line.length > 5 && current_line.length < 12
				valid_words << current_line
			end
		end
		@secret_word = valid_words[rand(valid_words.length + 1)].chomp
		@secret_word = @secret_word.split("")
		@secret_word_hidden = "-" * (@secret_word.length)
	end

	def eval_answer(input)
		return nil if input.nil?
		if session['secret_word_hidden'].include? "-"
			correct = false
			if session['guessed_letters'] == "nothing"
				session['guessed_letters'] = ''
			end
			session['guessed_letters'] += input
			session['secret_word'].each_with_index do |letter, index|
				if input.downcase == letter.downcase
					session['secret_word_hidden'][index] = letter
					correct = true
				end
			end
		end
		if correct == false
			session['guesses'] -= 1
		end
		unless session['secret_word_hidden'].include? "-"
			redirect to('/win')
		end
		if session['guesses'] == 0
			redirect to('/lose')
		end
	end
end