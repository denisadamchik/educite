require 'rails_helper'

RSpec.describe AuthorDestroyer, type: :service do
  fixtures :authors, :courses

  context 'when another author exists' do
    it 'reassigns the courses to another author and destroys the author' do
      author = authors(:first_author)
      another_author = authors(:second_author)
      course = courses(:ruby_course)

      AuthorDestroyer.new(author).call

      expect(Course.find(course.id).author_id).to eq(another_author.id)
      expect { Author.find(author.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context 'when no other authors exist' do
    it 'destroys the author and deletes all associated courses' do
      author = authors(:first_author)
      course = courses(:ruby_course)
      AuthorDestroyer.new(authors(:second_author)).call

      AuthorDestroyer.new(author).call

      expect { Author.find(author.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect(Course.exists?(course.id)).to be_falsey
    end
  end
end
