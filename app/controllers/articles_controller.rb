class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    session[:page_views] ||= 0
    session[:page_views] += 1
    if session[:page_views] == 4
      exceeding_article_limit_response
    else
      render json: article
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

  def exceeding_article_limit_response
    render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
  end

end
