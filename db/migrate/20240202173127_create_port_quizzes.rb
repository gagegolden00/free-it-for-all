class CreatePortQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :port_quizzes do |t|

      t.timestamps
    end
  end
end
