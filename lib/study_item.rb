require 'sqlite3'
require_relative 'category'

class StudyItem
  attr_accessor :title, :category

  def initialize ( title:, category: Category.new )
    @title = title
    @category = category
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    itens = db.execute "SELECT title, category FROM diario"
    db.close
    itens.map {|item| new(title: item['title'], category: item['category']) }
  end

  def save_to_db
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO diario VALUES('#{ title }', '#{ category }')"
    db.close
    self
  end

  def self.find_by_title(title)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    itens = db.execute "SELECT title, category FROM diario where title='#{title}'"
    db.close
    itens.map {|item| new(title: item['title'], category: item['category']) }
  end

  def self.find_by_category(categoria)
    system "clear"
        puts "Os itens na categoria #{categoria} são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    itens = db.execute "SELECT title, category FROM diario where category='#{categoria}'"
    db.close
    lista = itens.map {|item| new(title: item['title'], category: item['category']) }
    lista.each{|valor| puts "Item #{valor.title}"}
  end

  def self.delete(title)
    db = SQLite3::Database.open "db/database.db"
    db.execute "DELETE FROM diario WHERE title='#{ title }'"
    db.close
  end



end
