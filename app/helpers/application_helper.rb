module ApplicationHelper
  def form_errors(obj)
    result = ""
    if obj.errors.any?
      inner_html = ""
      obj.errors.full_messages.each.with_index do |msg, index|
        inner_html += "%d. %s <br/>" % [index+1, msg]
      end
      result = '<div class="alert alert-danger" role="alert">%s</div>' % inner_html
    end
    return result
  end
end
