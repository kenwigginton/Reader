class ExploreController < ApplicationController
  skip_before_filter :authorize_admin, :authorize_reader
  def index
    @supercategories = Supercategory.all
  end
end
