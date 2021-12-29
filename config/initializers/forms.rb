# Remove <div class="field_with_errors"> for input & labal tags
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html_tag.html_safe
end

# Custom form builder that adds <%= f.field :attr do %> div wrapper
# as a convenient way to display errors for the given attribute.
class AppFormBuilder < ActionView::Helpers::FormBuilder
  def field(attribute, options = {}, &block)
    has_errors = @object && @object.errors[attribute].any?

    classes = (options[:class] || "").split(/s+/)
    classes << "form-field"
    classes << "form-field--with-errors" if has_errors
    options[:class] = classes.uniq.join(" ")

    @template.tag.div(class: options[:class]) do
      yield(block).html_safe

      if has_errors
        @template.concat @template.tag.div(@object.errors[attribute].join(", "), class: "form-field__error")
      end
    end
  end
end

module AppFormFor
  def app_form_with(model: nil, scope: nil, url: nil, format: nil, **options, &block)
    options[:builder] = AppFormBuilder
    form_with model: model, scope: scope, url: url, format: format, **options, &block
  end
end

ActiveSupport.on_load(:action_view) do
  include AppFormFor
end
