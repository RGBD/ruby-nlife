require "narray"
require "numru/fftw3"
include NumRu

require_relative "./helper.rb"

module NLife
  class Game
    attr_reader :state
    attr_accessor :density

    def initialize(rows, cols, surround = nil, rule = nil)
      @state = NArray.int(cols, rows)
      @density = NArray.int(cols, rows)
      surround ||= default_surround(rows, cols)
      @t_surround = FFTW3.fft(surround.to_f, -1) / surround.size
      @rule = rule || default_rule
    end

    def default_surround(rows, cols)
      return Helper.surround_from_block(rows, cols) do |row, col|
        [row.abs, col.abs].max == 1
      end
    end

    def default_rule
      return Helper.rule_from_golly("B3/S23")
    end

    def seed
      @state.shape[1].times do |row|
        @state.shape[0].times do |col|
          @state[col, row] = rand.round
        end
      end
    end

    def step
      calc_density
      calc_next_state
    end

    def calc_density
      t_state = FFTW3.fft(@state, -1)
      t_density = t_state * @t_surround
      @density = FFTW3.fft(t_density, 1).real.round
    end

    def calc_next_state
      @state.shape[1].times do |row|
        @state.shape[0].times do |col|
          @state[col, row] = @rule.call(@state[col, row], @density[col, row])
        end
      end
    end

    # use for debug only
    def print
      puts "#" * (@state.shape[0] + 2)
      @state.shape[1].times do |i|
        puts "#" + @state[true, i].each.map { |e| e > 0 ? "*" : " " }.join + "#"
      end
      puts "#" * (@state.shape[0] + 2)
    end

    def rows
      @state.shape[1]
    end

    def cols
      @state.shape[0]
    end
  end
end
