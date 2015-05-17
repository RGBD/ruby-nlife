require 'narray'

module NLife
  # miscellaneous functions for state/surround gereration
  module Helper
    module_function

    # surround is calculated for rectangle centered at (0, 0)
    def surround_from_block(rows, cols)
      result = NArray.float(cols, rows)
      result.shape[1].times do |row|
        result.shape[0].times do |col|
          result[col, row] = yield((row + rows / 2) % rows - rows / 2,
                                   (col + cols / 2) % cols - cols / 2)
        end
      end
      result
    end

    # constructs rules from two arrays: birth, survival densities
    def rule_from_arrays(birth, survival)
      unless birth.size == survival.size
        fail ArgumentError 'params sizes not match'
      end
      max_density = birth.size
      proc do |state, density|
        fail ArgumentError 'density too high' if density > max_density
        result = (state == 0 ? birth : survival)[density.round]
        result ? 1.0 : 0.0
      end
    end

    def golly_to_array(string)
      match = %r{^B([0-8]*)\/S([0-8]*)$}.match(string)
      raise ArgumentError 'wrong input format' unless match
      birth = (0..8).map { |i| match[1].include? i.to_s }
      survival = Array.new(9, false)
      match[2].split(//).map(&:to_i).each { |i| survival[i] = true }
      return birth, survival
    end

    # constructs rules from string, describing birth/survival densities
    def rule_from_golly(string)
      rule_from_arrays(*golly_to_array(string))
    end
  end
end
