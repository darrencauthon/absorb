class Upload
  include Dynamoid::Document

  table :name => :uploads, :key => :id, :read_capacity => 400, :write_capacity => 400
  field :name
  field :uuid
  field :filename

  def self.upload file
    u = self.new

    uuid = Absorb::Guid.generate
    to = file.split('/')[-1]
    to = "#{uuid}/#{to}"
    u.uuid = uuid
    u.save

    s3 = Absorb::AmazonS3.new
    s3.store_file file, to
  end
end
