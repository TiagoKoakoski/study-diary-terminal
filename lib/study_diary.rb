CADASTRAR = 1
LISTAR = 2
BUSCAR = 3
REMOVER = 4
CONCLUIR = 5
POR_CATEGORIA = 6
CONCLUIDOS = 7
UNDONE = 8
SAIR = 9
require_relative 'study_item'

def menu()
  puts "//============================================//"
  puts "|| [#{CADASTRAR}] Cadastrar um item para estudar         ||"
  puts "|| [#{LISTAR}] Ver todos os itens cadastrados         ||"
  puts "|| [#{BUSCAR}] Buscar um item de estudo               ||"
  puts "|| [#{REMOVER}] Remover item                           ||"
  puts "|| [#{CONCLUIR}] Concluir item                          ||"
  puts "|| [#{POR_CATEGORIA}] Listar por categoria                   ||"
  puts "|| [#{CONCLUIDOS}] Ver os itens concluídos                ||"
  puts "|| [#{UNDONE}] Voltar a estudar                       ||"
  puts "|| [#{SAIR}] Sair                                   ||"
  puts "//============================================// "
  print "Escolha uma opção: "
  gets.to_i
end

def listar_itens()
  puts "Lista de itens cadastrados: "
  estudos = StudyItem.find_undone
  estudos.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
end

def listar_concluidos()
  puts "Lista de itens concluídos: "
  estudos = StudyItem.find_done
  estudos.each_with_index {|valor, ind| puts "[#{ind+1}] - #{valor.title} - #{valor.description} - Categoria: #{valor.category}"}
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

opcao = 0

puts "Bem-vindo ao Diário de Estudos, seu companheiro de estudos"

while opcao != SAIR
  opcao = menu()
  system "clear"
  case opcao
  when CADASTRAR
    system "clear"
    print "Digite o item para estudo: "
    item = gets.chomp().capitalize
    categoria = selecionar_categoria()
    print "Digite a descrição do item para estudo: "
    descricao = gets.chomp().capitalize
    estudos = StudyItem.new(title: item, category: categoria, description: descricao)
    estudos.save_to_db
    opcao = 0
    puts "Item #{item} cadastrado com sucesso na categoria #{categoria}"
    gets

  when LISTAR
    system "clear"
    listar_itens()
    gets

  when BUSCAR
    system "clear"
    puts "Qual item deseja encontrar: "
    busca = gets.chomp
    estudos = StudyItem.all
    estudos.map do |valor|
       if (valor.title.include? "/#{busca}/i" ) || (valor.description.include? "/#{busca}/i")
         puts " - #{valor.title} - #{valor.description} - Categoria #{valor.category}"
       end
     end
     gets

  when REMOVER
    lista = listar_itens()
    print "Qual o item que deseja remover: "
    selecao = gets.to_i
    selecao = lista[(selecao - 1)].title
    StudyItem.delete(selecao)
    puts "item removido com sucesso"
    gets

  when CONCLUIR
    lista = listar_itens()
    print "Qual o item que deseja concluir: "
    selecao = gets.to_i
    selecao = lista[(selecao - 1)].title
    StudyItem.done(selecao)
    puts "item concluído com sucesso"
    gets

  when POR_CATEGORIA
    categoria = selecionar_categoria()
    StudyItem.find_by_category(categoria)
    gets

  when CONCLUIDOS
    listar_concluidos()
    gets

  when UNDONE
    lista = listar_concluidos()
    print "Qual o item que deseja voltar a estudar: "
    selecao = gets.to_i
    selecao = lista[(selecao - 1)].title
    StudyItem.undone(selecao)
    puts "item retornou com sucesso"
    gets

  when SAIR
    system "clear"
    puts "Obrigado por utilizar o Diário de Estudos"
  end
end
