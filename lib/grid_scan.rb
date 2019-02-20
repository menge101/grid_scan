# frozen_string_literal: true

class GridScan
  attr_accessor :paths

  TARGET = 9
  OBSTACLE = 1
  CLEAR = 0

  def initialize(start, grid, target = nil)
    @start = start
    @target = target
    @grid = grid
    @height = @grid.length
    @width = @grid.first.length
    @paths = Hash.new(nil)
  end

  def clear?(position)
    grid_value_eq(position, CLEAR)
  end

  # This method finds a path from the start coordinates to the end coordinates in the grid
  # @return [Array] Returns an array of 2-element arrays, specifying the coordinates visited to get to the target
  def find_path_length
    to_visit = [@start]

    (@height * @width).times do
      break if to_visit.empty?

      current = to_visit.shift
      @target = current if @target.nil? && target?(current)
      @paths[current], unvisited_neighbors = visit(current)
      to_visit.concat(unvisited_neighbors - to_visit)
    end

    raise(TargetNotFound, 'Target was not found') if @target.nil?
    raise(UnreachableTarget, 'Target is unreachable') unless @paths.key?(@target)

    @paths[@target]
  end

  def find_neighbors(position)
    x, y = position
    neighbors = []
    neighbors << [x - 1, y] if x > 0
    neighbors << [x + 1, y] if x < @width - 1
    neighbors << [x, y - 1] if y > 0
    neighbors << [x, y + 1] if y < @height - 1
    neighbors.select { |nbr| clear?(nbr) || target?(nbr) }
  end

  def obstacle?(position)
    grid_value_eq(position, OBSTACLE)
  end

  def target?(position)
    grid_value_eq(position, TARGET)
  end

  def visit(position)
    neighbors = find_neighbors(position)
    return 0, neighbors if neighbors.all? { |neighbor| @paths[neighbor].nil? }

    value = (neighbors.map { |nbr| @paths[nbr] }.compact.sort.first) + 1
    unvisited = neighbors.select { |nbr| @paths[nbr].nil? }
    [value, unvisited]
  end

  private

  def grid_value_eq(position, value)
    grid_value(*position) == value
  end

  def grid_value(y, x)
    @grid[y][x]
  end

  class TargetNotFound < StandardError; end
  class UnreachableTarget < StandardError; end
end
