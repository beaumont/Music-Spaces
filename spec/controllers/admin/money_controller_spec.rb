require File.dirname(__FILE__) + '/../../spec_helper'

include AuthenticatedTestHelper

module Admin
  describe MoneyController do
    integrate_views

    before :each do
      
      Locale.set("en")
      @current_user = users(:chief)
      controller.stub!(:current_user).and_return(@current_user)
    end
    
    it "index should work" do
      get :index
      response.should be_success
      assigns(:contributions).should_not be_blank
    end

    def check_total(total, options)
        [:gross_amount_usd, :monetary_processor_fee_usd].each do |method|
          kind = method
          if options[kind]
            assert_in_delta options[kind], total.send(method).to_f, 0.01,
              "total should be %s (not %s)" % [options[kind], total.send(method)]
          end
        end
    end

    it "totals should work for index" do
      get :index
      check_total(assigns(:total), :gross_amount_usd => 9.00)
    end

    it "query filters should work for totals" do
      get :query, :query => {:payment_type => 'paypal'}
      check_total(assigns(:total), :gross_amount_usd => 9.00)
    end

    it "csv should work" do
      get :index, :format => 'csv'
      response.should be_success
      assigns(:contributions).should_not be_blank
    end

    it "fee in totals should be summed only over rows with it" do
      get :query
      check_total(assigns(:total), :fee => 2.15)
    end

    [[:currency, 3, -1], [:sender_name, 1, 'joe'], [:receiver_name, 2, 'chief'],
      [:payment_type, 0, -1]].each do |field, size, empty_value|

      it "'not specified' filter should work for %s param" % field do
        get :index, :format => 'csv', :query => {field => empty_value}
        assert_equal size, assigns(:contributions).size, 'found contributions count'
      end
    end
  end
end
