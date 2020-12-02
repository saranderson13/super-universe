class NewsItemsController < ApplicationController

    before_action :admin_only, except: [:index]

    def index
        @all_news = current_user.is_admin? ? NewsItem.all.reverse() : NewsItem.index_for_non_admin()
    end


    def new
        @news_item = NewsItem.new
    end

    
    def create
        @news_item = NewsItem.new(item_params)

        if @news_item.valid?
            @news_item.save
            redirect_to news_items_path
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
            redirect_to news_items_path
        else
            render :edit
        end

    end


    def update_view
        @news_item = set_item

        if toggle_params["toggle"] == "homepage"
            @news_item.homepage = !@news_item.homepage
        else
            @news_item.indexpage = !@news_item.indexpage
        end

        if @news_item.valid?
            @news_item.save
            flash[:notice] = "CONFIRMATION: News Item #{@news_item.id} has been updated."
            redirect_to news_items_path
        else
            flash[:notice] = "ERROR: News Item #{@news_item.id} failed to update."
            redirect_to news_items_path
        end
    end


    def destroy
        @news_item = set_item
        @news_item.destroy
        redirect_to root_path
    end


    private 

    def item_params
        params.require(:news_item).permit(:id, :title, :description, :homepage, :indexpage)
    end

    def toggle_params
        params.permit(:id, :toggle)
    end

    def set_item
        NewsItem.find(params[:id])
    end

end
