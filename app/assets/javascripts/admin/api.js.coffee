jQuery ->
  $.template "newEntry", $(".tmpl tbody").html()

  project_name = $(".tmpl").attr "data-project"
  model_name = $(".tmpl").attr "data-model"
  action_name = $(".tmpl").attr "data-action"

  url = document.URL.split("/")
  obj_id = url[url.length-1]

  loadIndex = (project, model) -> 
    $.getJSON("/api/project/" + project + "/" + model + ".json", (data) ->
      $.each data, (i, item) ->
        $.each item, (i, j) ->
          $.tmpl("newEntry", j).appendTo ".table"
    ).success (data) ->
      $(".table").addClass("table-striped")

  loadShow = (project, model, obj_id) ->
    $.getJSON("/api/project/" + project + "/" + model + "/" + obj_id + ".json", (data) ->
      $.each data, (i, item) ->
        $.tmpl("newEntry", item).appendTo ".table"
    )

  if project_name and model_name
    if action_name is "index"
      loadIndex project_name, model_name
    else loadShow project_name, model_name, obj_id if action_name is "show"