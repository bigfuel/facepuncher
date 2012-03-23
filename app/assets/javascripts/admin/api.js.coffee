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

  page_number = 1
  per_page_count = 10

  loadFeed = (project, page_number, per_page_count) ->
    feed_name = $(".tmpl").attr "data-feed-name"
    page_number = parseInt(page_number, 10)
    $.getJSON("/api/project/" + project + "/feeds/" + feed_name + ".json", 
      name: feed_name
      page: page_number
      per_page: per_page_count
      , (data) ->
        $.tmpl("newEntry", data).appendTo ".table"
    )

  if project_name
    if action_name is "index"
      loadIndex project_name, model_name
    else if action_name is "show"
      loadShow project_name, model_name, obj_id
    else 
      loadFeed project_name, page_number, per_page_count if action_name is "feed"