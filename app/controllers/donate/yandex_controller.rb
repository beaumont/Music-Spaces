class Donate::YandexController < Donate::BaseController
  def with_yandex
    @account_setting = AccountSetting.find(params[:account])
    @user = @account_setting.user
    @content = Content.find_by_id(params[:content])
  end
end