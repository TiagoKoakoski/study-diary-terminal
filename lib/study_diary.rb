INSERT = 1
VIEW = 2
SEARCH = 3
DELETE = 4
DONE = 5
LIST_CATEGORY = 6
LIST_DONE = 7
UNDONE = 8
EXIT = 9
require_relative 'study_item'
require 'colorize'

def menu
  puts <<~MENU
  //============================================//
  || [#{INSERT}] Cadastrar um item para estudar         ||
  || [#{VIEW}] Ver todos os itens cadastrados         ||
  || [#{SEARCH}] Buscar um item de estudo               ||
  || [#{DELETE}] Remover item                           ||
  || [#{DONE}] Concluir item                          ||
  || [#{LIST_CATEGORY}] Listar por categoria                   ||
  || [#{LIST_DONE}] Ver os itens concluídos                ||
  || [#{UNDONE}] Voltar a estudar                       ||
  || [#{EXIT}] Sair                                   ||
  //============================================//
  MENU
  print "Escolha uma opção: ".yellow
  gets.to_i
end

def select_category()
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

def create_study_item
  print "Digite o item para estudo: ".yellow
  item = gets.chomp()
  category = select_category()
  print "Digite a descrição do item para estudo: ".yellow
  description = gets.chomp()
  study_item = StudyItem.new(title: item, category: category, description: description)
  study_item.save_to_db
  option = 0
  puts "Item #{item} cadastrado com sucesso na categoria #{category}"
end


def list_items()
  puts "Lista de itens cadastrados: "
  study_items = StudyItem.find_undone
  study_items.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
end

def search_item()
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

def delete_item()
  list = list_items()
  print "Qual o item que deseja remover: ".yellow
  select = gets.chomp
  return if select.empty?

  select = select.to_i
  select = list[(select - 1)].title
  StudyItem.delete(select)
  puts "item removido com sucesso"
end

def make_done()
  list = list_items()
  print "Qual o item que deseja concluir: ".yellow
  select = gets.chomp
  return if select.empty?

  select = select.to_i
  select = list[(select - 1)].title
  StudyItem.done(select)
  puts "item concluído com sucesso"
end

def list_done()
  puts "Lista de itens concluídos: "
  study_items = StudyItem.find_done
  study_items.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
end

def make_undone()
  list = list_done()
  print "Qual o item que deseja voltar a estudar: ".yellow
  select = gets.chomp
  return if select.empty?

  select = select.to_i
  select = list[(select - 1)].title
  StudyItem.undone(select)
  puts "item retornou para estudo com sucesso"
end

def fim_de_funcao()
  puts "---------------------------"
  puts "Aperte ENTER para continuar"
  gets
  system "clear"
end

option = 0

puts "Bem-vindo ao Diário de Estudos, seu companheiro de estudos".yellow

while option != EXIT
  option = menu()
  system "clear"
  case option
  when INSERT
    create_study_item()
    fim_de_funcao()

  when VIEW
    list_items()
    fim_de_funcao()

  when SEARCH
    search_item()
    fim_de_funcao()

  when DELETE
    delete_item()
    fim_de_funcao()

  when DONE
    make_done()
    fim_de_funcao()

  when LIST_CATEGORY
    categoria = select_category()
    StudyItem.find_by_category(categoria)
    fim_de_funcao()

  when LIST_DONE
    list_done()
    fim_de_funcao()

  when UNDONE
    make_undone()
    fim_de_funcao()

  when EXIT
    system "clear"
    puts "Obrigado por utilizar o Diário de Estudos"

  else
    puts 'Opção inválida'
  end
end
