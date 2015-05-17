require 'narray'

describe NLife::Game do
  before do
    @rows = 8
    @cols = 8
    @game = described_class.new(@rows, @cols)
  end

  context 'classic defauts' do
    before do
      # classic surround
      @surround = NArray.int(@rows, @cols)
      @surround[(-1..1).to_a, (-1..1).to_a] = 1
      @surround[0, 0] = 0
      @rule_length = 8
      # ruler------012345678
      @birth    = '...X.....'.split(//).map { |e| e == 'X' }
      @survival = '..XX.....'.split(//).map { |e| e == 'X' }
      @rule = proc do |s, d|
        result = s == 0 ? @birth[d] : @survival[d]
        result ? 1 : 0
      end
    end

    it 'should have classic default surround' do
      expect(@game.surround.round).to eq(@surround)
    end

    it 'should have classic default rules' do
      game_rule = @game.instance_variable_get(:@rule)
      [0, 1].each do |s|
        0.upto(8) do |d|
          expect(@rule.call(s, d)).to eq(game_rule.call(s, d))
        end
      end
    end
  end # context 'classic defauts'

  context 'stepping' do
    before do
      # glider
      @state = NArray.to_na([
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0],
        [0, 0, 1, 1, 1, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ]).to_f
      @density = NArray.to_na([
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 1, 1, 0, 0, 0],
        [0, 0, 1, 1, 2, 1, 0, 0],
        [0, 1, 3, 5, 3, 2, 0, 0],
        [0, 1, 1, 3, 2, 2, 0, 0],
        [0, 1, 2, 3, 2, 1, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ]).to_f
      @next_state = NArray.to_na([
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 1, 0, 1, 0, 0, 0],
        [0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0, 0]
      ]).to_f
      @game.instance_variable_set(:@state, @state)
      @game.instance_variable_set(:@density, NArray.float(@rows, @cols))
    end # before

    it '.calc_density' do
      @game.send(:calc_density)
      expect(@game.instance_variable_get(:@density)).to eq(@density)
    end

    it '.calc_nest_state' do
      @game.instance_variable_set(:@density, @density)
      @game.send(:calc_next_state)
      expect(@game.instance_variable_get(:@state)).to eq(@next_state)
    end

    it '.step' do
      @game.step
      expect(@game.instance_variable_get(:@state)).to eq(@next_state)
    end
  end # context 'stepping'
end # describe NLife::Game
