// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery.numeric

$(document).ready(function()
{
    $("#person_herbarium_id").select2();
    $("#specimen_collector_id").select2();
    $("#secondary_collector_ids_").select2({
        placeholder: "Select a collector",
        allowClear: true
    });
    $("#confirmation_confirmer_id").select2();
    $("#confirmation_confirmer_herbarium_id").select2();
    $("#determiner_ids").select2({
        placeholder: "Select a determiner",
        allowClear: true
    });
    // check if the element is present before applying the plugin
    if (document.getElementById("#determination_determiner_herbarium_id"))
    {
        $("#determination_determiner_herbarium_id").select2();
    }

    $("#specimen_country").select2();
    $("div.select2-container:eq(2)").attr("id", "country_container");
    $("select#specimen_state").hide(); //always hide the original select box

    $("select#specimen_state").select2();
    $("div.select2-container:eq(3)").attr("id", "state_container");

    $("select#specimen_botanical_division").select2();
    $("div.select2-container:eq(4)").attr("id", "botanical_container");
    $("select#specimen_botanical_division").hide();

    // advanced search autocompletes
    $("#search_determinations_tribe_contains").select2();
    $("#search_determinations_variety_contains").select2();
    $("#search_determinations_sub_species_contains").select2();
    $("#search_determinations_species_contains").select2();
    $("#search_determinations_genus_contains").select2();
    $("#search_determinations_sub_family_contains").select2();
    $("#search_determinations_division_contains").select2();
    $("#search_determinations_class_name_contains").select2();
    $("#search_determinations_order_name_contains").select2();
    $("#search_determinations_family_contains").select2();

    $("#search_collector_id_equals").select2();
    $("#search_confirmations_confirmer_id_equals").select2();
    $("#search_determinations_determiners_id_equals").select2();
    $("#search_secondary_collectors_id_equals").select2();
    $("#search_determinations_species_uncertainty_contains").select2();
    $("#search_determinations_subspecies_uncertainty_contains").select2();
    $("#search_determinations_variety_uncertainty_contains").select2();
    $("#search_determinations_form_uncertainty_contains").select2();
    $("#search_replicates_id_equals").select2();

    $('#set_accession').click(function(e) {
        var disabled = $('#specimen_id').attr('readonly');
        if(disabled) {
            $('#specimen_id').removeAttr('readonly');
            $('#specimen_id').val('');
        }
        e.preventDefault();
    });
});

$(function() {
  // Check/Uncheck all checkbox - applies to all checkboxes on the page
  $('#checkAll').click(
     function()
     {
        $("INPUT[type='checkbox']").attr('checked', $('#checkAll').is(':checked'));   
     }
  ) 
});

// Google analytics
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-16667092-11']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();


