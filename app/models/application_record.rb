class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  scope :created_at_or_after, lambda {|start_date| where("created_at >= ?", start_date ).order(created_at: :asc)}
end
