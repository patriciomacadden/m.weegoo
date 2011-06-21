function updateSubCategory(category_id, sub_category_id, selected_sub_category)
{
  var url = "/update_sub_categories/" + ($(category_id).val() ? $(category_id).val() : -1);
  $(sub_category_id).find("option").remove().end();
  
  $.get(url, function(data)
  {
    $.each($.parseJSON(data), function(key, value)
    {
      selected_attr = (selected_sub_category == undefined || selected_sub_category != value.id) ? "" : " selected=\"selected\"";
      
      $(sub_category_id).append("<option value=\""+value.id+"\""+selected_attr+">"+value.name+"</option>");
    });
    
    select_txt = "";
    if (selected_sub_category != undefined)
    {
      select_txt = $(sub_category_id+" option[value="+selected_sub_category+"]").html();
    }
    $(sub_category_id).parent().children().children(".ui-btn-text").html(select_txt);
  });
}

// change event for venue form
$("#venue_category_id").live("change", function() { updateSubCategory("#venue_category_id", "#venue_sub_category_id"); });

$(window).load(function()
{
  if ($("#venue_sub_category_id").val() != undefined)
  {
    selected_sub_category = $("#venue_sub_category_id").val();
    updateSubCategory("#venue_category_id", "#venue_sub_category_id", selected_sub_category);
  }
});

// change event for event form
$("#event_category_id").live("change", function() { updateSubCategory("#event_category_id", "#event_sub_category_id"); });

$(window).load(function()
{
  if ($("#event_sub_category_id").val() != undefined)
  {
    selected_sub_category = $("#event_sub_category_id").val();
    updateSubCategory("#event_category_id", "#event_sub_category_id", selected_sub_category);
  }
});

$(window).load(function()
{
  $("div.input").each(function()
  {
    $(this).attr("data-role", "fieldcontain");
  });
});
