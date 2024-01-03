class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  before_create :generate_uuid_v7

  private

  def generate_uuid_v7
    return if self.class.attribute_types["id"].type != :uuid

    self.id ||= UUID7.generate
  end
end
