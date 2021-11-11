SAIR = 9
require_relative 'study_item'

def menu()
  puts "[1] Cadastrar um item para estudar"
  puts "[2] Ver todos os itens cadastrados"
  puts "[3] Buscar um item de estudo"
  puts "[4] Remover item"
  puts "[5] Busca avançada"
  puts "[6] Listar por categoria"
  puts "[#{SAIR}] Sair"
  print "Escolha uma opção: "
  gets.to_i
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
  case opcao
  when 1
    system "clear"
    puts "Digite o item para estudo: "
    item = gets.chomp()
    categoria = selecionar_categoria()
    estudos = StudyItem.new(title: item, category: categoria)
    estudos.save_to_db
    opcao = 0
    puts "Item #{item} cadastrado com sucesso na categoria #{categoria}"
    gets
    system "clear"
  when 2
    system "clear"
    puts "Lista de itens cadastrados: "
    estudos = StudyItem.all
    estudos.each{|valor| puts "Item #{valor.title} na categoria #{valor.category}"}
    opcao = 0
    gets
    system "clear"
  when 3
    system "clear"
    puts "Qual item deseja encontrar: "
    busca = gets.chomp()
    puts "Itens encontrados: "
    busca = StudyItem.find_by_title(busca)
    busca.each{|valor| puts (valor.title + " / " + valor.category)}
    opcao = 0
    gets
    system "clear"
  when 4
    puts "Qual o titulo do item que deseja remover: "
    busca = gets.chomp
    StudyItem.delete(busca)
  when 5
    system "clear"
    puts "Qual item deseja encontrar: "
    busca = gets.chomp
    estudos = StudyItem.all
    estudos.map do |valor|
       if valor.title.include? busca
         puts "Item #{valor.title} na categoria #{valor.category}"
       end
     end
     gets
     system "clear"
  when 6
    categoria = selecionar_categoria()
    StudyItem.find_by_category(categoria)
    gets
    system "clear"
  when SAIR
    system "clear"
    puts "Obrigado por utilizar o Diário de Estudos"
  end
end
