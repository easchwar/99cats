Cat.destroy_all
cat1 = Cat.create(name: 'Gizmo', color: 'orange', sex: 'M', birth_date: Date.new(2007, 3, 5))
cat2 = Cat.create(name: 'Waffles', color: 'striped', sex: 'M', birth_date: Date.new(2013, 12, 25), description: 'he ate a bunch of waffles')

CatRentalRequest.create(cat_id: cat1.id, start_date: 3.days.ago,      end_date: Date.today)
CatRentalRequest.create(cat_id: cat1.id, start_date: Date.yesterday,  end_date: Date.tomorrow)
CatRentalRequest.create(cat_id: cat1.id, start_date: 4.days.ago,      end_date: Date.yesterday)
CatRentalRequest.create(cat_id: cat1.id, start_date: 2.days.ago,      end_date: Date.yesterday)
CatRentalRequest.create(cat_id: cat1.id, start_date: 4.days.ago,      end_date: Date.tomorrow)
CatRentalRequest.create(cat_id: cat1.id, start_date: 8.days.ago,      end_date: 7.days.ago)
