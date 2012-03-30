module ApplicationHelper
  def image_url(path)
    %Q{#{image_path(path)}}
  end

  def fb_like_btn(href, send, layout)
    html = "<iframe src='http://www.facebook.com/plugins/like.php?app_id=239455349421651&amp;href=#{href}&amp;send=#{send}&amp;layout=#{layout}&amp;width=90&amp;show_faces=false&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21' scrolling='no' frameborder='0' style='border:none; overflow:hidden; width:90px; height:21px;' allowTransparency='true'></iframe>"
    html.html_safe
  end

  def controller_action
    "#{action_name.capitalize} #{controller_name.humanize.capitalize.singularize}"
  end

  def admin_url
    "/admin/projects/#{@project.name}/#{controller_name}/"
  end
end