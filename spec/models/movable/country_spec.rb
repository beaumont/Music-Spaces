require File.dirname(__FILE__) + '/../../spec_helper'

describe Movable::Country do

  describe "in general" do
    
    it "should update properly from Movable" do
      Movable::Version.data_cache = ''
      Movable::Country.delete_all
      Movable::Country.current.size.should == 0

      # FIXME: Don't spec remote services, mock them.
      # Movable::Country.update_data_from_movable!
      # Movable::Country.current.size.should > 0
      # Movable::Country.current.first.operators.size.should > 0
    end
    
    it "should skip update when no change in Movable data" do
      pending("spec needs to be written")
    end
    
  end
  
end