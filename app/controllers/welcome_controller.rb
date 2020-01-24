class WelcomeController < ApplicationController
  before_action :authenticate_user!
  def index
    render plain: 'Hello rails'
  end
  def show
    @tables = []
    table_model_names.map do |model_name|
      entity = model_name.constantize rescue nil
      next if entity.nil?
      @tables.push({ table_name: entity.to_s, no_of_records:  entity.all.count })
    end.compact
    render json: @tables
  end
  private
  def table_model_names
    ActiveRecord::Base.connection.tables.map(&:singularize).map(&:camelize)
  end
end
