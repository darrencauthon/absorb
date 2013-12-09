module Absorb

  class CreateAPackageWorker < Seam::Worker

    def initialize
      handles :create_a_package
    end

    def process
      package = Absorb::Package.create(uuid: effort.data['absorb_uuid'])
      self.effort.data['package_id'] = package.id
    end

  end

end
