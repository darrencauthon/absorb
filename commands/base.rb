module Commands
  class Base

    def initialize(arguments = [], options = {})
      @arguments = arguments
      @options = options
    end

    class << self
      attr_accessor :commands

      def inherited(command)
        @commands ||= []
        @commands << command if command != Commands::Default
      end

    end
  end
end
