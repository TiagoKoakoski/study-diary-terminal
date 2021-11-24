require 'sqlite3'
require_relative 'category'

class StudyItem
  attr_accessor :title, :category, :description, :done

  def initialize ( title:, category: Category.new, description: "Não preenchido", done: '0' )
    @title = title
    @category = category
    @description = description
    @done = done
  end

  def self.select_category()
    puts "Qual a categoria:
    1 - Ruby
    2 - Rails
    3 - HTML"
    print "Categoria: ".yellow
    category = gets.to_i()
    if category == 1
      category = "Ruby"
    elsif category == 2
      category = "Rails"
    elsif category == 3
      category = "HTML"
    end
    category
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description, done FROM diario"
    db.close
    items = items.map {|item| new(title: item['title'], category: item['category'], description: item['description'], done:item['done']) }
  end

  def self.print_list(items)
    puts "Os itens cadastrados são: "
    items.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category} #{' - Concluído' if valor.done == 1}"}
  end

  def save_to_db
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO diario VALUES('#{ title }', '#{ category }', '#{ description }', 0)"
    db.close
    self
  end

  def self.search_item()
    print "Qual item deseja encontrar: ".yellow
    search = gets.chomp
    study_list = StudyItem.all
    puts "Itens encontrados: "
    study_list.each do |valor|
      if ( valor.title.include? search ) || ( valor.description.include? search )
        puts " - #{valor.title} - #{valor.description} - Categoria #{valor.category}"
      end
    end
  end

  def self.create_study_item
    print "Digite o item para estudo: ".yellow
    item = gets.chomp()
    category = self.select_category()
    print "Digite a descrição do item para estudo: ".yellow
    description = gets.chomp()
    study_item = StudyItem.new(title: item, category: category, description: description)
    study_item.save_to_db
    option = 0
    puts "Item #{item} cadastrado com sucesso na categoria #{category}"
  end

  def self.find_by_category()
    system "clear"
    category = select_category()
    puts "Os itens na categoria #{category} são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description, done FROM diario where category='#{category}'"
    db.close
    list = items.map {|item| new(title: item['title'], category: item['category'], description: item['description'], done: item['done']) }
    list.each{|valor| puts " - #{valor.title} - #{valor.description} #{'- Concluído' if valor.done == 1}"}
  end

  def self.find_undone()
    system "clear"
    puts "Os itens não concluídos são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description FROM diario where done='0'"
    db.close
    list = items.map {|item| new(title: item['title'], category: item['category'], description: item['description']) }
    list.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
  end

  def self.find_done()
    system "clear"
    puts "Os itens concluídos são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description FROM diario where done='1'"
    db.close
    list = items.map {|item| new(title: item['title'], category: item['category'], description: item['description']) }
    list.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
  end

  def self.delete()
    list = self.all()
    print "Qual o item que deseja remover: ".yellow
    select = gets.chomp
    return if select.empty?
    select = select.to_i
    select = list[(select - 1)].title
    db = SQLite3::Database.open "db/database.db"
    db.execute "DELETE FROM diario WHERE title='#{ select }'"
    db.close
    puts "item removido com sucesso"
  end

  def self.done()
    list = find_undone()
    print "Qual o item que deseja concluir: ".yellow
    select = gets.chomp
    return if select.empty?
    select = select.to_i
    select = list[(select - 1)].title
    db = SQLite3::Database.open "db/database.db"
    db.execute "UPDATE diario SET done='1' WHERE title='#{ select }'"
    db.close
    puts "item concluído com sucesso"
  end

  def self.undone()
    list = find_done()
    print "Qual o item que deseja voltar a estudar: ".yellow
    select = gets.chomp
    return if select.empty?
    select = select.to_i
    select = list[(select - 1)].title
    db = SQLite3::Database.open "db/database.db"
    db.execute "UPDATE diario SET done='0' WHERE title='#{ select }'"
    db.close
    puts "item retornou para estudo com sucesso"
  end

end
