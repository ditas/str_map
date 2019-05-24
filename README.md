# StrMap
Works with Elixir maps where keys are strings
### What
It's a very basic module (not app) which helps to manage Elixir maps with string keys
### How
Let's say you have a map like this
```elixir
m = %{"a" => %{"b" => %{"c" => 1}, "b1" => 2}, "a1" => 3}
```
And you have to get the "c" value
```elixir
StrMap.get!(m, "a.b.c") # 1
```
That's it. \n
Now let's say the value under the "c" key is a list
```elixir
m = %{"a" => %{"b" => %{"c" => [1,2,3]}, "b1" => 2}, "a1" => 3}
```
We'd like to get the second element of the list (starting from 0)
```elixir
StrMap.get!(m, "a.b.c.[1]") # 2
```
Okay, seems legit. 
If we want to add some elements into the map
```elixir
StrMap.put!(m, "a.b.c.[3]", :test) # %{"a" => %{"b" => %{"c" => [1,2,3,:test]}, "b1" => 2}, "a1" => 3}
```
Basically, we can do something like this
```elixir
StrMap.put!(m, "a.b.c.[999]", :test) # %{"a" => %{"b" => %{"c" => [1,2,3,:test]}, "b1" => 2}, "a1" => 3}
```
We'll get the incoming value as the last element of the list. 
And we can update our map
```elixir
StrMap.put!(m, "a.b.c.[1]", :test) # %{"a" => %{"b" => %{"c" => [1,:test,3]}, "b1" => 2}, "a1" => 3}
```
If you want to add/replace some element
```elixir
m = StrMap.put!(m, "a.b.c.[1]", :test) # %{"a" => %{"b" => %{"c" => %{"d" => :test}}, "b1" => 2}, "a1" => 3}

m = StrMap.put!(m, "a.b.c.d", [4,5,6]) # %{"a" => %{"b" => %{"c" => %{"d" => [4, 5, 6]}}, "b1" => 2}, "a1" => 3}

m = StrMap.put!(m, "a.b.c.d.[1].e", :test) # %{"a" => %{"b" => %{"c" => %{"d" => [4, %{"e" => :test}, 6]}}, "b1" => 2},"a1" => 3}
```
### TODO
I guess I should add some tests
