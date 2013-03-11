module Commands
  class Base
    class << self
      attr_accessor :commands

      def inherited(command)
        @commands ||= []
        @commands << command
      end

    end
  end
end
