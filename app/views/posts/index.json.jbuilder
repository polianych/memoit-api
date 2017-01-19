json.posts @posts do |post|
  json.post do
    json.partial! "posts/post", post: post
  end

  json.video_sources do
    json.array! post.video_sources, partial: 'posts/video_source', as: :video_source
  end

  case post.publisher_type
  when 'RssChannel'
    json.rss_channel do
      json.id post.rss_channel.id
      json.title post.rss_channel.title
      json.image_url post.rss_channel.image_url
      json.slug post.rss_channel.slug
    end
  when 'User'
    json.user do
      json.id post.user.id
      json.nickname post.user.nickname
    end
  end

  case post.postable_type
  when 'RssPost'
    json.rss_post do
      json.id post.rss_post.id
      json.link post.rss_post.link
      json.media_thumbnail post.rss_post.media_thumbnail
      json.guid post.rss_post.guid
    end
  when 'UserPost'
    json.user_post do
      json.id post.user_post.id
      json.link post.user_post.link
      json.image_url post.user_post.image_url
      json.video_url post.user_post.video_url
    end
  end
end

json.meta do
  json.total_pages @posts.total_pages
  json.current_page @posts.current_page
end
