class ItemsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :specimen
  load_and_authorize_resource :item, :through => :specimen

  def destroy
    # @specimen, @item are loaded by CanCan
    @item.destroy
    @specimen.update_attribute(:needs_review, cannot?(:create_not_needing_review, @specimen))
    redirect_to(@specimen, :notice => 'The item was successfully deleted.')
  end

end
