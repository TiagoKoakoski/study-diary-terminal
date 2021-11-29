INSERT        = 1
VIEW          = 2
SEARCH        = 3
DELETE        = 4
DONE          = 5
LIST_CATEGORY = 6
LIST_DONE     = 7
UNDONE        = 8
EXIT          = 9

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

def wait_and_clear()
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
    wait_and_clear()
  when VIEW
    puts "Os itens cadastrados são: "
    StudyItem.print_list(StudyItem.all)
    wait_and_clear()
  when SEARCH
    StudyItem.search_item()
    wait_and_clear()
  when DELETE
    StudyItem.delete()
    wait_and_clear()
  when DONE
    StudyItem.done()
    wait_and_clear()
  when LIST_CATEGORY
    StudyItem.find_by_category()
    wait_and_clear()
  when LIST_DONE
    StudyItem.find_done()
    wait_and_clear()
  when UNDONE
    StudyItem.undone()
    wait_and_clear()
  when EXIT
    system "clear"
    puts "Obrigado por utilizar o Diário de Estudos"
  else
    puts 'Opção inválida'
  end
end
