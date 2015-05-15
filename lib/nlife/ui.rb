require 'curses'

require_relative "./game.rb"

module NLife
  class UI
    RENDER_DEAD = " "
    RENDER_LIVE = "\u2588"

    def initialize
      init_settings
      init_window
      init_life
    end

    def init_window
      Curses.init_screen
      Curses.curs_set(0)
      Curses.noecho
      @window_lines = Curses.lines
      @window_cols = Curses.cols
      @window = Curses::Window.new(@window_lines, @window_cols, 0, 0)
      @window.box("|", "-")
      @window.timeout = 0
    end

    def init_life
      @life = NLife::Game.new(@window_lines - 2, @window_cols - 2) # padding
      @life.seed
    end

    def init_settings
      @pause = false
      @delay = 0.04
    end

    def start
      loop do
        break unless dispatch_key(@window.getch)
        step
        render
        sleep(@delay)
      end
    end

    def dispatch_key(key)
      case key
      when "p" then @pause = !@pause
      when "s" then @life.seed
      when "q" then return false
      end
      return true
    end

    def step
      unless @pause
        @life.step
      end
    end

    def render
      @life.rows.times do |i|
        string = ""
        @life.cols.times do |j|
          string += @life.state[j, i] > 0 ? RENDER_LIVE : RENDER_DEAD
        end
        @window.setpos(i + 1, 1)
        @window.addstr(string)
      end
    end
  end
end
