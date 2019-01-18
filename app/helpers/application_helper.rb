module ApplicationHelper
  def truncate_description(description)
    description = simple_format(strip_tags(description).truncate(60))
  end
end