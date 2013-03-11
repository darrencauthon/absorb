module Commands
  class Base
    class << self
      attr_accessor :commands

      def inherited(command)
        @commands ||= []
        @commands << command if command != Commands::Default
      end

    end
  end
end
