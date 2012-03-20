require 'spec_helper'

module UT
  describe Engine do
    describe "#initialize" do
      subject do
        Engine.new :viewport => :viewport,
                   :resolve_tile => :resolve_tile
      end

      its(:viewport) { should == :viewport }
    end

    describe "#update" do
      subject { Engine.new :viewport => double(Viewport) }
      before do
        subject.viewport.stub(:center_x => 1, :center_y => 2)
        subject.viewport.stub(:width => 2, :height => 2)
        subject.resolve_tile do |x,y|
          {x:x, y:y}
        end
      end
      after do
        subject.update 5,4
      end

      it "updates the tiles in the viewport" do
        subject.viewport.should_receive(:update_tile).with(0,0, {x:4,y:2})
        subject.viewport.should_receive(:update_tile).with(1,0, {x:5,y:2})
        subject.viewport.should_receive(:update_tile).with(0,1, {x:4,y:3})
        subject.viewport.should_receive(:update_tile).with(1,1, {x:5,y:3})

      end
    end
  end
end
