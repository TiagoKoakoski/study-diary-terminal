require 'sqlite3'

class Task
  attr_accessor :title, :category

  def initialize(title:, category:)
    @title = title
    @category = category
  end

  def self.all
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    tasks = db.execute "SELECT title, category FROM tasks"
    db.close
    tasks.map {|task| new(title: task['title'], category: task['category']) }
  end

  def save_to_db
    db = SQLite3::Database.open "db/database.db"
    db.execute "INSERT INTO tasks VALUES('#{ title }', '#{ category }')"
    db.close
    self
  end

  def self.find_by_title(title)
    db = SQLite3::Database.open "db/database.db"
    db.results_as_hash = true
    tasks = db.execute "SELECT title, category FROM tasks where title='#{title}'"
    db.close
    tasks.map {|task| new(title: task['title'], category: task['category']) }
  end

end
