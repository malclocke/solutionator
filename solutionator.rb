require 'sinatra'
require './sudoku'

get '/' do
  @puzzles = []
  erb :index
end

post '/check' do
  @solutions = params[:solutions]
  puts @solutions
  @puzzles = []
  @solutions.lines.each do |solution|
    puts "'#{solution}'"
    begin
      puzzle = Sudoku::Puzzle.new(solution.strip)
      puzzle.solved!
      @puzzles << puzzle
    rescue Sudoku::SolutionError => e
      @puzzles << e
    end
  end
  erb :index
end
