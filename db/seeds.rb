require 'faker'

# Create authors
authors = []
10.times do
  authors << Author.create!(
    name: Faker::Name.name
  )
end

# Create skills
skills = []
10.times do
  skills << Skill.create!(
    name: Faker::Job.field
  )
end

# Create courses and assign them to authors
courses = []
20.times do
  course = Course.create!(
    title: Faker::Educator.course_name,
    author: authors.sample
  )
  courses << course
end

# Randomly assign skills to courses
courses.each do |course|
  course_skills = skills.sample(rand(1..3))
  course.skills << course_skills
end

# rubocop:disable Rails/Output
puts "Created #{Author.count} authors"
puts "Created #{Course.count} courses"
puts "Created #{Skill.count} skills"
# rubocop:enable Rails/Output
