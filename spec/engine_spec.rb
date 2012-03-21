require 'spec_helper'

module UT
  describe Engine do
    let(:viewport) { double(Viewport) }
    subject do
      Engine.new :viewport => viewport
    end

    its(:viewport) { should == viewport }

    describe "#update" do
      before do
        viewport.stub(:center_x => 1, :center_y => 2)
        viewport.stub(:width => 2, :height => 2)
        def subject.fetch x, y
          {x:x, y:y}
        end
      end

      it "updates tile in the viewport" do
        subject.viewport.should_receive(:put_tile).with(0,0, {x:4,y:2})
        subject.viewport.should_receive(:put_tile).with(1,0, {x:5,y:2})
        subject.viewport.should_receive(:put_tile).with(0,1, {x:4,y:3})
        subject.viewport.should_receive(:put_tile).with(1,1, {x:5,y:3})

        subject.update 5,4
      end

    end

    describe "#fetch" do
      let(:source) { double("source") }
      before { subject.set_source = source}
      it "calls the source to fetch a tile" do
        source.should_receive(:call).with(1, 2).and_return

        subject.fetch 1, 2
      end

      it "returns the tile from the source" do
        tile = Tile.new
        source.stub(:call => tile)

        (subject.fetch 0, 0).should == tile
      end

      context "when cache is enabled" do
        before do
          subject.cache_enabled = true
        end

        it "fetches a tile only once" do
          source.should_receive(:call).with(0,0).once.and_return Tile.new

          2.times { subject.fetch 0,0 }
        end

        it "cached tile is same as fetched tile" do
          tile = Tile.new
          source.should_receive(:call).with(0,0).and_return tile

          subject.fetch 0, 0
          subject.fetch(0, 0).should == tile
        end
      end
    end
  end
end
