require 'agilecrm-wrapper/error'
require 'hashie'

module AgileCRMWrapper
  class Task < Hashie::Mash
    TYPES = %w(CALL EMAIL FOLLOW_UP MEETING MILESTONE SEND TWEET OTHER)
    PRIORITIES = %w(HIGH NORMAL LOW)
    STATUSES = %w(YET_TO_START IN_PROGRESS COMPLETED)

    class << self
      def pending
        response = AgileCRMWrapper.connection.get('tasks')
        if response.status == 200
          return response.body.map { |body| new body }
        else
          return response
        end
      end

      def all
        response = AgileCRMWrapper.connection.get('tasks/all')
        if response.status == 200
          return response.body.map { |body| new body }
        else
          return response
        end
      end

      def find(id)
        response = AgileCRMWrapper.connection.get("tasks/#{id}")
        if response.status == 200
          new(response.body)
        elsif response.status == 204
          fail(AgileCRMWrapper::NotFound.new(response))
        end
      end

      def create(options = {})
        response = AgileCRMWrapper.connection.post('tasks', options)
        if response && response.status == 200
          task = new(response.body)
        end
        task
      end

      def delete(arg)
        AgileCRMWrapper.connection.delete("tasks/#{arg}")
      end
    end

    def destroy
      self.class.delete(id)
    end

    def update(options = {})
      merge!(options)
      response = AgileCRMWrapper.connection.put('tasks', self)
      merge!(response.body)
    end
  end
end
