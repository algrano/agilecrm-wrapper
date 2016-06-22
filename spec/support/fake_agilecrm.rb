# http://robots.thoughtbot.com/how-to-stub-external-services-in-tests
require 'sinatra/base'

class FakeAgileCRM < Sinatra::Base
  get '/dev/api/contacts' do
    json_response 200, 'contacts', 'list_contacts'
  end

  get '/dev/api/contacts/:id' do
    if params[:id] == '0'
      status 204
    else
      json_response 200, 'contacts', 'get_contact'
    end
  end

  get '/dev/api/contacts/:id/notes' do
    json_response 200, 'contacts', 'get_contact_notes'
  end

  post '/dev/api/contacts/search/email' do
    if JSON.parse(params['email_ids']).include? 'anitadrink@example.com'
      json_response 200, 'contacts', 'search_by_email'
    elsif JSON.parse(params['email_ids']).include? 'idontexist@example.com'
      json_response 200, 'contacts', 'search_by_email_no_results'
    end
  end

  post '/dev/api/contacts/add-score' do
    json_response 200, 'contacts', 'create_contact'
  end

  get '/dev/api/search' do
    json_response 200, 'contacts', 'search'
  end

  post '/dev/api/notes' do
    json_response 200, 'notes', 'create_note'
  end

  post '/dev/api/contacts' do
    json_response 200, 'contacts', 'create_contact'
  end

  post '/dev/api/contacts/bulk/tags' do
    status 200
  end

  put '/dev/api/contacts' do
    json_response 200, 'contacts', 'updated_contact'
  end

  put '/dev/api/contacts/delete/tags' do
    json_response 200, 'contacts', 'delete_tags'
  end

  delete '/dev/api/contacts/:id' do
    status 204
  end

  get '/dev/api/tags' do
    json_response 200, 'tags', 'list_tags'
  end

  post '/dev/api/contacts/change-owner' do
    if params['owner_email'] == 'new_owner@example.com'
      json_response 200, 'contacts', 'change_owner'
    else
      json_response 200, 'contacts', 'change_owner_not_found'
    end
  end

  get '/dev/api/tasks' do
    json_response 200, 'tasks', 'all_tasks'
  end

  get '/dev/api/tasks/all' do
    json_response 200, 'tasks', 'all_tasks'
  end

  get '/dev/api/tasks/:id' do
    if params[:id] == '0'
      status 204
    else
      json_response 200, 'tasks', 'get_task'
    end
  end

  delete '/dev/api/tasks/:id' do
    status 204
  end

  post '/dev/api/tasks' do
    json_response 200, 'tasks', 'create_task'
  end

  put '/dev/api/tasks' do
    json_response 200, 'tasks', 'updated_task'
  end

  private

  def json_response(response_code, resource, file_name)
    content_type :json
    status response_code
    File.read(
      File.expand_path(
        "spec/fixtures/#{resource}/#{file_name}.json",
        Dir.pwd
      )
    )
  end
end
