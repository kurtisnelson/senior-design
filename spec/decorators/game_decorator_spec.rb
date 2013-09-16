require 'spec_helper'

describe GameDecorator do
  subject{GameDecorator.decorate(game)}
  describe "#status_tag" do
    context "present game" do
      let(:game) { FactoryGirl.build(:game, start_date: Date.today - 1.day) }

      specify{subject.status_tag.should include(I18n.t('game.in_progress'))}
    end

    context "future game" do
      let(:game) { FactoryGirl.build(:game, start_date: Date.today + 1.day) }

      specify{subject.status_tag.should include(I18n.t('game.scheduled'))}
    end
  end
end
