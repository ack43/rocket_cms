# class SearchController < ApplicationController
#   def index
#     if params[:query].blank?
#       @results = []
#     else
#       if Rails.env.development?
#         # trigger autoload so models are registered in Mongoid::Elasticearch
#         RocketCMS.configuration.search_models.map(&:constantize)
#       end
#       @results = Mongoid::Elasticsearch.search({
#         body: {
#           query: {
#             query_string: {
#               query: Mongoid::Elasticsearch::Utils.clean(params[:query])
#             }
#           },
#           highlight: {
#             fields: {
#               name: {},
#               content: {}
#             }
#           }
#         }},
#         page: params[:page],
#         per_page: RocketCMS.configuration.search_per_page,
#       )
#     end
#   end
# end

#todo multimidelsearch
class SearchController < ApplicationController
  def index
    if params[:q].blank?
      @results = []
    else
      query = params[:q].to_s.gsub(/\P{Word}+/, ' ').gsub(/ +/, ' ').strip
      @results = Page.search(query,
                             per_page: 10,
                             highlight: true,
                             suggest: true,
                             page: params[:page],
                             per_page: RocketCMS.configuration.search_per_page
      )
    end
  end
end
