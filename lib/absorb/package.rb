module Absorb
  class Package
    include Dynamoid::Document

    table :name => :packages, :key => :id, :read_capacity => 400, :write_capacity => 400
    field :uuid
  end
end
