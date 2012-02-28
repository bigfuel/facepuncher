jQuery ->
  # Admin - Project dashboard
  $(".table tr").hover (->
    $("td .actions", this).show()
  ), ->
    $("td .actions", this).hide()

  # Buttons
  $(".delete").bind("ajax:beforeSend", ->
    $(this).parents("table").siblings(".alert").empty()
  ).bind("ajax:success", ->
    $(this).parents("tr").remove()
  ).bind "ajax:error", ->
    $(this).parents("table").siblings(".alert").append "An Error has occured. Please try again."

  $(".approve").live "click", ->
    $(this).bind("ajax:beforeSend", ->
      $(this).parents("table").siblings(".alert").empty()
    ).bind("ajax:success", ->
      link = $(this).attr("href")
      newLink = link.replace("approve", "deny")
      $(this).text("Deny").removeClass("approve").addClass("deny").attr("href", newLink).siblings().remove()
    ).bind "ajax:error", ->
      $(this).parents("table").siblings(".alert").append "An Error has occured. Please try again."

  $(".deny").live "click", ->
    $(this).bind("ajax:beforeSend", ->
      $(this).parents("table").siblings(".alert").empty()
    ).bind("ajax:success", ->
      link = $(this).attr("href")
      newLink = link.replace("deny", "approve")
      $(this).text("Approve").removeClass("deny").addClass("approve").attr("href", newLink).siblings().remove()
    ).bind "ajax:error", ->
      $(this).parents("table").siblings(".alert").append "An Error has occured. Please try again."

  $(".go-live").live "click", ->
    $(this).bind("ajax:beforeSend", ->
      $(this).parents("table").siblings(".alert").empty()
    ).bind("ajax:success", ->
      link = $(this).attr("href")
      newLink = link.replace("enable", "disable")
      $(this).text("Disable").removeClass("enable").addClass("disable").attr "href", newLink
      $(this).parents("tr").removeClass("disabled").addClass "enabled"
    ).bind "ajax:error", ->
      $(this).parents("table").siblings(".alert").append "An Error has occured. Please try again."

  $(".activate").live "click", ->
    $(this).bind("ajax:beforeSend", ->
      $(this).parents("table").siblings(".alert").empty()
    ).bind("ajax:success", ->
      link = $(this).attr("href")
      newLink = link.replace("activate", "deactivate")
      $(this).text("Deactivate").removeClass("activate").addClass("deactivate").attr "href", newLink
      $(this).parents("tr").removeClass("inactive").addClass "active"
    ).bind "ajax:error", ->
      $(this).parents("table").siblings(".alert").append "An Error has occured. Please try again."

  $(".deactivate").live "click", ->
    $(this).bind("ajax:beforeSend", ->
      $(this).parents("table").siblings(".alert").empty()
    ).bind("ajax:success", ->
      link = $(this).attr("href")
      newLink = link.replace("deactivate", "activate")
      $(this).text("Activate").removeClass("deactivate").addClass("activate").attr "href", newLink
      $(this).parents("tr").removeClass("active").addClass "inactive"
    ).bind "ajax:error", ->
      $(this).parents("table").siblings(".alert").append "An Error has occured. Please try again."

  # Admin - Poll form
  $.template "newChoice", "<p class=\"choice\"> <input id=\"poll_choices_attributes_${count}_content\" name=\"poll[choices_attributes][${count}][content]\" size=\"30\" type=\"text\"> <a href=\"#\" class=\"btn remove\"><i class=\"icon-minus\"></i></a> <input id=\"poll_choices_attributes_${count}_image\" name=\"poll[choices_attributes][${count}][image]\" type=\"file\"></p>"

  $("a.add").live "click", (e) ->
    choice = count: $(".choice").size() + 1
    $.tmpl("newChoice", choice).appendTo "#choices .controls"

  $("a.remove").live "click", (e) ->
    $(this).parents(".choice").remove()

  # Admin - Event form
  $(".import").click (e) ->
    e.preventDefault
    $(".import-csv").toggle()

  $(".locate").click (e) ->
    e.preventDefault()
    form = $("#" + $(this).attr("data-form-id"))
    address = $("#event_location_attributes_address", form).val()
    latitude = $("#event_location_attributes_latitude", form)
    longitude = $("#event_location_attributes_longitude", form)
    callback = ((loc) ->
      latitude.val loc.lat()
      longitude.val loc.lng()
      form.submit()
    )
    fp.maps.find address, callback

  $(".location_update_form").bind("ajax:beforeSend", ->
    $(".locate", this).html "Loading..."
  ).bind("ajax:success", (evt, data, status, xhr) ->
    event = $("#event_" + data._id)
    $(".event-latitude", event).html data.location.latitude
    $(".event-longitude", event).html data.location.longitude
  ).bind("ajax:error", (evt, data, status, xhr) ->
    alert "An error occured getting the coordinates for this event."
  ).bind "ajax:complete", (evt, data, status, xhr) ->
    $(".locate", this).html "Locate"

  $("#submit-event").click (e) ->
    address = $("#location_address").val()
    if address is ""
      alert "You must provide an address!"
      return
    callback = ((loc) ->
      $("#location_latitude").val loc.lat()
      $("#location_longitude").val loc.lng()
      $(".event-form").submit()
    )
    fp.maps.find address, callback
    e.preventDefault()

  # Datetime picker plugin
  $(".datetimepicker").datetimepicker
    ampm: true
    dateFormat: "yy-mm-dd"
    timeFormat: "hh:mm:ss TT"