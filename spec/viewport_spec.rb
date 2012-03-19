require 'spec_helper'

module UT
  describe Viewport do
    let(:renderer) { double("renderer") }
    describe '#initialize' do
      context 'with options' do
        let(:options) { [:renderer, :left, :top, :width, :height] }
        subject { Viewport.new options.reduce({}){ |h,x| h[x]=x;h } }

        it "assigns the options" do
          options.each do |option|
            (subject.send option).should == option
          end
        end
      end
    end

    describe "#center_x" do
      it "returns half width rounded down" do
        subject.width = 3
        subject.center_x.should == 1
      end
    end

    describe "#center_y" do
      it "returns half height rounded down" do
        subject.height = 3
        subject.center_y.should == 1
      end
    end

    describe "#render_width" do
      before do
        subject.width = 2
        subject.renderer = renderer
        renderer.stub(:tile_size => 3)
      end

      it "computes the width required by the renderer to render the tiles" do
        subject.render_width.should == 6
      end
    end

    describe "#render_height" do
      before do
        subject.height = 2
        subject.renderer = renderer
        renderer.stub(:tile_size => 3)
      end

      it "computes the height required by the renderer to render the tiles" do
        subject.render_height.should == 6
      end
    end

    describe "#update_tile" do
      it "updates the tile at the specified location" do
        tile = double(Tile)
        subject.update_tile 1, 1, tile
        (subject.instance_variable_get :@tiles) == {[1,1] => tile}
      end

      context "when a tile is overriden" do
        before do
          tile1 = double(Tile, :id => 1)
          @tile2 = double(Tile, :id => 2)
          subject.update_tile 1, 1, tile1
          subject.update_tile 1, 1, @tile2
        end

        it "replaces the tile" do
          (subject.instance_variable_get :@tiles) == {[1,1] => @tile2}
        end
      end
    end

    describe "#draw" do
      before do
        subject.left = 1
        subject.top = 2
        renderer.stub(:tile_size => 3)
        subject.renderer = renderer
        @tile1 = double(Tile, :id => 1)
        @tile2 = double(Tile, :id => 2)
        subject.update_tile 0, 0, @tile1
        subject.update_tile 1, 1, @tile2
      end

      it "tells the renderer to draw each tile" do
        renderer.should_receive(:render).with(@tile1, 1, 2)
        renderer.should_receive(:render).with(@tile2, 4, 5)

        subject.draw
      end
    end
  end
end
