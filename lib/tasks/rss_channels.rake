namespace :rss_channels do
  desc "Import new RssPosts for all RssChannels"
  task import_new_posts: :environment do
    RssChannel.all.each do |rc|
      RssImporterJob.perform_later(rc.id)
    end
  end
end
