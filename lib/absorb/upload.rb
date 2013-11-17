class Upload
  include Dynamoid::Document

  table :name => :uploads, :key => :id, :read_capacity => 400, :write_capacity => 400
  field :name
  field :uuid
  field :filename
end
