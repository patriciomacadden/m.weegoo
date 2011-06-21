function initialize_gmap(map_id)
{
  var latlng = new google.maps.LatLng(0, 0);
    
  var options = {
    zoom: 14,
    center: latlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  }
  
  var map = new google.maps.Map(document.getElementById(map_id), options);
  
  return map;
}

function create_and_add_marker_to_map_at_address(map, address, draggable)
{
  var geocoder = new google.maps.Geocoder();
  var marker;
  
  geocoder.geocode({ 'address': address }, function(results, status)
  {
    if (status == google.maps.GeocoderStatus.OK)
    {
      marker = create_marker(results[0].geometry.location, draggable);
      add_marker_to_map(map, marker);
      update_latlng_with_dragend(marker);
    }
  });
  
  return marker;
}

function update_latlng_with_dragend(marker)
{
  google.maps.event.addListener(marker, 'dragend', function()
  {
    $("#venue_latitude").val(marker.getPosition().lat());
    $("#venue_longitude").val(marker.getPosition().lng());
    
    $("#event_latitude").val(marker.getPosition().lat());
    $("#event_longitude").val(marker.getPosition().lng());
  });
}

function create_marker(latlng, draggable)
{
  draggable = (draggable == undefined) ? true : draggable;
  
  var marker = new google.maps.Marker(
  {
    position: latlng,
    draggable: draggable,
    animation: google.maps.Animation.DROP
  });
  
  return marker;
}

function add_marker_to_map(map, marker)
{
  map.setCenter(marker.getPosition());
  marker.setMap(map);
}

function create_info_window(content)
{
  return new google.maps.InfoWindow(
  {
    content: content
  });
}

function open_info_window_on_click(map, marker, info_window)
{
  google.maps.event.addListener(marker, 'click', function()
  {
    info_window.open(map, marker);
  });
}

// new functions

function create_marker_image(latlng, draggable, image)
{
  draggable = (draggable == undefined) ? true : draggable;
  
  var marker = new google.maps.Marker(
  {
    position: latlng,
    draggable: draggable,
    animation: google.maps.Animation.DROP,
    icon: image
  });
  
  return marker;
}

function create_and_add_marker_to_map_at_current_location(map, initial_address)
{
  var location;
  
  $.mobile.showPageLoadingMsg();
  
  // try W3C geolocation (preferred)
  if (navigator.geolocation)
  {
    navigator.geolocation.getCurrentPosition(function(position) {
      location = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
      marker = create_marker(location, false);
      add_marker_to_map(map, marker);
      update_latlng_with_dragend(marker);
      $.mobile.hidePageLoadingMsg();
    }, function() {
      create_and_add_marker_to_map_at_address(map, initial_address, false);
      $.mobile.hidePageLoadingMsg();
    });
  }
  // try Google Gears geolocation
  else if (google.gears)
  {
    var geo = google.gears.factory.create('beta.geolocation');
    geo.getCurrentPosition(function(position) {
      location = new google.maps.LatLng(position.latitude, position.longitude);
      marker = create_marker(location, false);
      add_marker_to_map(map, marker);
      update_latlng_with_dragend(marker);
      $.mobile.hidePageLoadingMsg();
    }, function() {
      create_and_add_marker_to_map_at_address(map, initial_address, false);
      $.mobile.hidePageLoadingMsg();
    });
  }
  // browser doesn't support geolocation
  else
  {
    create_and_add_marker_to_map_at_address(map, initial_address, false);
    $.mobile.hidePageLoadingMsg();
  }
}

function set_latitude_and_longitude(lat_id, lng_id, initial_address)
{
  var initial_lat, initial_lng;
  var geocoder = new google.maps.Geocoder();
  
  $.mobile.showPageLoadingMsg();
  
  geocoder.geocode({ 'address': initial_address }, function(results, status)
  {
    if (status == google.maps.GeocoderStatus.OK)
    {
      initial_lat = results[0].geometry.location.lat();
      initial_lng = results[0].geometry.location.lng();
    }
  });
  
  // try W3C geolocation (preferred)
  if (navigator.geolocation)
  {
    navigator.geolocation.getCurrentPosition(function(position) {
      $(lat_id).val(position.coords.latitude);
      $(lng_id).val(position.coords.longitude);
      $.mobile.hidePageLoadingMsg();
    }, function() {
      $(lat_id).val(initial_lat);
      $(lng_id).val(initial_lng);
      $.mobile.hidePageLoadingMsg();
    });
  }
  // try Google Gears geolocation
  else if (google.gears)
  {
    var geo = google.gears.factory.create('beta.geolocation');
    geo.getCurrentPosition(function(position) {
      $(lat_id).val(position.latitude);
      $(lng_id).val(position.longitude);
      $.mobile.hidePageLoadingMsg();
    }, function() {
      $(lat_id).val(initial_lat);
      $(lng_id).val(initial_lng);
      $.mobile.hidePageLoadingMsg();
    });
  }
  // browser doesn't support geolocation
  else
  {
    $(lat_id).val(initial_lat);
    $(lng_id).val(initial_lng);
    $.mobile.hidePageLoadingMsg();
  }
}