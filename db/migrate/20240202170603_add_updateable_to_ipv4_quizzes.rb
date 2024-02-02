class AddUpdateableToIpv4Quizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :ipv4_quizzes, :updateable, :boolean, default: true
  end
end
