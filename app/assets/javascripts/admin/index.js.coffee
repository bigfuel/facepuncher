jQuery ->
  # Admin - Project dashboard
  $(".table tr").hover (->
    $("td .actions", this).show()
  ), ->
    $("td .actions", this).hide()

  # Buttons
  removeAlert = ->
    $("#content .alert.alert-error").remove()

  addAlert = ->
    $("#content").prepend "<div class=\"alert alert-error\">An Error has occured. Please try again.</div>"

  $("#content").on("ajax:beforeSend", ".delete", (e) ->
    removeAlert()
  ).on("ajax:success", ".delete", (e) ->
    $(this).parents("tr").remove()
  ).on "ajax:error", ".delete", (e) ->
    addAlert()

  $("#content").on("ajax:beforeSend", ".deploy", (e) ->
    removeAlert()
  ).on("ajax:success", ".deploy", (e) ->
    $(this).addClass("disabled")
    $(this).removeAttr("href").removeAttr("data-confirm").removeAttr("data-remote")
  ).on "ajax:error", ".deploy", (e) ->
    addAlert()

  $("#content").on("ajax:beforeSend", ".activate", (e) ->
    removeAlert()
  ).on("ajax:success", ".activate", (e) ->
    newLink = $(this).attr("href").replace("activate", "deactivate")
    $(this).removeClass("activate").addClass("deactivate").attr("href", newLink).attr "title", "Deactivate"
    $(this).children("i").removeClass("icon-ok-circle").addClass("icon-ban-circle")
    $(this).parents("tr").removeClass("inactive")
  ).on "ajax:error", ".activate", (e) ->
    addAlert()

  $("#content").on("ajax:beforeSend", ".deactivate", (e) ->
    removeAlert()
  ).on("ajax:success", ".deactivate", (e) ->
    newLink = $(this).attr("href").replace("deactivate", "activate")
    $(this).removeClass("deactivate").addClass("activate").attr("href", newLink).attr "title", "Activate"
    $(this).children("i").removeClass("icon-ban-circle").addClass("icon-ok-circle")
    $(this).parents("tr").addClass "inactive"
  ).on "ajax:error", ".deactivate", (e) ->
    addAlert()

  $("#content").on("ajax:beforeSend", ".approve", (e) ->
    removeAlert()
  ).on("ajax:success", ".approve", (e) ->
    newLink = $(this).attr("href").replace("approve", "deny")
    $(this).removeClass("approve").addClass("deny").attr("href", newLink).attr "title", "Deny"
    $(this).children("i").removeClass("icon-ok-circle").addClass("icon-ban-circle")
    $(this).parents("tr").removeClass("inactive")
  ).on "ajax:error", ".approve", (e) ->
    addAlert()

  $("#content").on("ajax:beforeSend", ".deny", (e) ->
    removeAlert()
  ).on("ajax:success", ".deny", (e) ->
    newLink = $(this).attr("href").replace("deny", "approve")
    $(this).removeClass("deny").addClass("approve").attr("href", newLink).attr "title", "Approve"
    $(this).children("i").removeClass("icon-ban-circle").addClass("icon-ok-circle")
    $(this).parents("tr").addClass "inactive"
  ).on "ajax:error", ".deny", (e) ->
    addAlert()

  # $(".go-live").live "click", ->
  #   $(this).bind("ajax:beforeSend", ->
  #     removeAlert()
  #   ).bind("ajax:success", ->
  #     newLink = $(this).attr("href").replace("enable", "disable")
  #     $(this).text("Disable").removeClass("enable").addClass("disable").attr "href", newLink
  #     $(this).parents("tr").removeClass("disabled").addClass "enabled"
  #   ).bind "ajax:error", ->
  #     addAlert()

  # Admin - Poll form
  $.template "newChoice", "<p class=\"choice\"> <input id=\"poll_choices_attributes_${count}_content\" name=\"poll[choices_attributes][${count}][content]\" size=\"30\" type=\"text\"> <a href=\"#\" class=\"btn remove\"><i class=\"icon-minus\"></i></a> <input id=\"poll_choices_attributes_${count}_image\" name=\"poll[choices_attributes][${count}][image]\" type=\"file\"></p>"

  $("#content").on("click", ".add-poll-choice", (e) ->
    choice = count: $(".choice").size() + 1
    $.tmpl("newChoice", choice).appendTo "#choices .controls"
  )

  $("#content").on("click", ".remove-poll-choice", (e) ->
    $(this).parents(".choice").remove()
  )

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

  $("#content").on("ajax:beforeSend", ".location_update_form", (e) ->
    $(".locate", this).html "Loading..."
  ).on("ajax:success", ".location_update_form", (evt, data, status, xhr) ->
    event = $("#event_" + data._id)
    $(".event-latitude", event).html data.location.latitude
    $(".event-longitude", event).html data.location.longitude
  ).on("ajax:error", ".location_update_form", (evt, data, status, xhr) ->
    alert "An error occured getting the coordinates for this event."
  ).on "ajax:complete", ".location_update_form", (evt, data, status, xhr) ->
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