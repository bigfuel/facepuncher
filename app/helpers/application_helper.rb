module ApplicationHelper
  def image_url(path)
    %Q{#{image_path(path)}}
  end

  def fb_like_btn(href, send, layout)
    html = "<iframe src='http://www.facebook.com/plugins/like.php?app_id=239455349421651&amp;href=#{href}&amp;send=#{send}&amp;layout=#{layout}&amp;width=90&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21' scrolling='no' frameborder='0' style='border:none; overflow:hidden; width:90px; height:21px;' allowTransparency='true'></iframe>"
    html.html_safe
  end

  def sort_by(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) && "current #{sort_direction}"
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {sort: column, direction: direction}, {class: css_class}
  end

  def controller_action
    "#{action_name.capitalize} #{controller_name.capitalize.singularize}"
  end
end