# typed: strict
require "sorbet-runtime"

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
