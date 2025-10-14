class CreateJogos < ActiveRecord::Migration[8.0]
  def change
    create_table :jogos do |t|
      t.string :titulo
      t.string :midia
      t.decimal :preco
      t.integer :estoque

      t.timestamps
    end
  end
end
