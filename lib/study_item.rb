require 'sqlite3'
require_relative 'category'

class StudyItem
  attr_accessor :id, :title, :category, :description, :done

  def initialize ( id: nil, title:, category: Category.new, description: "Não preenchido", done: '0' )
    @id = id
    @title = title
    @category = category
    @description = description
    @done = done
  end

  def self.create_from_db(items)
    items.map { |hash| hash.transform_keys!(&:to_sym)}.map{|item| StudyItem.new(**item)}
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description, done FROM diario"
    db.close
    create_from_db(items)
  end

  def self.print_list(items)
    items.each_with_index {|element, ind| puts "[#{ind+1}] - #{element.title} - #{element.description} - Categoria: #{element.category} #{' - Concluído' if element.done == 1}"}
  end

  def save_to_db
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO diario VALUES('#{ title }', '#{ category }', '#{ description }', 0)"
    db.close
    self
  end

  def self.search_item
    print "Qual item deseja encontrar: ".yellow
    search = gets.chomp.downcase
    study_list = self.all
    puts "Itens encontrados: "
    study_list.each do |element|
      if ( element.title.downcase.include? search ) || ( element.description.downcase.include? search )
        puts " - #{element.title} - #{element.description} - Categoria #{element.category}"
      end
    end
  end

  def self.create_study_item
    print "Digite o item para estudo: ".yellow
    item = gets.chomp()
    category = Category.select_category
    print "Digite a descrição do item para estudo: ".yellow
    description = gets.chomp()
    study_item = new(title: item, category: category, description: description)
    study_item.save_to_db
    option = 0
    puts "Item #{item} cadastrado com sucesso na categoria #{category}"
  end

  def self.find_by_category
    system "clear"
    category = Category.select_category
    puts "Os itens na categoria #{category} são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description, done FROM diario where category='#{category}'"
    db.close
    self.print_list(create_from_db(items))
  end

  def self.find_undone
    system "clear"
    puts "Os itens não concluídos são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description FROM diario where done='0'"
    db.close
    self.print_list(create_from_db(items))
  end

  def self.find_done
    system "clear"
    puts "Os itens concluídos são: "
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    items = db.execute "SELECT title, category, description FROM diario where done='1'"
    db.close
    self.print_list(create_from_db(items))
  end

  def self.delete
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

  def self.done
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

  def self.undone
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
