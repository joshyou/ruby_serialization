require "yaml"

class Hangman
    def initialize
      @word = get_word
      @error_count = 0
      @display_string = ""
      @guessed = 0
      @guesses = ""
      @wrong_guesses = ""
      
      @word.length.times do
        @display_string += "_ "
      end
    end
      
    def get_word
      words = File.readlines("5desk.txt")
      random_word = words[rand(words.length)].downcase
      while random_word.length > 13 || random_word.length < 6
        random_word = words[rand(words.length)].downcase
      end
      random_word = random_word[0...random_word.length - 1]
      random_word
    end

    def save_game
      yaml = YAML::dump({:word => @word, :display_string => 
          @display_string, :guessed => @guessed, :guesses => @guesses,
          :wrong_guesses => @wrong_guesses, :error_count => @error_count})
      File.open("saved.yaml", "w") do |f|
          f.puts yaml
      end
      puts "game saved"
    end

    def load_game
      savefile = File.open("saved.yaml")
      yaml = savefile.read()
      savefile.close
      saved_game = YAML::load(yaml)
      puts "game loaded"
      @word = saved_game[:word]
      @display_string = saved_game[:display_string]
      @guessed = saved_game[:guessed]
      @guesses = saved_game[:guesses]
      @wrong_guesses = saved_game[:wrong_guesses]
      @error_count = saved_game[:error_count]
    end
    
    def begin_game
      puts "load previous game? y/n"
      input = gets.chomp
      if input == "y"
        load_game
      end
      play
    end
    
    def play
        
      while @error_count < 7
        puts @display_string
        puts "incorrect guesses: #{@wrong_guesses}"
        puts "\n" + "guess a letter (#{7 - @error_count} mistakes remaining)"
        puts "enter save to save game"
        guess = gets.chomp.downcase
          
        if guess == "save"
          save_game
          next
        end
          
        while guess.length != 1
          puts "invalid input, must be one character"
          guess = gets.chomp.downcase
          break unless guess.length != 1
        end

        while @guesses.include? (guess)
          puts "already guessed this letter, guess again"
          guess = gets.chomp.downcase
          break unless !@guesses.include? (guess)
        end

        @guesses += guess  

        if @word.include? (guess)
          puts "guess was correct"
          @word.split("").each_with_index do |letter, index|
            if letter == guess
              @display_string[(index) * 2] = guess
              @guessed += 1
            end
          end
        else
          @error_count += 1
          @wrong_guesses += guess
          puts "guess was incorrect"
        end

        if @guessed == @word.length
          puts "you have won"
          return 
        end
      end
      puts "you have lost"
      puts "the word was #{@word}"
    end

end

my_game = Hangman.new
my_game.begin_game