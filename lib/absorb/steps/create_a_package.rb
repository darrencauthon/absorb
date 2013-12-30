module Absorb

  class CreateAPackage < ::Absorb::Worker

    def initialize
      handles :create_a_package
    end

    def process
      package = create_package
      save_the_package_id_for package
    end

    def create_package
      Absorb::Package.create(uuid: effort.data['absorb_uuid'])
    end

    def save_the_package_id_for package
      effort.data['package_id'] = package.id
    end

  end

end
