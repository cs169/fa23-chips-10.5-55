# frozen_string_literal: true

class MyNewsItemsController < SessionController
  before_action :set_representative, only: %i[create update destroy new create_from_selected]
  before_action :set_representatives_list
  before_action :set_news_item, only: %i[edit update destroy]
  before_action :find_articles, only: [:display_articles]
  before_action :set_issues_list

  def new
    @news_item = NewsItem.new
  end

  def select_rep_issue
    render :select_rep_issue
  end

  def display_articles
    render :display_articles
  end

  def edit; end

  def create
    @news_item = NewsItem.new(news_item_params)
    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully created.'
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  def create_from_selected
    selected_article_index = params[:selected_article_index]
    selected_article = params[:articles][selected_article_index]

    @news_item = NewsItem.new(
      title:             selected_article['title'],
      description:       selected_article['description'],
      link:              selected_article['link'],
      representative_id: params[:representative_id],
      issue:             params[:selected_issue]
    )
    Rails.logger.info(params)

    if @news_item.save
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully created.'
    else
      render :new, error: 'An error occurred when creating the news item.'
    end
  end

  def update
    if @news_item.update(news_item_params)
      redirect_to representative_news_item_path(@representative, @news_item),
                  notice: 'News item was successfully updated.'
    else
      render :edit, error: 'An error occurred when updating the news item.'
    end
  end

  def destroy
    @news_item.destroy
    redirect_to representative_news_items_path(@representative),
                notice: 'News was successfully destroyed.'
  end

  private

  def set_representative
    @representative = Representative.find(
      params[:representative_id]
    )
  end

  def set_representatives_list
    @representatives_list = Representative.all.map { |r| [r.name, r.id] }
  end

  def set_issues_list
    @issues_list = NewsItem.all_issues
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :issue, :representative_id)
  end

  def set_selected_issue
    @selected_issue = news_item_params[:issue]
  end

  def set_selected_representative_issue
    @selected_issue = news_item_params[:issue]
    @selected_representative = Representative.find(news_item_params[:representative_id])
  end

  def find_articles
    return unless news_item_params[:representative_id].present? && news_item_params[:issue].present?

    set_selected_representative_issue
    if Rails.env.test?
      @api_articles = [
        { 'title' => 'Mock Title', 'description' => 'Mock Description', 'url' => 'http://mockurl.com' }
      ]
    else
      api_params = {
        apiKey: Rails.application.credentials.NEWS_API_KEY,
        q:      "#{@selected_representative.name} #{@selected_issue}"
      }

      response = RestClient.get('https://newsapi.org/v2/everything', params: api_params)
      @api_articles = JSON.parse(response.body)['articles'].first(5)
    end
  end
end
