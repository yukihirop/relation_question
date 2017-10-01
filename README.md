# 手順

## 動作環境
- ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-darwin14]
- rails 5.1.0

## clone ＆ bundle

```bash
git clone git@github.com:yukihirop/relation_question.git
bundle
```


## relation.rbのinitializeを書き換える
別、shellを起動してactiverecord-5.1.0/lib/active_record/relation.rbを編集
```
cd vendor/bundle/ruby/2.4.0/gems/activerecord-5.1.0/lib/active_record
subl relation.rb
```

以下のように編集(binding.pryを挟むだけ)

[activerecord-5.1.0/lib/active_record/relation.rb](https://github.com/rails/rails/blob/master/activerecord/lib/active_record/relation.rb#L25-L32)
```diff
def initialize(klass, table, predicate_builder, values = {})
+  binding.pry if $binding_pry
  @klass  = klass
+  binding.pry if $binding_pry
  @table  = table
+  binding.pry if $binding_pry
  @values = values
+  binding.pry if $binding_pry
  @offsets = {}
+  binding.pry if $binding_pry
  @loaded = false
+  binding.pry if $binding.pry
  @predicate_builder = predicate_builder
+  binding.pry if $binding.pry
    end
```


## 実行
```
ruby relation_question.rb
```

あとは、`binding.pry if $binding_pry`で止まった所でselfを調べると上のようになる。

[activerecord-5.1.0/lib/active_record/relation.rb]
```diff
def initialize(klass, table, predicate_builder, values = {})
+  binding.pry if $binding_pry # self => #<Order::ActiveRecord_Relation:0x3fc204d40f20>
  @klass  = klass
+  binding.pry if $binding_pry # self => #<Order::ActiveRecord_Relation:0x3fc204d40f20>
  @table  = table
+  binding.pry if $binding_pry # self => #<Order::ActiveRecord_Relation:0x3fc204d40f20>
  @values = values
+  #
+  # what? what happen????
+  #
+  binding.pry if $binding_pry # self =>
+  # D, [2017-10-01T14:02:35.877510 #20045] DEBUG -- :   Order Load (0.3ms)  SELECT "orders".* FROM "orders"
+  # => [#<Order:0x007f84098aacc0 id: 1, name: "name_0", description: "description_0">,
+  #   #<Order:0x007f84098a2520 id: 2, name: "name_1", description: "description_1">,
+  #   #<Order:0x007f84098a23b8 id: 3, name: "name_2", description: "description_2">]
  @offsets = {}
+  binding.pry if $binding_pry # self => 一つ上に同じ
  @loaded = false
+  binding.pry if $binding.pry # self => １つ上に同じ
  @predicate_builder = predicate_builder
+  binding.pry if $binding.pry # self => １つ上に同じ
    end
```

## 質問
なぜ、selfが上のように途中でかわるのか？


