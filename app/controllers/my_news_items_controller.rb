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
    @issues_list = ['Free Speech', 'Immigration', 'Terrorism', 'Social Security and
    Medicare', 'Abortion', 'Student Loans', 'Gun Control', 'Unemployment',
    'Climate Change', 'Homelessness', 'Racism', 'Tax Reform', 
    'Net Neutrality', 'Religious Freedom', 'Border Security', 'Minimum Wage',
    'Equal Pay']
  end

  def set_news_item
    @news_item = NewsItem.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def news_item_params
    params.require(:news_item).permit(:news, :title, :description, :link, :issue, :representative_id)
  end

  def set_issue
    @issue = params[:new_item][:issue]
  end

  def find_articles
    @selected_representative_id = news_item_params[:representative_id]
    @selected_representative = Representative.find(@selected_representative_id)
    name = @selected_representative.name
    @selected_issue = news_item_params[:issue]
    issue = @selected_issue
    api_key = Rails.application.credentials.NEWS_API_KEY
    api_query = "#{name} #{issue}"
    base_url = 'https://newsapi.org/v2'
    endpoint = '/everything'
    api_params = {
      apiKey: api_key,
      q:      api_query
    }

    response = RestClient.get("#{base_url}#{endpoint}", params: api_params)
    Rails.logger.info("Issue: #{issue}")

    @api_articles = JSON.parse(response.body)['articles'].first(5)
  end
end
