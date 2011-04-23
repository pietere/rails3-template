module LayoutHelper
  def title text, show = false
    content_for(:title) { text }

    return text if show
  end
end
