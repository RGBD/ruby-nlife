require "narray"

module NLife
  module Helper
    def self.surround_from_block(rows, cols)
      result = NArray.int(cols, rows)
      result.shape[1].times do |row|
        result.shape[0].times do |col|
          result[col, row] = yield((row + rows / 2) % rows - rows / 2,
                                   (col + cols / 2) % cols - cols / 2) ? 1 : 0
        end
      end
      result
    end

    # constructs rules from two arrays, birth/survival densities
    def self.rule_from_arrays(birth, survival)
      proc do |state, density|
        birth[density.round] || state > 0 && survival[density.round] ? 1 : 0
      end
    end

    # constructs rules from string, describing birth/survival densities
    def self.rule_from_golly(string)
      match = /^B([0-8]*)\/S([0-8]*)$/.match(string)
      Raise ArgumentError "Wrong input format" unless match
      birth = Array.new(9, false)
      survival = Array.new(9, false)
      match[1].split(//).map(&:to_i).each { |i| birth[i] = true }
      match[2].split(//).map(&:to_i).each { |i| survival[i] = true }
      return rule_from_arrays(birth, survival)
    end
  end
end
