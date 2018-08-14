class CreateArticlesTags < ActiveRecord::Migration[5.2]
  def change
    create_table :articles_tags do |t|
      t.integer :article_id
      t.integer :tag_id
    end
  end
end
