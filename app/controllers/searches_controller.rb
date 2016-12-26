class SearchesController < ApplicationController

  authorize_resource

  def show
    @results = Search.scan(params[:query].to_s, params[:context])
  end
end