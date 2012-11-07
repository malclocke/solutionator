#!/usr/bin/env ruby

require_relative 'sudoku'

line = 0
while solution = $stdin.gets
  line += 1
  begin
    puzzle = Sudoku::Puzzle.new(solution.strip)
    puzzle.solved!
    puts "%d OK" % [line]
  rescue Sudoku::SolutionError => e
    puts "%d:%s" % [line, e.to_s]
  end
end
