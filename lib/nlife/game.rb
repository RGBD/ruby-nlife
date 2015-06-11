require 'narray'
require 'numru/fftw3'
include NumRu

require_relative 'helper.rb'

module NLife
  # encapsulates game logic
  class Game
    attr_reader :state
    attr_reader :density

    def initialize(rows, cols, surround = nil, rule = nil)
      @state = NArray.float(cols, rows)
      @density = NArray.float(cols, rows)
      surround ||= default_surround(rows, cols)
      @fft_surround = FFTW3.fft(surround.to_f, -1) / surround.size
      @rule = rule || default_rule
    end

    def default_surround(rows, cols)
      Helper.surround_from_block(rows, cols) do |row, col|
        [row.abs, col.abs].max == 1 ? 1 : 0
      end
    end

    def default_rule
      Helper.rule_from_golly('B3/S23')
    end

    def reset
      @state.shape[1].times do |row|
        @state.shape[0].times do |col|
          @state[col, row] = 0.0
        end
      end
    end

    def seed
      @state.shape[1].times do |row|
        @state.shape[0].times do |col|
          @state[col, row] = rand.round
        end
      end
    end

    def step(count = 1)
      count.times do
        calc_density
        calc_next_state
      end
    end

    def calc_density
      t_state = FFTW3.fft(@state, -1)
      t_density = t_state * @fft_surround
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
      puts '#' * (@state.shape[0] + 2)
      @state.shape[1].times do |i|
        print_row(i)
      end
      puts '#' * (@state.shape[0] + 2)
    end

    # use for debug only
    def print_row(row)
      puts '#' + @state[true, row].each.map { |e| e > 0 ? '*' : ' ' }.join + '#'
    end

    def surround
      FFTW3.fft(@fft_surround, 1).real
    end

    def rows
      @state.shape[1]
    end

    def cols
      @state.shape[0]
    end
  end # class Game
end # module NLife
