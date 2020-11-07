class NewsItemsController < ApplicationController

    before_action :admin_only, except: [:index]

    def index
        @all_news = NewsItem.all
    end


    def new
        @news_item = NewsItem.new
    end

    
    def create
        @news_item = NewsItem.new(signup_params)

        if @news_item.valid?
            @news_item.save
            redirect_to root_path
        else
            render :new
        end
    end


    def edit
        @news_item = set_item
    end


    def update
        @news_item = set_item
        @news_item.update_attributes(item_params)

        if @news_item.valid?
            @news_item.save
            redirect_to root_path
        else
            render :edit
        end

    end

    
    def update_homepage
        
    end


    def destroy
        @news_item = set_item
        @news_item.destroy
        redirect_to root_path
    end


    private 

    def item_params
        params.require(:news_item).permit(:title, :description, :homepage)
    end

    def set_item
        NewsItem.find(params[:id])
    end

end
