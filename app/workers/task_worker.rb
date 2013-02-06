class TaskWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform
    tasks = RestClient.get "#{CONFIG['host']}/tasks/?keyword=#{CONFIG['keyword']}"
    JSON(tasks).each do |task|
      result = eval task['content']
      RestClient.put "#{CONFIG['host']}/tasks/#{task['id']}", {
          result:  result,
          keyword: CONFIG['keyword']
      }
    end
  end
end