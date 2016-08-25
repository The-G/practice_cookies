json.extract! post, :id, :email, :created_at, :updated_at
json.url post_url(post, format: :json)