class ScrapeAllrecipesService
  def initialize(keyword)
    @keyword = keyword
  end

  def call
    url = "https://www.allrecipes.com/search/results/?search=#{@keyword}"
    doc = Nokogiri::HTML(URI.open(url).read, nil, 'utf-8')
    recipes_of_web = []
    titles = doc.search('div .card__detailsContainer .card__detailsContainer-left .card__title').text.strip.scan(/\w+\s\w+/)[0, 5]
    summaries = doc.search('div .card__detailsContainer .card__detailsContainer-left .card__summary').text.strip.scan(/[\w+\s]+/)[0, 5].each { |summ| summ.strip!}
    ratings = doc.search('.review-star-text').text.strip.scan(/\d+.?\d*/)[0, 5]
    links = doc.search('div .card__detailsContainer .card__detailsContainer-left .card__titleLink').map { |anchor| anchor["href"] }[0, 5]
    page = Nokogiri::HTML(URI.open(links[0]).read, nil, 'utf-8')

    titles.each_with_index do |title, index|
      summary = summaries[index]
      rating = ratings[index]
      href = links[index]
      page = Nokogiri::HTML(URI.open(links[index]).read, nil, 'utf-8')
      preptime = page.search('.recipe-meta-item-body').text.strip.scan(/\d+/).first
      recipe = []

      recipe << title
      recipe << summary
      recipe << rating
      recipe << preptime
      recipes_of_web << recipe
    end
    return recipes_of_web
  end
end
