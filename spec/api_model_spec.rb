class FailingModel < Maglev::Model
  # returns a 400 when you don't have a proper token
  root "http://graph.facebook.com/btaylor/friends"

  collection_path ""
  member_path "/:id"
end

describe "The requests stuff" do
  it "should return nil upon bad requests" do
    @ran_find_all = false
    @ran_find = false
    FailingModel.find_all do |results, response|
      results.should == nil
      @ran_find_all = true
      resume
    end

    wait_max 5.0 do
      @ran_find_all.should == true

      FailingModel.find("1") do |result, response|
        result.should == nil
        @ran_find = true
        resume
      end

      wait_max 5 do
        @ran_find.should == true
      end
    end
  end
end