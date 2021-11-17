require 'sqlite3'
require_relative 'category'

class StudyItem
  attr_accessor :title, :category, :description, :done

  def initialize ( title:, category: Category.new, description: "Não preenchido" )
    @title = title
    @category = category
    @description = description
    @done = 0
  end

  def selecionar_categoria()
    puts "Qual a categoria:
    1 - Ruby
    2 - Rails
    3 - HTML"
    categoria = gets.to_i()
    if categoria == 1
      categoria = "Ruby"
    elsif categoria == 2
      categoria = "Rails"
    else
      categoria = "HTML"
    end
    categoria
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    itens = db.execute "SELECT title, category, description FROM diario"
    db.close
    itens.map {|item| new(title: item['title'], category: item['category'], description: item['description']) }
  end

  def save_to_db
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO diario VALUES('#{ title }', '#{ category }', '#{ description }', 0)"
    db.close
    self
  end

  def self.find_by_category(categoria)
    system "clear"
    puts "Os itens na categoria #{categoria} são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    itens = db.execute "SELECT title, category, description FROM diario where category='#{categoria}'"
    db.close
    lista = itens.map {|item| new(title: item['title'], category: item['category']) }
    lista.each{|valor| puts " - #{valor.title} - #{valor.description}"}
  end

  def self.find_undone()
    system "clear"
    puts "Os itens não concluídos são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    itens = db.execute "SELECT title, category, description FROM diario where done='0'"
    db.close
    lista = itens.map {|item| new(title: item['title'], category: item['category'], description: item['description']) }
  end

  def self.find_done()
    system "clear"
    puts "Os itens concluídos são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    itens = db.execute "SELECT title, category, description FROM diario where done='1'"
    db.close
    lista = itens.map {|item| new(title: item['title'], category: item['category'], description: item['description']) }
  end

  def self.delete(title)
    db = SQLite3::Database.open "db/database.db"
    db.execute "DELETE FROM diario WHERE title='#{ title }'"
    db.close
  end

  def self.done(title)
    db = SQLite3::Database.open "db/database.db"
    db.execute "UPDATE diario SET done='1' WHERE title='#{ title }'"
    db.close
  end

  def self.undone(title)
    db = SQLite3::Database.open "db/database.db"
    db.execute "UPDATE diario SET done='0' WHERE title='#{ title }'"
    db.close
  end

end
