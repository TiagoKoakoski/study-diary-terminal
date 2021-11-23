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

def list_items()
  puts "Lista de itens cadastrados: "
  study_items = StudyItem.find_undone
  study_items.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
end

def list_done()
  puts "Lista de itens concluídos: "
  study_items = StudyItem.find_done
  study_items.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
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
    StudyItem.create_study_item()
    fim_de_funcao()
  when VIEW
    list_items()
    fim_de_funcao()
  when SEARCH
    StudyItem.search_item()
    fim_de_funcao()
  when DELETE
    StudyItem.delete()
    fim_de_funcao()
  when DONE
    StudyItem.done()
    fim_de_funcao()
  when LIST_CATEGORY
    StudyItem.find_by_category()
    fim_de_funcao()
  when LIST_DONE
    list_done()
    fim_de_funcao()
  when UNDONE
    StudyItem.undone()
    fim_de_funcao()
  when EXIT
    system "clear"
    puts "Obrigado por utilizar o Diário de Estudos"
  else
    puts 'Opção inválida'
  end
end
