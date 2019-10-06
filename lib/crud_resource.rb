module Concerns::CrudResource
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: [:show, :update, :edit, :destroy]
  end

  def index
    @resources = resource_scope.all
  end

  def new
    @resource = resource_scope.new
  end

  def create
    @resource = resource_scope.new(resource_params)
    if @resource.save
      flash[:notice] = after_create_notice
      redirect_to resources_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @resource.update resource_params
      flash[:notice] = after_update_notice
      redirect_to resources_path
    else
      render :edit
    end
  end

  private

  def resource_scope
    'Abstract Resource'
  end

  def resource_symbol
    resource_scope.to_s.underscore.to_sym
  end

  def permitted_params
    []
  end

  def resource_params
    params.require(resource_symbol).permit(permitted_params)
  end

  def resources_path
    url_for([:admin, resource_scope])
  end

  def resource
    @resource ||= find_resource
  end

  def find_resource
    @resource ||= resource_scope.find params[:id]
  end

  def after_update_notice
    "#{resource_scope.model_name.human} успешно #{resource_sex ? 'сохранен' : 'сохранена'}." 
  end

  def after_create_notice
    "#{resource_scope.model_name.human} успешно #{resource_sex ? 'добавлен' : 'добавлена'}."
  end

  def resource_sex() true end

end
