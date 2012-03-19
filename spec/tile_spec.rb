require 'spec_helper'

module UT
  describe Tile do
    describe '#initialize' do
      context 'without args' do
        its(:glyph) { should == NULLGLYPH }
        its(:foreground) { should == DEFAULT_FOREGROUND }
        its(:background) { should == DEFAULT_BACKGROUND }
      end

      context 'with args' do
        subject do
          Tile.new :glyph => "a",
            :foreground => Gosu::Color::RED,
            :background => Gosu::Color::GREEN
        end

        its(:glyph) { should == "a" }
        its(:foreground) { should == Gosu::Color::RED }
        its(:background) { should == Gosu::Color::GREEN }
      end
    end

    describe '#clone' do
      let(:tile) do
        Tile.new :glyph => "a",
                 :foreground => Gosu::Color::RED,
                 :background => Gosu::Color::GREEN
      end
      subject { tile.clone }

      its(:glyph) { should == tile.glyph }
      its(:foreground) { should == tile.foreground }
      its(:background) { should == tile.background }
    end
  end
end
