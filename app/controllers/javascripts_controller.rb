class JavascriptsController < ApplicationController
  def dynamic_states
    @states = State.order(:name)
    @botanical_divisions = BotanicalDivision.order(:name)
  end

  def determinations
  end

  def specimens
  end
end