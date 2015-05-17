require 'narray'

describe NLife::Helper do
  before do
    @rows = 8
    @cols = 8
  end

  context 'surround generation' do
    before do
      # classic surround
      @surround = NArray.int(@rows, @cols)
      @surround[(-1..1).to_a, (-1..1).to_a] = 1
      @surround[0, 0] = 0
    end

    it '.surround_from_block' do
      shape = @surround.shape.reverse
      got_surround = described_class.surround_from_block(*shape) do |row, col|
        [row, col].map(&:abs).max == 1 ? 1 : 0
      end
      expect(got_surround).to eq(@surround)
    end
  end

  context 'rule generation' do
    before do
      @rule_length = 8
      # ruler------012345678
      @birth    = '...X..X..'.split(//).map { |e| e == 'X' }
      @survival = '..XX.....'.split(//).map { |e| e == 'X' }
      @golly = 'B36/S23'
    end

    it '.golly_to_array' do
      expect(described_class.golly_to_array(@golly)).to eq([@birth, @survival])
    end

    it '.rule_from_arrays' do
      rule = described_class.rule_from_arrays(@birth, @survival)
      0.upto(@rule_length) do |i|
        expect(rule.call(0, i) > 0).to eq(@birth[i])
        expect(rule.call(1, i) > 0).to eq(@survival[i])
      end
    end

    it '.rule_from_golly' do
      expect(described_class).to respond_to(:rule_from_golly)
    end
  end
end
