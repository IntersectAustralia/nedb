module HtmlSelectorsHelpers
  # Maps a name to a selector. Used primarily by the
  #
  #   When /^(.+) within (.+)$/ do |step, scope|
  #
  # step definitions in web_steps.rb
  #
  def selector_for(locator)
    case locator

      when "the page"
        "html > body"

      # the main part of the page excluding header and nav bar
      when "the main content"
        ".content"

      when "the items area"
        "#items"

      when "species uncertainty checkboxes"
        "#display_species_uncertainty"

      when "the nav bar"
        "#nav_table"

      when "the country select"
        "#country_field"

      when "the replicates"
        "#reps"

      when "determination search results"
        "#search_results"

      # Add more mappings here.
      # Here is an example that pulls values out of the Regexp:
      #
      #  when /^the (notice|error|info) flash$/
      #    ".flash.#{$1}"

      # You can also return an array to use a different selector
      # type, like:
      #
      #  when /the header/
      #    [:xpath, "//header"]

      # This allows you to provide a quoted selector as the scope
      # for "within" steps as was previously the default for the
      # web steps:
      when /^"(.+)"$/
        $1

      else
        raise "Can't find mapping from \"#{locator}\" to a selector.\n" +
                  "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(HtmlSelectorsHelpers)
