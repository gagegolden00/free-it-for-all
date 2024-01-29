class CreateIpv4Quizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :ipv4_quizzes do |t|
      t.string :quiz_type, default: 'ipv4_quiz'
      t.integer :question_count, null: false
      t.integer :correct_count
      t.integer :incorrect_count
      t.references :user
      t.timestamps
    end
  end
end
