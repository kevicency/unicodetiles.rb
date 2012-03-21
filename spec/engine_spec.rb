require 'spec_helper'

module UT
  describe Engine do
    describe "#initialize" do
      subject do
        Engine.new :viewport => :viewport,
                   :fetch_tile => :fetch_tile
      end

      its(:viewport) { should == :viewport }
    end

    describe "#update" do
      subject { Engine.new :viewport => double(Viewport) }
      before do
        subject.viewport.stub(:center_x => 1, :center_y => 2)
        subject.viewport.stub(:width => 2, :height => 2)
        subject.fetch_tile = lambda {|x,y| {x:x, y:y}}
      end

      it "updates tile in the viewport" do
        subject.viewport.should_receive(:update_tile).with(0,0, {x:4,y:2})
        subject.viewport.should_receive(:update_tile).with(1,0, {x:5,y:2})
        subject.viewport.should_receive(:update_tile).with(0,1, {x:4,y:3})
        subject.viewport.should_receive(:update_tile).with(1,1, {x:5,y:3})

        subject.update 5,4
      end

    end

    describe "#fetch_tile" do
      context "when cache is enabled" do
        before do
          subject.cache_enabled = true
        end

        it "fetches a tile only once" do
          fetch_double = double("fetch")
          fetch_double.should_receive(:call).with(0,0).once.and_return Tile.new

          subject.fetch_tile = fetch_double

          2.times { subject.fetch_tile 0,0 }
        end

        it "cached tile is same as fetched tile" do
          tile = Tile.new
          fetch_double = double("fetch")
          fetch_double.should_receive(:call).with(0,0).and_return tile
          subject.fetch_tile = fetch_double

          subject.fetch_tile 0, 0
          subject.fetch_tile(0, 0).should == tile
        end
      end
    end
  end
end
