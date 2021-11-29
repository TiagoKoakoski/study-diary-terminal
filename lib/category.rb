class Category
  attr_accessor :title

  def initialize(title:)
    @title = title
  end

  CATEGORIES = [
    new(title: 'Ruby'),
    new(title: 'Rails'),
    new(title: 'HTML')
  ]

  def self.all
    CATEGORIES
  end

  def self.select_category
    puts "Qual a categoria:"
    list = all.each_with_index{|element,ind| puts "#{ind+1} - #{element.title}"}
    print "Categoria: ".yellow
    category = gets.to_i
    category = list[category-1].title
  end

end
