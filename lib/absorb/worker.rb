module Absorb

  class Worker < ::Seam::Worker

    class << self
      attr_accessor :things_to_do
    end

    def self.inherited worker
      step = Absorb::Helpers.underscore(worker.to_s).gsub('absorb/', '').to_sym
      Absorb::Worker.things_to_do ||= {}
      Absorb::Worker.things_to_do[step] = worker
    end

  end

end
