require 'test_helper'

class RssCategoriesControllerTest < ActionDispatch::IntegrationTest

  test 'get all RssCategories' do
    get rss_categories_url, as: :json
    body = JSON.parse(response.body)
    assert_response 200
    body.assert_valid_keys('rss_categories', 'meta')
    body['meta'].assert_valid_keys('total_pages', 'current_page')
    assert_equal body['rss_categories'].count, 2
  end

  test 'get RssCategory by id' do
    @rss_category = rss_categories(:rss_category_one)
    get rss_category_url(id: @rss_category.id), as: :json
    body = JSON.parse(response.body)
    assert_response 200
    body.assert_valid_keys('rss_category')
    assert_equal body['rss_category']['id'], @rss_category.id
  end
end
