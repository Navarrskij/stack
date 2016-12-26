require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET show" do
    it "return status success" do
      get :show
      expect(response).to be_success
    end
  end
end
