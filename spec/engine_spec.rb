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
        subject.fetch_tile do |x,y|
          {x:x, y:y}
        end
      end

      it "updates tile in the viewport" do
        subject.viewport.should_receive(:update_tile).with(0,0, {x:4,y:2})
        subject.viewport.should_receive(:update_tile).with(1,0, {x:5,y:2})
        subject.viewport.should_receive(:update_tile).with(0,1, {x:4,y:3})
        subject.viewport.should_receive(:update_tile).with(1,1, {x:5,y:3})

        subject.update 5,4
      end

      context "when cache enabled" do
        before do
          subject.cache_enabled = true
          subject.viewport.stub(:center_x => 0, :center_y => 0)
          subject.viewport.stub(:width => 1, :height => 1)
        end
        after do
          2.times { subject.update 0,0 }
        end

        it "fetches a tile only once" do
          subject.viewport.as_null_object

          fetch_tile = double("fetch_tile")
          fetch_tile.should_receive(:call).with(0,0).once.and_return(Tile.new)
          subject.instance_variable_set :@fetch_tile, fetch_tile
        end

        it "cached tile is same as fetched tile" do
          tile = Tile.new
          fetch_tile = double("fetch_tile")
          fetch_tile.should_receive(:call).with(0,0).and_return tile
          subject.instance_variable_set :@fetch_tile, fetch_tile

          subject.viewport.should_receive(:update_tile).with(0, 0, tile).twice
        end
      end
    end
  end
end
