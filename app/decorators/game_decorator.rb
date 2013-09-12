class GameDecorator < Draper::Decorator
  delegate_all

  def status_tag
    if object.in_progress?
      ('<span class="label label-info">' + I18n.t('game.in_progress') + '</span>').html_safe
    else
      ('<span class="label">' + I18n.t('game.scheduled') + '</span>').html_safe
    end
  end
end
