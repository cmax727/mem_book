class SettingsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    puts 'create started!!!!!!'
    setting = Setting.new(params[:setting])
    setting.group_id = params[:group_id]
    setting.save!
    puts setting.auto_removed
    puts setting.flag_count
    puts 'create ended!!!!!!!'
    redirect_to :back
  end
  
  def update
    puts 'update started!!!!'
    @setting = Setting.find(params[:id])
    @setting.update_attributes(params[:setting])
    redirect_to :back
 
  end
end
