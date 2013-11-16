class Upload
  include Dynamoid::Document

  table :name => :uploads, :key => :id, :read_capacity => 400, :write_capacity => 400
  field :name
  field :uuid
  field :filename

  def upload file
    uuid = Absorb::Guid.generate
    to = "#{uuid}/#{to}"
    self.uuid = uuid
    self.save

    s3 = Absorb::AmazonS3.new Absorb.settings[:bucket_name]
    s3.store_file file, to
  end
end
