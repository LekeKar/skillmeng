json.extract! gallery_pic, :id, :caption, :created_at, :updated_at
json.url gallery_pic_url(gallery_pic, format: :json)