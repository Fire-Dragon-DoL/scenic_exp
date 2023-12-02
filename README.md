# README

Rails 7.1, Ruby 3.2.2, Scenic 1.7.0

How to replicate the issue:

```bash
rails new scenic_exp  --database=postgresql --minimal --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-active-job --skip-active-storage --skip-action-cable --skip-asset-pipeline --skip-javascript --skip-hotwire --skip-jbuilder --skip-test --skip-system-test --skip-bootsnap --skip-bundle
cd scenic_exp
```

Now add `gem "scenic"` to `Gemfile`, then execute:

```bash
bundle install
rails db:setup
rails g migration CreateFoods name:string
rails g migration CreateRecipes name:string
rails g migration DropRecipes
```

Edit the migration `xxx_drop_recipes.rb` to have the following code:

```ruby
class DropRecipes < ActiveRecord::Migration[7.1]
  def change
    drop_table :recipes do |t|
      t.string :name

      t.timestamps
    end
  end
end
```

Run

```bash
rails db:migrate
```

Finally running the following command will replicate the issue:

```bash
rails generate scenic:view recipes
```

The output is:

```
$ rails generate scenic:view recipes
      create  db/views/recipes_v01.sql
    conflict  db/migrate/20231202192024_create_recipes.rb
Another migration is already named create_recipes: /home/francesco/Projects/Experiments/scenic_exp/db/migrate/20231202191127_create_recipes.rb. Use --force to replace this migration or --skip to ignore conflicted file.
```

This will leave the system in an inconsistent stage because running `rails destroy scenic:view recipes` will also **destroy the migration**, which doesn't "belong" to scenic.
