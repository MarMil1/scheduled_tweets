class TweetJob < ApplicationJob
  queue_as :default

  def perform(tweet_id)
    tweet = Tweet.find_by(id: tweet_id)
    return unless tweet # Tweet not found, exit gracefully
    
    return if tweet.published?
    return if tweet.publish_at > Time.current
  
    tweet.publish_to_twitter!
  rescue ActiveRecord::RecordNotFound
    # Handle the case where the Tweet record is not found
    Rails.logger.error("Tweet with ID #{tweet_id} not found")
  end
end
