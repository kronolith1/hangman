class Hangman
  attr_accessor :rounds_played
  attr_reader :word_to_guess, :word_guessed

  def initialize
    @rounds_played = 0
    @word_to_guess = select_word_from_file
    @word_guessed = create_masked_word(@word_to_guess)
    @incorrect_guesses = []
  end

  def select_word_from_file
    selected_word = ""
    until (selected_word.length >= 5) && (selected_word.length <= 7)
      selected_word = File.read("5desk.txt").split.sample.downcase
    end
    selected_word
  end

  def create_masked_word(word)
    word.split("").map!{|x| "_"}
  end

  def update_screen(time)
    puts @word_guessed.join(" ")
    puts "Guesses remaining: #{8 - time.to_i}"
    puts "Wrong guesses: #{@incorrect_guesses}"
  end

  def process_guess(guess)
    if @word_to_guess.include? guess
      unmark_guess(guess)
    else
      @incorrect_guesses << guess
    end
  end

  def unmark_guess(guess)
    @word_to_guess.split("").each_with_index do |n, idx|
      if n == guess
        @word_guessed[idx] = n
      end
    end
  end
end


puts "Welcome to Hangman!"
puts ""

if File.exist?('lib/hangman.save')
  puts "Savegame found. Do you want to load (y/n)"
  answer = gets.chomp

  if answer == "y"
    puts hangman = File.open('lib/hangman.save') {|f| Marshal.load(f)}

    puts hangman.word_to_guess
  else
    hangman = Hangman.new()
  end
end

until hangman.rounds_played == 8
  guess = ""
  hangman.update_screen(hangman.rounds_played)
  print "Guess a letter! Type 'save' to save the current game "
  
  until guess != ""
    guess = gets.chomp
  end

  if guess.length == 1
    hangman.process_guess(guess)
  elsif guess == "save"
    File.open('lib/hangman.save', 'w+') {|f| Marshal.dump(hangman, f)}
    puts "Current game saved"
    redo
  else
    puts ""
    puts "Please fill in one letter per turn. Type the full word if you think you know it!"
    redo
  end

  if !hangman.word_guessed.include? "_"
    puts "Congrats! You won!"
    exit
  end

  hangman.rounds_played += 1
  puts ""
end

puts "I'm sorry, you lost. Try again!"
puts "The word you were looking for was: #{hangman.word_to_guess}"