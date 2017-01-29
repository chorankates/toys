#!/usr/bin/env ruby
## conway.rb - Conway's Game of Life

require 'curses'

module Conway

  class Cell

    attr_accessor :alive
    attr_reader :x, :y

    def initialize(x, y, alive)
      @x     = x
      @y     = y
      @alive = alive
    end

    def alive?
      @alive
    end

    def dead?
      ! self.alive?
    end

    def to_s
      self.alive? ? 'X' : ' '
    end

    def self.inspect
      sprintf('%s/%s:%s', @x, @y, self.to_s)
    end

    def kill
      @alive = false
    end

    def revive
      @alive = true
    end

    # +grid+ Hash representing a 2 dimensional array populated with Cells
    # return {:alive => Fixnum, :dead => Fixnum}
    def neighbors(grid)

      # TODO problem here is that rollover is not considered

      considered = Hash.new
      count = Hash.new(0)

      [self.x - 1, self.x, self.x + 1].each do |x|
        [self.y - 1, self.y, self.y + 1].each do |y|
          coords = sprintf('%s,%s', x, y)
          #puts sprintf('considering x[%s] y[%s]', x, y)
          unless grid.has_key?(x) and grid[x].has_key?(y)
            considered[coords] = :fizz
            next
          end
          #puts sprintf('actually looking at x[%s] y[%s]', x, y)

          candidate = grid[x][y]
          considered[coords] = candidate
          next if candidate.eql?(self) # don't want to count ourselves
          next if candidate.nil? # TODO not sure why this is necessary..
          candidate.alive? ? count[:alive] += 1 : count[:dead] += 1
        end
      end

      count
    end

  end

  class Game

    attr_accessor :cycles, :size_x, :size_y
    attr_reader :cells, :tick, :grid

    def initialize(config = {})
      @cycles = 5 # TODO should probably raise this default
      @size_x = 20
      @size_y = 50

      @cells = Array.new
      @tick  = 0
      @grid  = Hash.new

      @curses = config[:curses].nil? ? true : config[:curses]

      if @curses
        Curses.init_screen
        Curses.curs_set(0)
        @display = Curses::Window.new(@size_x + 5, @size_y + 5, 0, 0)
        @display.box('|', '-')
        @display.setpos(2, 2) # not sure
      end

      1.upto(@size_x).each do |x|
        @grid[x] = Hash.new
        1.upto(@size_y).each do |y|
          chance = rand(2).eql?(1) ? true : false
          cell   = Conway::Cell.new(x, y, chance)

          @grid[x][y] = cell
        end
      end

      1.upto(@cycles).each do |_i|
        if @curses
          @display.clear
          @display.addstr(self.to_s)
          @display.refresh
        else
          puts self.to_s
        end

        self.cycle
        sleep 5
      end

    end

    def count
      results = Hash.new(0)
      1.upto(@size_x).each do |x|
        1.upto(@size_y).each do |y|
          cell = @grid[x][y]

          results[:alive] += 1 if cell.alive?
          results[:dead]  += 1 if cell.dead?
        end
      end

      results
    end

    def cycle
      kill   = Array.new
      revive = Array.new
      unchanged = Array.new

      1.upto(@size_x).each do |x|
        1.upto(@size_y).each do |y|
          cell      = @grid[x][y]
          neighbors = cell.neighbors(@grid) # TODO this feels a bit weird

          if neighbors[:alive] < 2
            # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
            kill << cell
          elsif neighbors[:alive].eql?(2) or neighbors[:alive].eql?(3)
            # Any live cell with two or three live neighbours lives on to the next generation.

            # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            if neighbors[:alive].eql?(3)
              revive << cell
            else
              unchanged << cell
            end

          elsif neighbors[:alive] > 3
            # Any live cell with more than three live neighbours dies, as if by over-population.
            kill << cell
          else
            unchanged << cell
          end
        end
      end

      kill.each   { |k| k.kill }
      revive.each { |r| r.revive }

      @tick += 1
    end

    def to_s
      count = self.count
      str = ''
      str << sprintf('cycle[%s]: alive[%s] dead[%s]:%s', @tick, count[:alive], count[:dead], "\n")
      1.upto(@size_x).each do |x|
        1.upto(@size_y).each do |y|
          str << @grid[x][y].to_s
        end
        str << "\n"
      end

      str
    end

  end


end

g = Conway::Game.new({ :curses => ARGV.first.eql?('curses') })



