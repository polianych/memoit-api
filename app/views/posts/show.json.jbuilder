json.post do
  json.post do
    json.partial! "posts/post", post: @post
  end

  case @post.publisher_type
  when 'RssChannel'
    json.rss_channel do
      json.partial! "rss_channels/rss_channel_short", rss_channel: @post.rss_channel
    end
  when 'User'
    json.user do
      json.partial! "users/user_short", user: @post.user
    end
  end

  case @post.postable_type
  when 'RssPost'
    json.rss_post do
      json.partial! "posts/rss_post", rss_post: @post.rss_post
    end
  when 'UserPost'
    json.user_post do
      json.partial! "posts/user_post", user_post: @post.user_post
    end
  end
end
