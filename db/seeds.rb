# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Status.all.any?
  status = Status.create!([{ name: "Запланировано" }, { name: "В работе" }, { name: "Завершено" }, { name: "Отменено" }])
end

unless JobType.all.any?
  job_type = JobType.create!([{name: "Открытие"}, {name: "Профилактика"}, {name: "Закрытие"}])
end

unless UserRole.all.any?
  user_role = UserRole.create!([{role: "Admin"}, {role: "User"}])
end