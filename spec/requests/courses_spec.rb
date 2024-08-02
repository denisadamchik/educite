require 'swagger_helper'

RSpec.describe 'Courses API', type: :request do
  path '/authors/{author_id}/courses' do
    parameter name: 'author_id', in: :path, type: :integer, description: 'Author ID'

    get('list courses for an author') do
      tags 'Courses'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :array, items: {
          type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            author_id: { type: :integer },
            created_at: { type: :string },
            updated_at: { type: :string }
          }
        }

        let(:author) { Author.create(name: 'John Doe') }
        let!(:course) { Course.create(title: 'Ruby on Rails', author:) }
        let(:author_id) { author.id }

        run_test!
      end
    end

    post('create course') do
      tags 'Courses'
      consumes 'application/json'
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          course: {
            type: :object,
            properties: {
              title: { type: :string }
            },
            required: ['title']
          }
        },
        required: ['course']
      }

      response(201, 'successful') do
        let(:author) { Author.create(name: 'John Doe') }
        let(:course) { { course: { title: 'New Course' } } }
        let(:author_id) { author.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq('New Course')
        end
      end

      response(422, 'invalid request') do
        let(:author) { Author.create(name: 'John Doe') }
        let(:course) { { title: '' } }
        let(:author_id) { author.id }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq(["can't be blank"])
        end
      end
    end
  end

  path '/courses/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'Course ID'

    get('show course') do
      tags 'Courses'
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object, properties: {
          id: { type: :integer },
          title: { type: :string },
          author_id: { type: :integer },
          created_at: { type: :string },
          updated_at: { type: :string },
          skills: { type: :array, items: {
            type: :object,
            properties: {
              id: { type: :integer },
              name: { type: :string },
              created_at: { type: :string },
              updated_at: { type: :string }
            }
          } }
        }

        let(:author) { Author.create(name: 'John Doe') }
        let(:course) { Course.create(title: 'Ruby on Rails', author:) }
        let!(:skills) { [Skill.create(name: 'Design'), Skill.create(name: 'Healthcare')] }
        let(:id) { course.id }

        before do
          course.skills << skills
        end

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq('Ruby on Rails')
          expect(data['skills'].pluck('name')).to match_array(%w[Design Healthcare])
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    patch('update course') do
      tags 'Courses'
      consumes 'application/json'
      parameter name: :course, in: :body, schema: {
        type: :object,
        properties: {
          course: {
            type: :object,
            properties: {
              title: { type: :string },
              skill_ids: { type: :array, items: { type: :integer } }
            },
            required: ['title']
          }
        },
        required: ['course']
      }

      response(200, 'successful') do
        let(:author) { Author.create(name: 'John Doe') }
        let(:course) { Course.create(title: 'Ruby on Rails', author:) }
        let(:skill) { Skill.create(name: 'Ruby') }
        let(:id) { course.id }
        let(:course) { { course: { title: 'Updated Course', skill_ids: [skill.id] } } }

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['title']).to eq('Updated Course')
          expect(data['skills'].pluck('id')).to include(skill.id)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }
        let(:course) { { course: { title: 'Updated Course' } } }

        run_test!
      end
    end

    delete('delete course') do
      tags 'Courses'

      response(204, 'no content') do
        let(:author) { Author.create(name: 'John Doe') }
        let(:course) { Course.create(title: 'Ruby on Rails', author:) }
        let(:id) { course.id }

        run_test! do |_response|
          expect { Course.find(id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      response(404, 'not found') do
        let(:id) { 'invalid' }

        run_test!
      end
    end
  end
end
