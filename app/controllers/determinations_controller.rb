class DeterminationsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_people_and_herbaria

  load_and_authorize_resource :specimen
  load_and_authorize_resource :determination, :through => :specimen

  def show

  end

  def new
    @step = "determiners"
  end

  def edit
    @step = "determiners"
  end

  def create
    success_notice = 'Determination was successfully created.'
    @determination.legacy = false #any new records created will not be legacy
    create_or_update(success_notice, "new", true)
  end

  def update
    success_notice = 'Determination was successfully updated.'
    # update the attributes from the form, but don't save yet
    @determination.determiner_ids = []
    @determination.attributes = params[:determination]
    create_or_update(success_notice, "edit", false)
  end

  private

  def load_people_and_herbaria
    @all_people = Person.all
    @all_herbaria = Herbarium.all
  end

  def create_or_update(success_notice, action_to_render, is_new)
    @action_to_render = action_to_render
    if params[:step] == "determiners"
      if @determination.valid?
        @step = "plant_name"
        @field = "name"
        if !is_new
          prepare_existing_record(@determination)
        end
      else
        @step = "determiners"
      end
      # reset referenced flag after determiners step
      @determination.update_attribute(:referenced, %w(division class_name order_name family sub_family tribe genus species).all?{|attr| @determination[attr].present?})
      p @determination.referenced
      render :action => action_to_render

    else
      @step = "plant_name"

      if params[:do_search]
        # do the search and display the results
        @field = params[:level]
        @term = params[:term]

        if (@term.strip == "")
          flash[:alert] = "Please enter a search term."
          if !is_new
            prepare_existing_record(@determination)
          end
        else
          @species = Species.search_in_field(@field, @term)
          @search_results = true
          @fields_to_show = Determination.get_fields_to_include_for_level(@field)
        end
        render :action => action_to_render

      elsif params[:det_action] == "select"
              # display the selected item
        @field = params[:selected_level]
        @term = params[:term]

        prepare_selected_item(@field)

        render :action => action_to_render
      else
        #save the record
        @field = params[:selected_level]
        save_record(action_to_render, is_new, success_notice)
      end
    end

  end

  def prepare_existing_record(det)
    @field = det.get_current_level

    if @field == "name"
      name = @determination.species
      genus = @determination.genus
      @species = Species.find_by_name_and_genus(name, genus)
      @subspecies = @species.nil? ? nil : @species.subspecies
      @varieties = @species.nil? ? nil : @species.varieties
      @forms = @species.nil? ? nil : @species.forms

      if !@determination.sub_species.blank? && !@species.nil?
        selected_subsp = @species.subspecies.where(:subspecies => @determination.sub_species).first
        if selected_subsp
          @determination.sub_species = selected_subsp.id
        end
      end
      if !@determination.variety.blank? && !@species.nil?
        selected_var = @species.varieties.where(:variety => @determination.variety).first
        if selected_var
          @determination.variety = selected_var.id
        end
      end
      if !@determination.form.blank? && !@species.nil?
        selected_form = @species.forms.where(:form => @determination.form).first
        if selected_form
          @determination.form = selected_form.id
        end
      end
    end

    if !@field.blank?
      @selected_specimen = true
      @fields_to_show = Determination.get_fields_to_include_for_level(@field)
    end

  end

  def prepare_selected_item(level)
    @determination.set_determining_at_level(level)

    if level == "name"
      name = @determination.species
      genus = @determination.genus
      @species = Species.find_by_name_and_genus(name, genus)
      @determination.species_authority = @species.authority
      @subspecies = @species.subspecies
      @varieties = @species.varieties
      @forms = @species.forms
    end

    @selected_specimen = true
    @fields_to_show = Determination.get_fields_to_include_for_level(@field)
  end

  def save_record(action_to_render, is_new, success_notice)
    @determination.set_determining_at_level(@field)
    if @field == "name"
      set_subspecies_variety_and_form
    end

    if is_new
      if @determination.save
        redirect_to(@specimen, :notice => success_notice)
      else
        render :action => action_to_render
      end
    else
      if @determination.save
        redirect_to(@specimen, :notice => success_notice)
      else
        render :action => action_to_render
      end
    end
  end

  def get_subspecies_safe(subsp_id)
    return Subspecies.find(subsp_id)
  rescue ActiveRecord::RecordNotFound
    return nil
  end

  def get_variety_safe(var_id)
    return Variety.find(var_id)
  rescue ActiveRecord::RecordNotFound
    return nil
  end

  def get_form_safe(form_id)
    return Form.find(form_id)
  rescue ActiveRecord::RecordNotFound
    return nil
  end

  def set_subspecies_variety_and_form
    subsp_id = @determination.sub_species
    if subsp_id and !subsp_id.empty?
      subsp = get_subspecies_safe(subsp_id)
      @determination.sub_species = subsp.nil? ? "" : subsp.subspecies
      @determination.sub_species_authority = subsp.nil? ? "" : subsp.authority
    else
      @determination.sub_species = ""
      @determination.sub_species_authority = ""
    end

    var_id = @determination.variety
    if var_id and !var_id.empty?
      var = get_variety_safe(var_id)
      @determination.variety = var.nil? ? "" : var.variety
      @determination.variety_authority = var.nil? ? "" : var.authority
    else
      @determination.variety = ""
      @determination.variety_authority = ""
    end

    form_id = @determination.form
    if form_id and !form_id.empty?
      form = get_form_safe(form_id)
      @determination.form = form.nil? ? "" : form.form
      @determination.form_authority = form.nil? ? "" : form.authority
    else
      @determination.form = ""
      @determination.form_authority = ""
    end
  end
end