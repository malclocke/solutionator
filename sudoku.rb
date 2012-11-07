require 'matrix'
module Sudoku

  class SolutionError     < StandardError ; end
  class InvalidSyntax     < SolutionError ; end
  class BlankCells        < SolutionError ; end
  class DuplicateInRow    < SolutionError ; end
  class DuplicateInColumn < SolutionError ; end
  class DuplicateInBlock  < SolutionError ; end

  class Puzzle

    attr_accessor :matrix

    def initialize(input)
      validate(input)
      build_matrix(input).inspect
    end

    def validate(input)
      if input.length != 81
        raise InvalidSyntax, "Solution must be 81 characters long, is #{input.length}"
      end
      if input =~ /[^0-9]/
        raise InvalidSyntax, "Solution must only contain the characters 0-9"
      end
    end

    def build_matrix(input)
      a = (0..8).map {|i| input[i*9, 9].split(//).map(&:to_i)}
      @matrix = Matrix[*a]
    end

    def solved!
      matrix.to_a.each_with_index do |row, index|
        if row.include?(0)
          raise BlankCells, "row #{index} has blank cells"
        end
        if row.uniq.length != 9
          raise DuplicatesInRow, "row #{index} has duplicates"
        end
      end
      matrix.transpose.to_a.each_with_index do |column, index|
        if column.uniq.length != 9
          raise DuplicateInColumn, "column #{index} has duplicates"
        end
      end
      (0..8).each_with_index do |n, index|
        a = block(n).to_a.flatten
        if a.uniq.length != 9
          raise DuplicateInBlock, "block #{index} has duplicates"
        end
      end
      return true
    end

    # +-+-+-+
    # |0|1|2|
    # +-+-+-+
    # |3|4|5|
    # +-+-+-+
    # |6|7|8|
    # +-+-+-+
    def block(number)
      x = (number / 3)*3
      y = (number % 3)*3
      matrix.minor(x..(x+2),y..(y+2))
    end

    def to_s
      'OK'
    end

  end

end
