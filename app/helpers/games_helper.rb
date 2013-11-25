module GamesHelper
  def diamond_icon base, name
    active = base.present? && base != 0 ? "active" : ""
    '<span class="diamond '+name+' '+active+'" ></span>'.html_safe
  end
end
