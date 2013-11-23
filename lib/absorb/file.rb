module Absorb

  class File

    include Dynamoid::Document

    table :name => :files, :key => :id, :read_capacity => 400, :write_capacity => 400
    field :uuid
    field :name

  end

end
