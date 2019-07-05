def some(**args)
  puts args[:local]
end

some(local: true, css: false)
params = {local: "Vasya", nelocal: "nevasya"}
puts params