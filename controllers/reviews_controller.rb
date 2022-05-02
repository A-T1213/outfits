class ReviewsController < ApplicationController
    def index
        @reviews = Review.all
    end

    def new
        @review = Review.new
    end
    
    def create
        review = Review.new(review_params)
        if review.save
            redirect_to :action => "index"
        else
            redirect_to :action => "new"
        end
    end
    
    private
    def review_params
        params.require(:review).permit(:body,:status)
    end
end
