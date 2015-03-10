Cat.destroy_all
cat1 = Cat.create(name: 'Gizmo', color: 'orange', sex: 'M', birth_date: Date.new(2007, 3, 5))
cat2 = Cat.create(name: 'Waffles', color: 'striped', sex: 'M', birth_date: Date.new(2013, 12, 25), description: 'he ate a bunch of waffles')
