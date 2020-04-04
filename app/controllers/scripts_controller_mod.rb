module ScriptsControllerMod
  extend ActiveSupport::Concern

  included do
    before_action :load_object
  end

  def show
    # @script.show_action
    # if performed?
    #   return
    # end

    if request.format.json?
      render json: @script.script_body
      return
    end

    @page_title ||= @script.script_name
    render :html => @script.render_in_view, layout: true
  end

  def update
    @script.put_action
  end

  def load_object
    klass = script_group.find(params[:id])
    @script = klass.new(params.merge(:view_context => view_context, :controller => self))
  end

  def script_group
    raise NotImplementedError, "#{__method__} is not implemented"
  end
end
