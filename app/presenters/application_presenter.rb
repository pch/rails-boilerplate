class ApplicationPresenter < SimpleDelegator
  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def initialize(object, view_context)
    super(object)
    @view_context = view_context
  end

  private

  def h
    @view_context
  end
end
